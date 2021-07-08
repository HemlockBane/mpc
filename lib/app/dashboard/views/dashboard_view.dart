import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:flutter/material.dart' hide ScrollView, Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_status.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/tier.dart';
import 'package:moniepoint_flutter/app/customer/customer.dart';
import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/app/dashboard/viewmodels/dashboard_view_model.dart';
import 'package:moniepoint_flutter/app/dashboard/views/dashboard_drawer_view.dart';
import 'package:moniepoint_flutter/app/dashboard/views/bottom_menu_view.dart';
import 'package:moniepoint_flutter/app/dashboard/views/dashboard_container_view.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/login_mode.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/utils/biometric_helper.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:moniepoint_flutter/core/viewmodels/finger_print_alert_view_model.dart';
import 'package:moniepoint_flutter/core/views/dots_indicator.dart';
import 'package:moniepoint_flutter/core/views/finger_print_alert_dialog.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class DashboardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DashboardScreen();
  }
}

class _DashboardScreen extends State<DashboardScreen> with TickerProviderStateMixin{

  late final AnimationController _bottomMenuController = AnimationController(
      duration: Duration(milliseconds: 700),vsync: this
  );
  late final AnimationController _dashboardCardController = AnimationController(duration: Duration(milliseconds: 800),vsync: this);
  late final AnimationController _greetingCardController = AnimationController(duration: Duration(milliseconds: 800), vsync: this);
  late DashboardViewModel _viewModel;

  PageController _pageController = PageController(viewportFraction: 1);
  DrawerScaffoldController _drawerScaffoldController = DrawerScaffoldController();
  final pages = [];

  Widget _dashboardUpdateItem() {
    final width = MediaQuery.of(context).size.width * 0.13;
    return Material(
      color: Colors.transparent,
      child: Card(
        shadowColor: Colors.primaryColor.withOpacity(0.1),
        elevation: 0,
        color: Colors.primaryColor.withOpacity(0.1),
        margin: EdgeInsets.only(left: width, right: width, bottom: 8, top: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          onTap: () => (!_hasCompletedAccountUpdate())
              ? Navigator.of(context).pushNamed(Routes.ACCOUNT_UPDATE).then((_) => subscribeUiToAccountStatus())
              : setState(() => {}),
          child: Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset('res/drawables/ic_upgrade_account_2.svg',),
                SizedBox(width: 16),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Upgrade Account', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.primaryColor, fontSize: 15)),
                    SizedBox(height: 2),
                    Text('Upgrade your savings account\nto enjoy higher limits',
                        style: TextStyle(color: Colors.textColorBlack, fontSize: 12, fontWeight: FontWeight.normal)
                    )
                  ],
                )),
                SizedBox(width: 16),
                Expanded(
                    flex: 0,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: SvgPicture.asset('res/drawables/ic_forward_arrow.svg', color: Colors.primaryColor),
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _greetingItem() {
    final viewModel = Provider.of<DashboardViewModel>(context, listen: false);
    final width = MediaQuery.of(context).size.width * 0.13;

    return Material(
      color: Colors.transparent,
      child: Card(
        shadowColor: Colors.primaryColor.withOpacity(0.1),
        elevation: 4,
        margin: EdgeInsets.only(left: width, right: width, bottom: 8, top: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          onTap: () => null,
          child: Container(
              padding: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Hello ${viewModel.accountName},',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.textColorBlack,
                          fontSize: 17)),
                  SizedBox(height: 2),
                  Text('Remember to stay safe!',
                      style: TextStyle(color: Colors.textColorBlack, fontSize: 12))
                ],
              )),
        ),
      ),
    );
  }

  bool _hasCompletedAccountUpdate() {
    final viewModel = Provider.of<DashboardViewModel>(context, listen: false);
    Customer? customer = viewModel.customer;
    AccountStatus? accountStatus = UserInstance().accountStatus;
    final flags = accountStatus?.listFlags() ?? customer?.listFlags();
    if(flags == null) return true;
    return flags.where((element) => element?.status != true).isEmpty;
  }

  void _refreshDashboard() {
    setState(() {});
    print("refreshing dashboard");
    // _viewModel.getUserAccountsBalance(useLocal: false).listen((event) {});
    subscribeUiToAccountStatus();
  }

  void subscribeUiToAccountStatus() {
    final viewModel = Provider.of<DashboardViewModel>(context, listen: false);
    viewModel.fetchAccountStatus().listen((event) {
      if(event is Success) viewModel.update();
    });
  }

  Widget _buildDashboardSlider() {
    //Since we have only a single update page for now we can put it in here
    pages.clear();
    if (_hasCompletedAccountUpdate()) {
      pages.add(_greetingItem());
    } else {
      pages.add(_dashboardUpdateItem());
    }

    return PageView.builder(
        itemCount: pages.length,
        controller: _pageController,
        itemBuilder: (BuildContext context, int index) {
      return pages[index % pages.length];
    });
  }

  void _onDashboardItemClicked(UserAccount userAccount, int position) {
    if(UserInstance().accountStatus?.postNoDebit == false) {
      Navigator.of(context)
          .pushNamed(Routes.ACCOUNT_TRANSACTIONS,
          arguments: {"customerAccountId": userAccount.customerAccount?.id})
          .then((_) => _refreshDashboard()
      );
    } else {
      Navigator.of(context)
          .pushNamed(Routes.ACCOUNT_UPDATE).then((_) => subscribeUiToAccountStatus());
    }
  }

  Widget _centerDashboardContainer(DashboardViewModel viewModel) {
    final pageController = PageController(viewportFraction: 0.72);

    final qualifiedTierIndex = Tier.getQualifiedTierIndex(viewModel.tiers);
    final qualifiedTier = (viewModel.tiers.isNotEmpty) ? viewModel.tiers[qualifiedTierIndex] : null;

    return PageView.builder(
        controller: pageController,
        itemCount: _viewModel.customer?.customerAccountUsers?.length ?? 0,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
              animation: pageController,
              builder: (mContext, _) {

                num selectedPage =  (pageController.position.hasContentDimensions)
                    ? (pageController.page ?? pageController.initialPage)
                    : 0;

                num scaleTo = max(0.8, 1.0 - (selectedPage - index).abs());
                num degree = min(15,  1.0 + (15 - 1) * (selectedPage - index));
                num rotateTo = degree * pi / 360;

                final userAccount = _viewModel.userAccounts[index];
                return Transform.rotate(
                    angle: (selectedPage == index) ? 0 : - rotateTo.toDouble(),
                    child: Transform.scale(
                        scale: scaleTo.toDouble(),
                        alignment: AlignmentDirectional.centerEnd,
                        origin: Offset(-150, 200),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 24),
                          child: Hero(
                              tag: "dashboard-balance-view-${userAccount.customerAccount?.id}",
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                          color: UserInstance().accountStatus?.postNoDebit != true
                                              ? Colors.primaryColor.withOpacity(0.2)
                                              : Colors.postNoDebitColor,
                                          offset: Offset(0, 4),
                                          blurRadius: 5,
                                          spreadRadius: 1
                                      )
                                    ]
                                ),
                                child: Material(
                                  borderRadius: BorderRadius.circular(16),
                                  child: InkWell(
                                      customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      onTap: () => _onDashboardItemClicked(userAccount, index),
                                      child: DashboardContainerView(
                                        key: Key("$index"),
                                        viewModel: _viewModel,//TODO don't pass the view-model
                                        userAccount: userAccount,
                                        position: index,
                                        qualifiedTier: qualifiedTier,
                                      )
                                  ),
                                ),
                              )
                          ),
                        )
                    ),
                );
              }
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = Provider.of<DashboardViewModel>(context, listen: false);
    return DrawerScaffold(
      controller: _drawerScaffoldController,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      drawers: [
        DashboardDrawerView(
            context, _drawerScaffoldController,
            refreshCallback: _refreshDashboard,
            accountName: _viewModel.accountName
        ).getDrawer()
      ],
      builder: (mContext, a) {
        return  SessionedWidget(
            context: context,
            child: StreamBuilder(
              stream: _viewModel.dashboardController,
              builder: (ctx, _) {
                return Container(
                  width: double.infinity,
                  color: Color(0XFFEBF2FA),
                  child: Stack(
                    children: [
                      ScrollView(
                        child: Column(
                          children: [
                            Divider(color: Colors.dashboardTopBar, height: 4),
                            SizedBox(height: MediaQuery.of(context).padding.top + 32),
                            Text('OVERVIEW', style: TextStyle(color: Colors.textColorBlack, fontWeight: FontWeight.w400),),
                            SizedBox(height: 32),
                            SizedBox(
                                height: 90,
                                child: _buildDashboardSlider()
                            ),
                            SizedBox(height: 8),
                            DotIndicator(controller: _pageController, itemCount: pages.length, color: Colors.solidOrange,),
                            SizedBox(height: 16),
                            AspectRatio(
                              aspectRatio: 3 / 2.8, //UserInstance().accountStatus?.postNoDebit == true ? 3 / 2.8 : 3 / 2.5,
                              child: _centerDashboardContainer(_viewModel),
                            ),
                            SizedBox(height: 110),
                          ],
                        ),
                      ),
                      Positioned(
                          right: 20,
                          left: 20,
                          bottom: 0,
                          child: SlideTransition(
                            position: Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0))
                                .animate(CurvedAnimation(parent: _bottomMenuController, curve: Curves.easeInToLinear)),
                            child: DashboardBottomMenu(() => _refreshDashboard()),
                          )
                      )
                    ],
                  ),
                );
              },
            )
        );
      },
    );
  }

  void _onDashboardStartUp(){
    _viewModel = Provider.of<DashboardViewModel>(context, listen: false);
    _viewModel.getTiers().listen((event) {});
  }

  @override
  void initState() {
    _onDashboardStartUp();
    super.initState();
    _bottomMenuController.forward().whenComplete(() => "");
    _dashboardCardController.forward();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      subscribeUiToAccountStatus();
    });
    //let check if the user should set up finger print
    Future.delayed(Duration(milliseconds: 1400), () => _setupFingerprint());
  }

  void _setupFingerprint() async {
    final fingerprintRequestCount = PreferenceUtil.getFingerprintRequestCounter();

    //We should only request 3 times from the dashboard

    if (fingerprintRequestCount >= 2 || PreferenceUtil.getLoginMode() == LoginMode.ONE_TIME) return;
    final biometricHelper = BiometricHelper.getInstance();

    final biometricType = await biometricHelper.getBiometricType();
    final hasFingerprintPassword = (await biometricHelper.getFingerprintPassword()) != null;
    print("This is the Biometric Type $biometricType");
    if (biometricType != BiometricType.NONE && !hasFingerprintPassword) {
      PreferenceUtil.setFingerprintRequestCounter(fingerprintRequestCount + 1);

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

        final successTitle = (biometricType == BiometricType.FINGER_PRINT)
            ? "Fingerprint setup"
            : "Face ID setup";

        final successMessage = (biometricType == BiometricType.FINGER_PRINT)
            ? "Fingerprint Setup successfully"
            : "Face ID Setup successfully";

        showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (mContext) => BottomSheets.displaySuccessModal(mContext,
                title: successTitle,
                message: successMessage
            )
        );
      } else if (result is Error<bool>) {
        showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (mContext) => BottomSheets.displayErrorModal(mContext,
                message: result.message));
      }
    }
  }

  @override
  void dispose() {
    _dashboardCardController.dispose();
    _greetingCardController.dispose();
    _bottomMenuController.dispose();
    super.dispose();
  }
}