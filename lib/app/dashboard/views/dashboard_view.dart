import 'package:flutter/material.dart' hide ScrollView, Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_status.dart';
import 'package:moniepoint_flutter/app/customer/customer.dart';
import 'package:moniepoint_flutter/app/dashboard/viewmodels/dashboard_view_model.dart';
import 'package:moniepoint_flutter/app/dashboard/views/bottom_menu_view.dart';
import 'package:moniepoint_flutter/app/dashboard/views/dashboard_container_view.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
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

class DashboardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DashboardScreen();
  }
}

class _DashboardScreen extends State<DashboardScreen> with WidgetsBindingObserver{

  PageController _pageController = PageController(viewportFraction: 1);
  GlobalKey<DashboardContainerViewState> _dashboardContainerState = GlobalKey();
  final pages = [];

  Widget dashboardUpdateItem() {
    final width = MediaQuery.of(context).size.width * 0.13;
    return Material(
      child: Card(
        shadowColor: Colors.primaryColor.withOpacity(0.1),
        elevation: 4,
        margin: EdgeInsets.only(left: width, right: width, bottom: 8, top: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          onTap: () => Navigator.of(context).pushNamed(Routes.ACCOUNT_UPDATE).then((_) => subscribeUiToAccountStatus()),
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

  Widget greetingItem() {
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
              padding: EdgeInsets.only(left: 0, right: 16, top: 0, bottom: 0),
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

  bool hasCompletedAccountUpdate() {
    final viewModel = Provider.of<DashboardViewModel>(context, listen: false);
    Customer? customer = viewModel.customer;
    AccountStatus? accountStatus = UserInstance().accountStatus;
    final flags = accountStatus?.listFlags() ?? customer?.listFlags();
    if(flags == null) return true;
    return flags.where((element) => element?.status != true).isEmpty;
  }

  void refreshDashboard() {
    setState(() {});
    _dashboardContainerState.currentState?.loadAccountBalance();
    subscribeUiToAccountStatus();
  }

  void subscribeUiToAccountStatus() {
    final viewModel = Provider.of<DashboardViewModel>(context, listen: false);
    viewModel.fetchAccountStatus().listen((event) => null);
  }

  Widget _buildDashboardSlider() {
    //Since we have only a single update page for now we can put it in here
    pages.clear();
    if (hasCompletedAccountUpdate()) {
      pages.add(greetingItem());
    } else {
      pages.add(dashboardUpdateItem());
    }

    return PageView.builder(
        itemCount: pages.length,
        controller: _pageController,
        itemBuilder: (BuildContext context, int index) {
      return pages[index % pages.length];
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<DashboardViewModel>(context, listen: false);
    final width = MediaQuery.of(context).size.width * 0.13;

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      drawerScrimColor: Colors.transparent,
      drawer: Drawer(
        elevation: 0,
        child: Column(
          children: [
            SizedBox(height: 100,),
            ListTile(
              title: Text('Settings'),
              onTap: () => Navigator.of(context).pushNamed(Routes.SETTINGS).then((value) => refreshDashboard()),
            ),
            ListTile(
              title: Text('Cards'),
              onTap: () => Navigator.of(context).pushNamed(Routes.CARDS).then((value) => refreshDashboard()),
            )
          ],
        ),
      ),
      body: SessionedWidget(
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
                      child: Container(
                        margin: EdgeInsets.only(left: width, right: width),
                        child: Material(
                          color: Colors.primaryColor,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                              customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              onTap: () => Navigator.of(context).pushNamed(Routes.ACCOUNT_TRANSACTIONS).then((_) => refreshDashboard()),
                              child: DashboardContainerView(_dashboardContainerState, viewModel)
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 110),
                  ],
                ),
              ),
              Positioned(
                  right: 20,
                  left: 20,
                  bottom: 0,
                  child: DashboardBottomMenu(() => refreshDashboard())
              )
            ],
          ),
        )
      ),
    );
  }

  @override
  void initState() {
    super.initState();
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

    if (fingerprintRequestCount >= 2) return;
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
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }
}
