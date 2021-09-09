import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/airtime/viewmodels/airtime_history_view_model.dart';
import 'package:moniepoint_flutter/app/airtime/viewmodels/airtime_view_model.dart';
import 'package:moniepoint_flutter/app/airtime/views/airtime_beneficiary_view.dart';
import 'package:moniepoint_flutter/app/airtime/views/airtime_history_view.dart';
import 'package:moniepoint_flutter/app/airtime/views/airtime_payment_view.dart';
import 'package:moniepoint_flutter/app/transfers/views/transfer_beneficiary_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:moniepoint_flutter/core/views/transaction_tab.dart';
import 'package:provider/provider.dart';

class AirtimeScreen extends StatefulWidget {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _navigatorKey = GlobalKey<NavigatorState>();

  static const BENEFICIARY_SCREEN = "main";
  static const PAYMENT_SCREEN = "payment";

  AirtimeScreen();

  @override
  State<StatefulWidget> createState() {
    return _AirtimeScreen();
  }

}

class _AirtimeScreen extends State<AirtimeScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (v) => AirtimeViewModel()),
        ChangeNotifierProvider(create: (v) => AirtimeHistoryViewModel()),
      ],
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomInset:false,
          key: widget._scaffoldKey,
          backgroundColor: Colors.backgroundWhite,
          appBar: AppBar(
              centerTitle: false,
              titleSpacing: 0,
              iconTheme: IconThemeData(color: Colors.primaryColor),
              title: Text('Recharge',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.textColorBlack
                  )
              ),
              backgroundColor: Colors.backgroundWhite,
              elevation: 0
          ),
          body: SessionedWidget(
              context: context,
              child: Column(
                children: [
                  SizedBox(height: 16),
                  TransactionTab(
                      TabBar(
                        indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.primaryColor
                        ),
                        unselectedLabelColor: Color(0XFF8030424C),
                        tabs: [
                          Tab(
                            text: "Recharge",
                          ),
                          Tab(
                            text: "History",
                          )
                        ],
                      ),
                      Colors.tabBackground.withOpacity(0.1)),
                  Expanded(
                      child: TabBarView(
                          children: [
                            _AirtimeViewNavigator(widget._scaffoldKey, widget._navigatorKey),
                            AirtimeHistoryScreen(widget._scaffoldKey),
                          ]
                      )
                  )
                ],
              ),
          ),
        ),
      ),
    );
  }
}

class _AirtimeViewNavigator extends StatelessWidget {

  final GlobalKey<NavigatorState> _navigatorKey;
  final GlobalKey<ScaffoldState> _scaffoldKey;

  _AirtimeViewNavigator(this._scaffoldKey, this._navigatorKey);

  Route _generateRoute(RouteSettings settings) {
    late Widget page;

    switch (settings.name) {
      case AirtimeScreen.BENEFICIARY_SCREEN:
        page = AirtimeBeneficiaryScreen(_scaffoldKey);
        break;
      case AirtimeScreen.PAYMENT_SCREEN:
        page = AirtimePaymentScreen(_scaffoldKey);
        break;
    }

    return MaterialPageRoute(builder: (context) => page, settings: settings);
  }

  Future<bool> _onBackPressed() async {
    final isPop = await _navigatorKey.currentState?.maybePop();
    return (isPop != null && isPop) ? Future.value(false) : Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Navigator(
        key: _navigatorKey,
        initialRoute: "main",
        onGenerateRoute: _generateRoute,
      ),
    );
  }

}