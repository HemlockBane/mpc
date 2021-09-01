import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart' hide ScrollView, Colors;
import 'package:flutter_html/shims/dart_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/dashboard/viewmodels/dashboard_view_model.dart';
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
import 'package:moniepoint_flutter/core/strings.dart';
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
                child: FingerPrintAlertDialog());
          });

      if (result != null && result is bool) {
        final successTitle = (biometricRequest.second == BiometricType.FINGER_PRINT)
            ? "Fingerprint setup"
            : "Face ID setup";

        final successMessage = (biometricRequest.second == BiometricType.FINGER_PRINT)
            ? "Fingerprint Setup successfully"
            : "Face ID Setup successfully";

        showSuccess(context,
            title: successTitle,
            message: successMessage,
            primaryButtonText: "Continue",
            onPrimaryClick: () => Navigator.of(context).pop(true)
        );
      } else if (result is Error<bool>) {
        showError(context, message: result.message);
      }
    }
  }

  void subscribeUiToAccountStatus() {
    Future.delayed(Duration(milliseconds: 1000), (){
      _viewModel.fetchAccountStatus().listen((event) {
        if(event is Success) {
          _viewModel.checkAccountUpdate();
          _viewModel.update();
        }
      }).disposedBy(this);
    });
  }

  _backgroundImage() => Positioned(
      top: 0,
      bottom: 0,
      right: 0,
      left: 0,
      child: IgnorePointer(
        child: Opacity(
          opacity: 0.2,
          child: FittedBox(
            fit: BoxFit.fill,
            child: Image.asset("res/drawables/ic_app_bg.png"),
          ),
        ),
      ));

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
        color: Color(0XFFEBF2FA),
        child: DashboardRefreshIndicator(
          viewModel: _viewModel,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                _DashboardBackground(
                    viewModel: _viewModel, 
                    width: width, 
                    height: height
                ),
                _DashboardTopMenu(
                    viewModel: _viewModel, scaffoldKey: _scaffoldKey),
                _backgroundImage(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * 0.16,
                      ),
                      RefreshSizedBox(viewModel: _viewModel),
                      AccountCard(
                          viewModel: _viewModel,
                          pageController: _pageController),
                      SizedBox(height: 32),
                      DashboardMenu(_onDrawerItemClickListener),
                      SizedBox(
                          height:
                              !_viewModel.isAccountUpdateCompleted ? 32 : 0),
                      StreamBuilder(
                          stream: _viewModel.dashboardController,
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
                      Text(
                        "Suggested for You",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.textColorBlack.withOpacity(0.6),
                        ),
                      ),
                      SizedBox(height: 16),
                      Expanded(flex: 0, child: SuggestedItems()),
                      SizedBox(height: 42),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );

  void _onDrawerItemClickListener(String routeName, position) async {
    switch(routeName) {
      case Routes.ACCOUNT_UPDATE:{
        await Navigator.of(context).pushNamed(routeName);
        subscribeUiToAccountStatus();
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
        _viewModel.update();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return SessionedWidget(
        context: context,
        child: Scaffold(
          key: _scaffoldKey,
          drawer: DashboardDrawer(width, _onDrawerItemClickListener),
          body: _contentView(width, height),
        ),
    );
  }
}

class _DashboardBackground extends StatelessWidget {
  const _DashboardBackground({
    Key? key,
    required DashboardViewModel viewModel, required this.height, required this.width,
  })  : _viewModel = viewModel,
        super(key: key);

  final DashboardViewModel _viewModel;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _viewModel.indicatorController,
        child: SizedBox(),
        builder: (ctx, child) {
          final animation = _viewModel.indicatorController;
          final yScale = (animation.value * 0.25) + 1.0;
          return Transform(
            transform: Matrix4.diagonal3Values(1.0, yScale, 1.0),
            child: Container(
              width: width,
              height: height * 0.35,
              child: SvgPicture.asset("res/drawables/bg.svg", fit: BoxFit.fill),
            ),
          );
        });
  }
}

class RefreshSizedBox extends StatefulWidget {
  const RefreshSizedBox({
    Key? key,
    required DashboardViewModel viewModel,
  })  : _viewModel = viewModel,
        super(key: key);

  final DashboardViewModel _viewModel;

  @override
  _RefreshSizedBoxState createState() => _RefreshSizedBoxState();
}

class _RefreshSizedBoxState extends State<RefreshSizedBox> {
  @override
  void initState() {
    widget._viewModel.dashboardController.listen((event) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: widget._viewModel.indicatorController,
        child: SizedBox(),
        builder: (ctx, child) {
          return Container(
            height: widget._viewModel.indicatorOffsetValue,
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
class _DashboardTopMenu extends StatefulWidget {
  final DashboardViewModel viewModel;
  final GlobalKey<ScaffoldState> scaffoldKey;

  _DashboardTopMenu({required this.viewModel, required this.scaffoldKey})
      : super(key: Key("_DashboardTopMenu"));

  @override
  __DashboardTopMenuState createState() => __DashboardTopMenuState();
}

class __DashboardTopMenuState extends State<_DashboardTopMenu> {
  ///Container that holds the user image loaded from remote service
  _userProfileImage(String base64String) => Container(
      height: 34,
      width: 34,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
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
  void initState() {
    widget.viewModel.dashboardController.listen((event) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final firstName = widget.viewModel.getFirstName();

    return Container(
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.074,
        left: 16,
        right: 16,
      ),
      child: Column(
        children: [
          AnimatedBuilder(
              animation: widget.viewModel.indicatorController,
              child: SizedBox(),
              builder: (ctx, child) {
                
                return Container(
                  height: widget.viewModel.indicatorOffsetValue,
                );
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Material(
                color: Colors.transparent,
                shape: CircleBorder(),
                child: InkWell(
                  onTap: () {
                    widget.scaffoldKey.currentState?.openDrawer();
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      "res/drawables/ic_dashboard_drawer_menu.svg",
                      height: 16,
                      width: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    firstName.isEmpty
                        ? "Hello"
                        : "Hello, ${firstName.toLowerCase().capitalizeFirstOfEach}",
                    style: TextStyle(
                        fontSize: 13.8,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  SizedBox(width: 9),
                  StreamBuilder(
                      stream: widget.viewModel.getProfilePicture(),
                      builder:
                          (ctx, AsyncSnapshot<Resource<FileResult>> snapShot) {
                        ///Only if the request is successful or it's loading with data
                        if (snapShot.hasData &&
                            (snapShot.data is Success ||
                                snapShot.data is Loading)) {
                          final data = snapShot.data?.data;
                          if (data?.base64String?.isNotEmpty == true) {
                            return _userProfileImage(data!.base64String!);
                          }
                        }
                        final localViewCachedImage =
                            widget.viewModel.userProfileBase64String;
                        if (localViewCachedImage != null &&
                            localViewCachedImage.isNotEmpty == true) {
                          return _userProfileImage(
                              widget.viewModel.userProfileBase64String!);
                        }
                        return _userProfilePlaceholder();
                      }),
                  SizedBox(width: 4)
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

///
///
///
///
///
///
///
class SuggestedItems extends Row {
  @override
  List<Widget> get children => _contentView();

  _contentView() => [
    Expanded(
        child: _SuggestedItem(
            backgroundColor: Colors.primaryColor,
            image: Image.asset(
              "res/drawables/ic_target.png",
              width: 150,
              height: 150,
            ),
            title: "Start\nSaving.")),
    SizedBox(width: 20.5),
    Expanded(
        child: _SuggestedItem(
            backgroundColor: Colors.solidGreen,
            image: Image.asset(
              "res/drawables/ic_dashboard_calendar.png",
              width: 150,
              height: 150,
            ),
            title: "Get a\nLoan.")),
  ];
}

///_SuggestedItem
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
class _SuggestedItem extends StatelessWidget {
  final Color backgroundColor;
  final String title;
  final Widget image;

  _SuggestedItem(
      {required this.backgroundColor,
      required this.image,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 198,
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 1),
              blurRadius: 2,
              color: Color(0xff1F0E4FB1).withOpacity(0.12),
            ),
          ]),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          overlayColor: MaterialStateProperty.all(backgroundColor.withRed(190)),
          highlightColor: backgroundColor.withOpacity(0.04),
          onTap: () => showComingSoon(context),
          child: Stack(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Positioned(
                top: 4,
                right: 0,
                child: image,
              ),
              Positioned(
                  left: 20,
                  bottom: 24,
                  child: Text(
                    title,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 19,
                        color: Colors.white),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
