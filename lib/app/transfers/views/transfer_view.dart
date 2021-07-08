import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/transfers/model/data/single_transfer_transaction.dart';
import 'package:moniepoint_flutter/app/transfers/viewmodels/transfer_history_view_model.dart';
import 'package:moniepoint_flutter/app/transfers/viewmodels/transfer_view_model.dart';
import 'package:moniepoint_flutter/app/transfers/views/transfer_beneficiary_view.dart';
import 'package:moniepoint_flutter/app/transfers/views/transfer_history_view.dart';
import 'package:moniepoint_flutter/app/transfers/views/transfer_payment_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:moniepoint_flutter/core/views/transaction_tab.dart';
import 'package:provider/provider.dart';

class TransferScreen extends StatefulWidget {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _navigatorKey = GlobalKey<NavigatorState>();

  static const BENEFICIARY_SCREEN = "main";
  static const PAYMENT_SCREEN = "payment";

  TransferScreen();

  @override
  State<StatefulWidget> createState() {
    return TransferScreenState();
  }

}

class TransferScreenState extends State<TransferScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (v) => TransferViewModel()),
        ChangeNotifierProvider(create: (v) => TransferHistoryViewModel()),
      ],
      child: DefaultTabController(
        length: 2,
        child: Builder(
            builder: (mContext) {
              return Scaffold(
                resizeToAvoidBottomInset: false,
                key: widget._scaffoldKey,
                backgroundColor: Colors.backgroundWhite,
                appBar: AppBar(
                    centerTitle: false,
                    titleSpacing: -12,
                    iconTheme: IconThemeData(color: Colors.primaryColor),
                    title: Text('Transfers',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.darkBlue,
                            fontFamily: Styles.defaultFont,
                            fontSize: 17
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
                                color: Colors.primaryColor),
                            unselectedLabelColor: Color(0XFF8030424C),
                            tabs: [
                              Tab(
                                text: "Transfer",
                              ),
                              Tab(
                                text: "History",
                              )
                            ],
                          ),
                          Colors.tabBackground.withOpacity(0.16)),
                      Expanded(
                          child: TabBarView(
                              controller: DefaultTabController.of(mContext),
                              children: [
                                _TransferViewNavigator(widget._scaffoldKey, widget._navigatorKey),
                                TransferHistoryScreen(
                                  widget._scaffoldKey,
                                  replayTransactionCallback: (transaction) {
                                    DefaultTabController.of(mContext)?.animateTo(0);
                                    replayTransaction(transaction);
                                  },
                                ),
                              ]
                          )
                      )
                    ],
                  ),
                ),
              );
            }
        ),
      ),
    );
  }

  void replayTransaction(SingleTransferTransaction transaction) {
    this.widget._navigatorKey.currentState?.restorablePopAndPushNamed(
        TransferScreen.BENEFICIARY_SCREEN,
        arguments: {
          "replay": {
            "amount" : transaction.getAmount(),
            "accountNumber": transaction.getSinkAccountNumber(),
            "bankCode": transaction.transfer?.sinkAccountProviderCode,
            "bankName": transaction.transfer?.sinkAccountProviderName
          }
      }
    );
  }
}

class _TransferViewNavigator extends StatelessWidget {

  final GlobalKey<NavigatorState> _navigatorKey;
  final GlobalKey<ScaffoldState> _scaffoldKey;

  _TransferViewNavigator(this._scaffoldKey, this._navigatorKey);

  Route _generateRoute(RouteSettings settings) {
    late Widget page;
    switch (settings.name) {
      case TransferScreen.BENEFICIARY_SCREEN:
        page = TransferBeneficiaryScreen(_scaffoldKey, arguments: settings.arguments,);
        break;
      case TransferScreen.PAYMENT_SCREEN:
        final defaultAmount = settings.arguments != null ? settings.arguments as double : 0.0;
        page = TransferPaymentScreen(_scaffoldKey, defaultAmount);
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
    print("rebuild");
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