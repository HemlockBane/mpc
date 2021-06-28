import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:flutter/material.dart' hide ScrollView, Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_status.dart';
import 'package:moniepoint_flutter/app/customer/customer.dart';
import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/app/dashboard/viewmodels/dashboard_view_model.dart';
import 'package:moniepoint_flutter/app/dashboard/views/bottom_menu_view.dart';
import 'package:moniepoint_flutter/app/dashboard/views/dashboard_container_view.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/login_mode.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/biometric_helper.dart';
import 'package:moniepoint_flutter/core/utils/dashboard_util.dart';
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

class _DashboardScreen extends State<DashboardScreen> with WidgetsBindingObserver , TickerProviderStateMixin{

  late final AnimationController _bottomMenuController = AnimationController(
      duration: Duration(milliseconds: 700),vsync: this
  );
  late final AnimationController _dashboardCardController = AnimationController(duration: Duration(milliseconds: 800),vsync: this);
  late final AnimationController _greetingCardController = AnimationController(duration: Duration(milliseconds: 800), vsync: this);
  late DashboardViewModel _viewModel;

  PageController _pageController = PageController(viewportFraction: 1);
  GlobalKey<DashboardContainerViewState> _dashboardContainerState = GlobalKey();
  DrawerScaffoldController _drawerScaffoldController = DrawerScaffoldController();
  final pages = [];

  Widget _dashboardUpdateItem() {
    final width = MediaQuery.of(context).size.width * 0.13;
    return Material(
      child: Card(
        shadowColor: Colors.primaryColor.withOpacity(0.1),
        elevation: 4,
        margin: EdgeInsets.only(left: width, right: width, bottom: 8, top: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          onTap: () => (!_hasCompletedAccountUpdate())
              ? Navigator.of(context).pushNamed(Routes.ACCOUNT_UPDATE).then((_) => subscribeUiToAccountStatus())
              : setState(() => {}),
          child: Container(
            padding: EdgeInsets.only(left: 0, right: 16, top: 0, bottom: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Lottie.asset('res/drawables/dashboard_pop_icon.json', repeat: true),
                Flexible(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Upgrade Account', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.textColorBlack, fontSize: 17)),
                    SizedBox(height: 2),
                    Text('Upgrade your savings account to enjoy higher limits',
                        style: TextStyle(color: Colors.textColorBlack, fontSize: 12)
                    )
                  ],
                )),
                SizedBox(width: 16),
                SvgPicture.asset('res/drawables/ic_forward_arrow.svg', color: Colors.primaryColor)
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
    _viewModel.getUserAccountsBalance(useLocal: false).listen((event) {});
    subscribeUiToAccountStatus();
  }

  void subscribeUiToAccountStatus() {
    final viewModel = Provider.of<DashboardViewModel>(context, listen: false);
    viewModel.fetchAccountStatus().listen((event) {
      if(event.data is Success) setState(() {});
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

  Widget initialView({Color? backgroundColor, required Widget image}) {
    return Container(
      width: 40,
      height: 40,
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.1)
      ),
      child: Center(
        child: image,
      ),
    );
  }

  Widget _drawerListItem(String title, Widget res, VoidCallback onClick) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        highlightColor: Colors.white.withOpacity(0.1),
        overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.02)),
        onTap: onClick,
        child: Container(
          padding: EdgeInsets.only(left: 24, right: 0, top: 16, bottom: 16),
          child: Row(
            children: [
              initialView(
                  image: res
              ),
              SizedBox(width: 20,),
              Text(title, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: Styles.defaultFont),)
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerListContent() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 24,),
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: _drawerListItem('Account', SvgPicture.asset('res/drawables/ic_drawer_accounts.svg', color: Colors.white, width: 22, height: 22,), (){
              Navigator.of(context).pushNamed(Routes.ACCOUNT_TRANSACTIONS).then((value) => _refreshDashboard());
              _closeDrawerWithDelay();
            }),
          ),
          Padding(
            padding: EdgeInsets.only(left: 24, right: 16),
            child: Divider(height: 1, color: Colors.white.withOpacity(0.09),),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: _drawerListItem('Transfer',  SvgPicture.asset('res/drawables/ic_menu_transfer.svg', color: Colors.white,  width: 20, height: 20,) , (){
              _closeDrawerWithDelay().then((value) => Navigator.of(context).pushNamed(Routes.TRANSFER).then((value) => _refreshDashboard()));
            }),
          ),
          Padding(
            padding: EdgeInsets.only(left: 24, right: 16),
            child: Divider(height: 1, color: Colors.white.withOpacity(0.09),),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: _drawerListItem('Airtime & Data', SvgPicture.asset('res/drawables/ic_drawer_airtime_data.svg', color: Colors.white, width: 23, height: 23,), (){
              Navigator.of(context).pushNamed(Routes.AIRTIME).then((value) => _refreshDashboard());
              _closeDrawerWithDelay();
            }),
          ),
          Padding(
            padding: EdgeInsets.only(left: 24, right: 16),
            child: Divider(height: 1, color: Colors.white.withOpacity(0.09),),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: _drawerListItem('Bill Payment',  SvgPicture.asset('res/drawables/ic_menu_bills.svg', color: Colors.white, width: 23, height: 23,), (){
              Navigator.of(context).pushNamed(Routes.BILL).then((value) => _refreshDashboard());
              _closeDrawerWithDelay();
            }),
          ),
          Padding(
            padding: EdgeInsets.only(left: 24, right: 16),
            child: Divider(height: 1, color: Colors.white.withOpacity(0.09),),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: _drawerListItem('Card Management', SvgPicture.asset('res/drawables/ic_drawer_card_management.svg', color: Colors.white,  width: 16, height: 16,), (){
              Navigator.of(context).pushNamed(Routes.CARDS).then((value) => _refreshDashboard());
              _closeDrawerWithDelay();
            }),
          ),
        ],
      ),
    );
  }


  Future<Null> _closeDrawerWithDelay() {
    return Future.delayed(Duration(milliseconds: 200), (){
      _drawerScaffoldController.closeDrawer();
    });
  }

  Widget _drawerFooterView(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 24, bottom: 55),
      child: Row(
        children: [
          Styles.imageButton(
              onClick: () {
                Navigator.of(context).pushNamed(Routes.SETTINGS).then((value) => _refreshDashboard());
                _closeDrawerWithDelay();
              },
              color: Colors.white.withOpacity(0.1),
              padding: EdgeInsets.only(left: 9, right: 9, top: 8, bottom: 8),
              image: SvgPicture.asset('res/drawables/ic_dashboard_settings.svg', width: 22, height: 22,),
              borderRadius: BorderRadius.circular(30)
          ),
          SizedBox(width: 8,),
          Styles.imageButton(
              onClick: () {
                UserInstance().resetSession();
                _closeDrawerWithDelay().then((value) => Navigator.of(context).popAndPushNamed(Routes.LOGIN));
              },
              color: Colors.white.withOpacity(0.1),
              padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
              image: SvgPicture.asset('res/drawables/ic_logout.svg', width: 22, height: 22,),
              borderRadius: BorderRadius.circular(30)
          ),
          SizedBox(width: 8,)
        ],
      ),
    );
  }

  Widget _centerDashboardContainer(DashboardViewModel viewModel) {
    // final width = MediaQuery.of(context).size.width * 0.13;
    final items = [
      Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(16)
        ),
      ),
      Container(
        width: 200,
        decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(16)
        ),
      ),
      Container(
        width: 200,
        decoration: BoxDecoration(
            color: Colors.solidGreen,
            borderRadius: BorderRadius.circular(16)
        ),
      ),
      Container(
        width: 200,
        decoration: BoxDecoration(
            color: Colors.darkBlue,
            borderRadius: BorderRadius.circular(16)
        ),
      ),
      Container(
        width: 200,
        decoration: BoxDecoration(
            color: Colors.primaryColor,
            borderRadius: BorderRadius.circular(16)
        ),
      ),
    ];

    final pageController = PageController(viewportFraction: 0.72);

    return PageView.builder(
        controller: pageController,
        itemCount: _viewModel.customers.length,
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

                print("Degree $degree ---->>> Final Rotate To $rotateTo ---> Selected Page $selectedPage --->>> Index $index");
                return Transform.rotate(
                    angle: - rotateTo.toDouble(),
                    child: Transform.scale(
                        scale: scaleTo.toDouble(),
                        alignment: AlignmentDirectional.centerEnd,
                        origin: Offset(-150, 200),
                        child: Hero(
                            tag: "dashboard-balance-view-$index",
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
                                    onTap: () => Navigator.of(context).pushNamed(Routes.ACCOUNT_TRANSACTIONS).then((_) => _refreshDashboard()),
                                    child: DashboardContainerView(
                                      key: Key("$index"),
                                      viewModel: _viewModel,//TODO don't pass the view-model
                                      userAccount: _viewModel.userAccounts[index],
                                      position: index,
                                    )
                                ),
                              ),
                            )
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
        SideDrawer(
          alignment: Alignment.topLeft,
          direction: Direction.left, // Drawer position, left or right
          animation: true,
          color: Colors.colorPrimaryDark,
          percentage: 0.54,
          child: _drawerListContent(),
          footerView: _drawerFooterView(context),
          headerView: Container(
            padding: EdgeInsets.only(left: 24, right: 24, top: 40),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset('res/drawables/ic_moniepoint_cube.svg', width: 50, height: 50,),
                    Styles.imageButton(
                        color: Colors.transparent,
                        image: SvgPicture.asset('res/drawables/ic_cancel_dashboard.svg'),
                        onClick: () => _drawerScaffoldController.closeDrawer()
                    ),
                  ],
                ),
                SizedBox(
                  height: 68,
                ),
                Row(
                  children: [
                    DashboardUtil.getGreetingIcon(DashboardUtil.getTimeOfDay()),
                    SizedBox(width: 16,),
                    Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Good ${DashboardUtil.getTimeOfDay()}',
                              style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              _viewModel.accountName,
                              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                            )
                          ],
                        )
                    )
                  ],
                ),
                SizedBox(height: 32,),
                Row(
                  children: [
                    Text('NAVIGATION', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12, letterSpacing: 0.14, fontWeight: FontWeight.w600),),
                    SizedBox(width: 8,),
                    Flexible(child: Divider(height:1,color: Colors.white.withOpacity(0.3)))
                  ],
                )
              ],
            ),
          ),
        )
      ],
      builder: (mContext, a) {
        return  SessionedWidget(
            context: context,
            child: Container(
              width: double.infinity,
              color: Colors.backgroundWhite,
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
                            height: 108,
                            child: _buildDashboardSlider()
                        ),
                        SizedBox(height: 8),
                        DotIndicator(controller: _pageController, itemCount: pages.length),
                        SizedBox(height: 16),
                        AspectRatio(
                          aspectRatio: 3 / 3.1,
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
            )
        );
      },
    );
  }

  @override
  void initState() {
    _viewModel = Provider.of<DashboardViewModel>(context, listen: false);
    _viewModel.getUserAccountsBalance(useLocal: false).listen((event) { });
    super.initState();
    _bottomMenuController.forward().whenComplete(() => "");
    _dashboardCardController.forward();
    WidgetsBinding.instance?.addObserver(this);
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

    final isFingerPrintAvailable = await biometricHelper.isFingerPrintAvailable();
    final hasFingerprintPassword = (await biometricHelper.getFingerprintPassword()) != null;

    if (isFingerPrintAvailable.first && !hasFingerprintPassword) {
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
        showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (mContext) => BottomSheets.displaySuccessModal(mContext,
                title: "Fingerprint setup",
                message: "Fingerprint Setup successfully"
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // _lifecycleState = state;
    // if(state == AppLifecycleState.resumed) {
    //   subscribeUiToAccountStatus();
    // }
  }

  @override
  void dispose() {
    _dashboardCardController.dispose();
    _greetingCardController.dispose();
    _bottomMenuController.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }
}
