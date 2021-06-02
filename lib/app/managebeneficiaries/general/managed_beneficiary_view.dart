import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/airtime/views/airtime_beneficiary_view.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/airtime/viewmodels/bill_beneficiary_view_model.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/airtime/views/airtime_beneficiary_list_view.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/bills/viewmodels/bill_beneficiary_view_model.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/bills/views/bill_beneficiary_list_view.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/viewmodels/transfer_beneficiary_view_model.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/views/transfer_beneficiary_list_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/transaction_tab.dart';
import 'package:provider/provider.dart';

class ManagedBeneficiaryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ManagedBeneficiaryScreen();
}

class _ManagedBeneficiaryScreen extends State<ManagedBeneficiaryScreen> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TransferBeneficiaryViewModel()),
          ChangeNotifierProvider(create: (_) => AirtimeBeneficiaryViewModel()),
          ChangeNotifierProvider(create: (_) => BillBeneficiaryViewModel()),
        ],
        child: DefaultTabController(
            length: 3,
            child: Scaffold(
              backgroundColor: Colors.backgroundWhite,
              key: _scaffoldKey,
              appBar: AppBar(
                  centerTitle: false,
                  titleSpacing: -12,
                  iconTheme: IconThemeData(color: Colors.primaryColor),
                  title: Text('Manage Beneficiaries',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.darkBlue,
                          fontFamily: Styles.defaultFont,
                          fontSize: 17
                      )
                  ),
                  backgroundColor: Colors.backgroundWhite,
                  elevation: 0),
              body: Column(
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
                          Tab(text: "Transfer"),
                          Tab(text: "Airtime"),
                          Tab(text: "Bill Payment")
                        ],
                      ),
                      Colors.tabBackground.withOpacity(0.16)
                  ),
                  SizedBox(height: 24),
                  Flexible(
                      flex: 0,
                      child: Padding(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: Styles.appEditText(
                            padding: EdgeInsets.only(top: 20, bottom: 20),
                            startIcon: Icon(CustomFont.search, color: Colors.colorFaded),
                            hint: 'Search Beneficiary',
                            fontSize: 13
                        ),
                      )
                  ),
                  SizedBox(height: 16,),
                  Expanded(
                      child: TabBarView(
                          children: [
                            TransferBeneficiaryListScreen(scaffoldKey: this._scaffoldKey),
                            AirtimeBeneficiaryListScreen(scaffoldKey: this._scaffoldKey),
                            BillBeneficiaryListScreen(scaffoldKey: this._scaffoldKey)
                          ]
                      )
                  )
                ],
              ),
            )),
    );
  }
}
