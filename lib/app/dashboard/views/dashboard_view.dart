import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/dashboard/views/custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart' hide ScrollView, Colors;
import 'package:moniepoint_flutter/app/dashboard/viewmodels/dashboard_view_model.dart';
import 'package:moniepoint_flutter/app/dashboard/views/dashboard_bottom_menu.dart';
import 'package:moniepoint_flutter/app/dashboard/views/dashboard_drawer_view.dart';
import 'package:moniepoint_flutter/app/dashboard/views/dashboard_loans_view.dart';
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
import 'package:moniepoint_flutter/core/paging/remote_mediator.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/biometric_helper.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/viewmodels/finger_print_alert_view_model.dart';
import 'package:moniepoint_flutter/core/views/finger_print_alert_dialog.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:provider/provider.dart';
import 'dashboard_account_card.dart';

import 'package:flutter/rendering.dart';

import 'dashboard_more_view.dart';
import 'dashboard_savings_view.dart';
import 'dashboard_top_menu.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with CompositeDisposableWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late DashboardViewModel _viewModel;

  PageController _pageController = PageController(viewportFraction: 1);
  late final PageController _tabPageController;


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
    _tabPageController = PageController(viewportFraction: 1);
    _tabPageController.addListener(() {
      final tabIndex = (_tabPageController.page ?? 0).round();
      setState(() {
        currentTabIndex = tabIndex;
      });

    });

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
                              DashboardTopMenu(
                                viewModel: _viewModel,
                                title: "Home",
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

  void _changeTab(int tabIndex) {
    _tabPageController.animateToPage(tabIndex, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final tabs = <Widget>[_contentView(width, height), SavingsView(), LoansView(), MoreView()];

    return SessionedWidget(
        context: context,
        child: Scaffold(
          key: _scaffoldKey,
          // drawer: DashboardDrawer(width, _onDrawerItemClickListener),
          body: PageView(
            controller: _tabPageController,
            children: tabs,
          ),
          bottomNavigationBar: AppBottomNavigationBar(
            selectedIndex: currentTabIndex,
            onTabSelected: _changeTab,
            items: [
              AppBottomNavigationBarItem(svgPath: "res/drawables/ic_dashboard_home.svg", title: "Home"),
              AppBottomNavigationBarItem(svgPath: "res/drawables/ic_dashboard_piggy.svg", title: "Savings"),
              AppBottomNavigationBarItem(svgPath: "res/drawables/ic_dashboard_loan.svg", title: "Loans"),
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
