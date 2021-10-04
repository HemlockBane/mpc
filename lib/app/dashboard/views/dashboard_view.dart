import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:moniepoint_flutter/app/dashboard/views/custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart' hide ScrollView, Colors;
import 'package:moniepoint_flutter/app/dashboard/viewmodels/dashboard_view_model.dart';
import 'package:moniepoint_flutter/app/dashboard/views/dashboard_bottom_menu.dart';
import 'package:moniepoint_flutter/app/dashboard/views/dashboard_drawer_view.dart';
import 'package:moniepoint_flutter/app/dashboard/views/dashboard_menu.dart';
import 'package:moniepoint_flutter/app/dashboard/views/dashboard_recently_paid_view.dart';
import 'package:moniepoint_flutter/app/dashboard/views/dashboard_slider_view.dart';
import 'package:moniepoint_flutter/app/dashboard/views/dashboard_refresh_indicator.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/data/transfer_beneficiary.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_icons2_icons.dart';
import 'package:moniepoint_flutter/core/extensions/composite_disposable_widget.dart';
import 'package:moniepoint_flutter/core/models/file_result.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/utils/biometric_helper.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/viewmodels/finger_print_alert_view_model.dart';
import 'package:moniepoint_flutter/core/views/finger_print_alert_dialog.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:provider/provider.dart';
import 'dashboard_account_card.dart';

import 'package:flutter/rendering.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with CompositeDisposableWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late DashboardViewModel _viewModel;

  PageController _pageController = PageController(viewportFraction: 1);
  Stream<Resource<List<TransferBeneficiary>>> recentlyPaidBeneficiaries = Stream.empty();
  final double refreshIndicatorOffset = 70;
  int currentTabIndex = 0;

  void _setupFingerprint() async {
    final biometricRequest = await _viewModel.shouldRequestFingerPrintSetup();

    if (biometricRequest.first) {
      final result = await showModalBottomSheet(
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          context: context,
          builder: (mContext) {
            return ChangeNotifierProvider(
                create: (_) => FingerPrintAlertViewModel(),
                child: FingerPrintAlertDialog()
            );
          });

      final actionTitle = (biometricRequest.second == BiometricType.FINGER_PRINT)
          ? "Fingerprint setup"
          : "Face ID setup";

      if (result != null && result is bool) {

        final successMessage = (biometricRequest.second == BiometricType.FINGER_PRINT)
            ? "Fingerprint has been setup successfully"
            : "Face ID has been setup successfully";

        showSuccess(context,
            title: actionTitle,
            message: successMessage,
            primaryButtonText: "Continue",
            onPrimaryClick: () => Navigator.of(context).pop(true)
        );
      } else if (result is Error<bool>) {
        showError(context, title: "$actionTitle Failed", message: result.message);
      }
    }
  }

  void subscribeUiToAccountStatus() {
    Future.delayed(Duration(milliseconds: 800), (){
      _viewModel.fetchAccountStatus().listen((event) {
        if(event is Success) {
          _viewModel.checkAccountUpdate();
          _viewModel.update(DashboardState.ACCOUNT_STATUS_UPDATED);
        }
      }).disposedBy(this);
    });
  }

  @override
  void initState() {
    _viewModel = Provider.of<DashboardViewModel>(context, listen: false);
    _viewModel.startSession(context);
    _viewModel.checkAccountUpdate();
    recentlyPaidBeneficiaries = _viewModel.getRecentlyPaidBeneficiary();
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      subscribeUiToAccountStatus();
    });
    Future.delayed(Duration(milliseconds: 1400), () => _setupFingerprint());
  }

  ///Main Content View of the dashboard
  _contentView(double width, double height) => Container(
        width: double.infinity,
        height: height,
        color: Color(0XFFEBF2FA),
        child: Stack(
          children: [
            DashboardRefreshIndicator(
                indicatorOffset: refreshIndicatorOffset,
                viewModel: _viewModel,
                builder: (a, indicator) {
                  return  CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _DashboardTopMenu(
                                viewModel: _viewModel,
                                scaffoldKey: _scaffoldKey,
                                indicatorController: indicator,
                                indicatorOffset: refreshIndicatorOffset,
                              ),
                              SizedBox(height: 21),
                              RefreshSizedBox(
                                  indicatorController: indicator,
                                  indicatorOffset: refreshIndicatorOffset
                              ),
                              DashboardAccountCard(
                                viewModel: _viewModel,
                                pageController: _pageController,
                              ),
                              SizedBox(height: 32),
                              DashboardMenu(_onDrawerItemClickListener),
                              SizedBox(height: !_viewModel.isAccountUpdateCompleted ? 32 : 0),
                              StreamBuilder(
                                  stream: _viewModel.dashboardUpdateStream,
                                  builder: (_, __) {
                                    return DashboardSliderView(
                                      items: _viewModel.sliderItems,
                                      onItemClick: _onDrawerItemClickListener,
                                    );
                                  }),
                              SizedBox(height: 32),
                              DashboardRecentlyPaidView(
                                beneficiaries: recentlyPaidBeneficiaries,
                                margin: EdgeInsets.only(bottom: 32),
                              ),
                              //Margin is determined by DashboardRecentlyPaidView
                              SizedBox(height: 42),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                },
            ),
          ],
        ),
      );

  void _onDrawerItemClickListener(String routeName, position) async {
    switch(routeName) {
      case Routes.ACCOUNT_UPDATE:{
        await Navigator.of(context).pushNamed(routeName);
        subscribeUiToAccountStatus();
        _viewModel.update(DashboardState.REFRESHING);
        break;
      }
      case Routes.ACCOUNT_TRANSACTIONS: {
        if(_scaffoldKey.currentState?.isDrawerOpen == true) {
          Navigator.of(context).pop();
        }

        if(_viewModel.userAccounts.length == 0) return;

        // Get first user account by default
        final userAccount = _viewModel.userAccounts.first;
        final routeArgs = {"userAccountId": userAccount.id};
        await Navigator.of(context).pushNamed(routeName, arguments: routeArgs);
        _viewModel.update(DashboardState.REFRESHING);
        break;
      }
      case "LOGOUT":{
        UserInstance().resetSession();
        Navigator.of(context).pop();
        Navigator.of(context).popAndPushNamed(Routes.LOGIN);
        break;
      }
      case "COMING_SOON":{
        showComingSoon(context);
        break;
      }
      default: {
        if(_scaffoldKey.currentState?.isDrawerOpen == true) {
          Navigator.of(context).pop();
        }
        await Navigator.of(context).pushNamed(routeName);
        _viewModel.update(DashboardState.REFRESHING);
      }
    }
  }

  void _changeTab(String title, int tabIndex) {
    setState(() {
      currentTabIndex = tabIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final tabs = [_contentView(width, height), Container(), Container(), Container()];

    return SessionedWidget(
        context: context,
        child: Scaffold(
          key: _scaffoldKey,
          drawer: DashboardDrawer(width, _onDrawerItemClickListener),
          body: tabs[currentTabIndex],
          bottomNavigationBar: AppBottomNavigationBar(
            onItemClickListener: _changeTab,
            items: [
              AppBottomNavigationBarItem(svgPath: "res/drawables/ic_dashboard_home.svg", title: "Home"),
              AppBottomNavigationBarItem(svgPath: "res/drawables/ic_dashboard_piggy.svg", title: "Savings"),
              AppBottomNavigationBarItem(svgPath: "res/drawables/ic_dashboard_loan.svg", title: "Loan"),
              AppBottomNavigationBarItem(svgPath: "res/drawables/ic_dashboard_more.svg", title: "More")
            ],
          ),
        ),
    );
  }
}

///RefreshSizedBox
///
///
///
///
class RefreshSizedBox extends StatelessWidget {
  final IndicatorController indicatorController;
  final double indicatorOffset;

  RefreshSizedBox({
    Key? key,
    required this.indicatorController,
    required this.indicatorOffset
  }): super(key: key);

  @override
  Widget build(BuildContext context) {

    final animation = indicatorController;

    return AnimatedBuilder(
        animation: animation,
        child: SizedBox(),
        builder: (ctx, child) {
          final offsetValue = indicatorController.value * indicatorOffset;
          return Container(
            height: offsetValue,
          );
        });
  }
}

///_DashboardTopMenu
///
///
///
///
///
///
///
///
///
///
///
///
class _DashboardTopMenu extends StatelessWidget {
  final DashboardViewModel viewModel;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final IndicatorController indicatorController;
  final double indicatorOffset;

  _DashboardTopMenu({
    required this.viewModel,
    required this.scaffoldKey,
    required this.indicatorController,
    required this.indicatorOffset
  }) : super(key: Key("_DashboardTopMenu"));

  ///Container that holds the user image loaded from remote service
  _userProfileImage(String base64String) => Container(
      height: 38,
      width: 38,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            color: Colors.primaryColor.withOpacity(0.13),
            width: 3,
        ),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: MemoryImage(
            base64Decode(base64String),
          ),
        ),
      ));

  _userProfilePlaceholder() => Container(
        height: 34,
        width: 34,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.2),
            border: Border.all(color: Colors.white.withOpacity(0.4))),
        child: Icon(
          CustomIcons2.username,
          color: Color(0xffF5F9FF).withOpacity(0.5),
          size: 21,
        ),
      );


  @override
  Widget build(BuildContext context) {
    final animation = indicatorController;

    return Container(
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.05,
      ),
      child: Column(
        children: [
          AnimatedBuilder(
              animation: animation,
              child: SizedBox(),
              builder: (ctx, child) {
               final offsetValue = indicatorController.value * indicatorOffset;
                return Container(
                  height: offsetValue
                );
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamBuilder(
                  stream: viewModel.getProfilePicture(),
                  builder: (ctx, AsyncSnapshot<Resource<FileResult>> snapShot) {
                    if (snapShot.hasData && (snapShot.data is Success || snapShot.data is Loading)) {
                      final data = snapShot.data?.data;
                      if (data?.base64String?.isNotEmpty == true) {
                        return _userProfileImage(data!.base64String!);
                      }
                    }

                    final localViewCachedImage = viewModel.userProfileBase64String;
                    if (localViewCachedImage != null
                        && localViewCachedImage.isNotEmpty == true) {
                      return _userProfileImage(viewModel.userProfileBase64String!);
                    }

                    return _userProfilePlaceholder();
                  }),
              Text(
                "Home",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.textColorBlack),
              ),
              Container(width: 40,)
            ],
          ),
        ],
      ),
    );
  }
}
