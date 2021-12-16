import 'dart:async';
import 'dart:ui';

import 'package:moniepoint_flutter/app/dashboard/views/custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart' hide ScrollView, Colors;
import 'package:moniepoint_flutter/app/dashboard/viewmodels/dashboard_view_model.dart';
import 'package:moniepoint_flutter/app/dashboard/views/dashboard_bottom_menu.dart';
import 'package:moniepoint_flutter/app/loans/views/loans_home_view.dart';
import 'package:moniepoint_flutter/app/dashboard/views/dashboard_menu.dart';
import 'package:moniepoint_flutter/app/dashboard/views/dashboard_recently_paid_view.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/data/transfer_beneficiary.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/extensions/composite_disposable_widget.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/utils/biometric_helper.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/viewmodels/finger_print_alert_view_model.dart';
import 'package:moniepoint_flutter/core/views/finger_print_alert_dialog.dart';
import 'package:moniepoint_flutter/core/views/moniepoint_scaffold.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:provider/provider.dart';
import 'dashboard_account_card.dart';

import 'package:flutter/rendering.dart';

import 'dashboard_more_view.dart';
import '../../savings/views/savings_dasboard_view.dart';
import 'dashboard_notification_component.dart';
import 'dashboard_top_menu.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with CompositeDisposableWidget, TickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _savingsNavigatorKey = GlobalKey<NavigatorState>();
  late DashboardViewModel _viewModel;

  PageController _pageController = PageController(viewportFraction: 1);
  ScrollController _dashboardScrollController = ScrollController(keepScrollOffset: false);
  late final TabController _tabController = TabController(length: 4, vsync: this);

  Stream<Resource<List<TransferBeneficiary>>> recentlyPaidBeneficiaries = Stream.empty();
  final _tabIndexNotifier = ValueNotifier<int>(0);

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
      _viewModel.fetchAllAccountStatus().listen((event) {
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
    _tabController.addListener(() {
      final _currentPage = (_tabController.index).round();
      if(_tabController.index == _currentPage) {
        _tabIndexNotifier.value = _currentPage;
      }
    });

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      subscribeUiToAccountStatus();
    });
    Future.delayed(Duration(milliseconds: 1400), () => _setupFingerprint());
  }


  ///Main Content View of the dashboard
  _contentView(double width, double height) {
    return RefreshIndicator(
    displacement: 80,
    onRefresh: () async {
      _viewModel.update(DashboardState.REFRESHING);
      await for (var value in _viewModel.dashboardUpdateStream) {
        await Future.delayed(Duration(milliseconds: 100));
        if (value != DashboardState.DONE) return;
        return null;
      }
    },
    child: Container(
          width: double.infinity,
          height: height,
          color: Color(0XFFEBF2FA),
          child: Container(
            child: ListView(
              physics: AlwaysScrollableScrollPhysics(),
              controller: _dashboardScrollController,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    DashboardAccountCard(
                      viewModel: _viewModel,
                      pageController: _pageController,
                    ),
                    SizedBox(height: 32),
                    DashboardMenu(_onDrawerItemClickListener),
                    DashboardNotificationComponent(viewModel: _viewModel),
                    DashboardRecentlyPaidView(
                      beneficiaries: recentlyPaidBeneficiaries,
                      margin: EdgeInsets.only(left:16, right:16,bottom: 32, top: 32),
                    ),
                    //Margin is determined by DashboardRecentlyPaidView
                    SizedBox(height: 42),
                  ],
                )
              ],
            ),
          ),
        ),
  );
  }

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


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SessionedWidget(
      context: context,
      child: MoniepointScaffold(
          extendBodyBehindAppBar: true,
          extendBody: true,
          appBar: DashboardTopMenu(
            scrollController: _dashboardScrollController,
            viewModel: _viewModel,
            titles: ["Home", "Savings", "Loans", "More"],
            menuChangeNotifier: _tabIndexNotifier,
          ),
          key: _scaffoldKey,
          body: Container(
            child: TabBarView(
                controller: _tabController,
                children: [
                  LayoutBuilder(builder: (ctx, constraints) {
                    return _contentView(width, constraints.maxHeight);
                  }),
                  SavingsDashboardView(),
                  LoansHomeView(),
                  MoreView()
                ]
            )
          ),
          bottomNavigationBar: DashboardBottomMenu(_tabController)
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _dashboardScrollController.dispose();
    _tabController.dispose();
    super.dispose();
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