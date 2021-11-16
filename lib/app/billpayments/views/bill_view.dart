import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/billpayments/viewmodels/bill_category_view_model.dart';
import 'package:moniepoint_flutter/app/billpayments/viewmodels/bill_history_view_model.dart';
import 'package:moniepoint_flutter/app/billpayments/viewmodels/bill_purchase_view_model.dart';
import 'package:moniepoint_flutter/app/billpayments/viewmodels/biller_view_model.dart';
import 'package:moniepoint_flutter/app/billpayments/views/bill_beneficiary_view.dart';
import 'package:moniepoint_flutter/app/billpayments/views/bill_category_list_view.dart';
import 'package:moniepoint_flutter/app/billpayments/views/bill_payment_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/views/moniepoint_scaffold.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:provider/provider.dart';

import 'biller_list_view.dart';

class BillScreen extends StatefulWidget {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _navigatorKey = GlobalKey<NavigatorState>();

  static const BILL_CATEGORY_SCREEN = "bill_category";
  static const BILL_BILLER_SCREEN = "bill_biller";
  static const BENEFICIARY_SCREEN = "bill_beneficiary";
  static const PAYMENT_SCREEN = "payment";

  BillScreen();

  @override
  State<StatefulWidget> createState() => _BillScreen();

}

class _BillScreen extends State<BillScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (v) => BillPurchaseViewModel()),
        ChangeNotifierProvider(create: (v) => BillHistoryViewModel()),
      ],
      child: MoniepointScaffold(
        key: widget._scaffoldKey,
        // resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: false,
          titleSpacing: 0,
          iconTheme: IconThemeData(color: Colors.primaryColor),
          title: Text('Bill Payment',
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.textColorBlack
              )
          ),
          backgroundColor: Color(0XFFE8EFFA).withOpacity(0.52),
          elevation: 0,
          actions: [
            TextButton.icon(
                onPressed: () => Navigator.of(context).pushNamed(Routes.BILL_HISTORY),
                icon: SvgPicture.asset("res/drawables/ic_history.svg"),
                label: Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Text(
                    "History",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.primaryColor
                    ),
                  ),
                )
            ),
          ],
        ),
        body: SessionedWidget(
          context: context,
          child: Container(
            color: Color(0XFFE8EFFA).withOpacity(0.52),
            child: Column(
              children: [
                SizedBox(height: 16),
                Expanded(
                  child: _BillViewNavigator(widget._scaffoldKey, widget._navigatorKey),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BillViewNavigator extends StatelessWidget {

  final GlobalKey<NavigatorState> _navigatorKey;
  final GlobalKey<ScaffoldState> _scaffoldKey;

  _BillViewNavigator(this._scaffoldKey, this._navigatorKey);

  Route _generateRoute(RouteSettings settings) {
    late Widget page;

    switch (settings.name) {
      case BillScreen.BILL_CATEGORY_SCREEN:
        page = ChangeNotifierProvider(
            create: (v) => BillCategoryViewModel(),
            child: BillCategoryListScreen(_scaffoldKey),
        );
        break;
      case BillScreen.BILL_BILLER_SCREEN:
        page = ChangeNotifierProvider(
          create: (v) => BillerViewModel(),
          child: BillerListScreen(_scaffoldKey),
        );
        break;
      case BillScreen.BENEFICIARY_SCREEN:
        page = BillBeneficiaryScreen(_scaffoldKey);
        break;
      case BillScreen.PAYMENT_SCREEN:
        page = BillPaymentScreen(_scaffoldKey);
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
        initialRoute: "bill_category",
        onGenerateRoute: _generateRoute,
      ),
    );
  }

}