import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/airtime/viewmodels/airtime_history_view_model.dart';
import 'package:moniepoint_flutter/app/airtime/viewmodels/airtime_view_model.dart';
import 'package:moniepoint_flutter/app/airtime/views/airtime_beneficiary_view.dart';
import 'package:moniepoint_flutter/app/airtime/views/airtime_payment_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/TransactionRequestContract.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:provider/provider.dart';

class AirtimeScreen extends StatefulWidget {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _navigatorKey = GlobalKey<NavigatorState>();

  static const BENEFICIARY_SCREEN = "main";
  static const PAYMENT_SCREEN = "payment";

  AirtimeScreen({
    this.transactionRequestContract
  });

  final TransactionRequestContract? transactionRequestContract;

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
                  Expanded(
                    child:_AirtimeViewNavigator(
                        widget._scaffoldKey,
                        widget._navigatorKey,
                        widget.transactionRequestContract
                    ),
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
  final TransactionRequestContract? transactionRequestContract;

  _AirtimeViewNavigator(this._scaffoldKey, this._navigatorKey, this.transactionRequestContract);

  Route _generateRoute(RouteSettings settings, TransactionRequestContract? contract) {
    late Widget page;

    switch (settings.name) {
      case AirtimeScreen.BENEFICIARY_SCREEN:
        page = AirtimeBeneficiaryScreen(_scaffoldKey, contract ?? transactionRequestContract);
        break;
      case AirtimeScreen.PAYMENT_SCREEN:
        final defaultAmount = settings.arguments != null ? settings.arguments as double : 0.0;
        page = AirtimePaymentScreen(_scaffoldKey, defaultAmount);
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
        onGenerateRoute: (settings) => _generateRoute(settings, transactionRequestContract),
      ),
    );
  }

}