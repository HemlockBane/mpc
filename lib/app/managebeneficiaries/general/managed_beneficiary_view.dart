import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/managebeneficiaries/airtime/viewmodels/airtime_beneficiary_view_model.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/airtime/views/airtime_beneficiary_list_view.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/beneficiary.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/bills/viewmodels/bill_beneficiary_view_model.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/bills/views/bill_beneficiary_list_view.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/general/remove_beneficiary_dialog.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/general/remove_beneficiary_view_model.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/viewmodels/transfer_beneficiary_view_model.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/views/transfer_beneficiary_list_view.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:moniepoint_flutter/core/views/transaction_tab.dart';
import 'package:provider/provider.dart';

import 'beneficiary_list_state.dart';

class ManagedBeneficiaryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ManagedBeneficiaryScreen();

  static Future<bool> handleDeleteBeneficiary(BuildContext context, Beneficiary beneficiary, BeneficiaryType type) async {
    final result = await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (mContext) => ChangeNotifierProvider(
          create: (_) => RemoveBeneficiaryViewModel(),
          child: RemoveBeneficiaryDialog(type, beneficiary),
        ));

    if (result is bool && result) {
      String title;
      String message;
      switch (type) {
        case BeneficiaryType.AIRTIME:
          title = "Airtime Beneficiary Removed";
          message = "Airtime beneficiary has been removed successfully.";
          break;
        case BeneficiaryType.BILL:
          title = "Biller Beneficiary Removed";
          message = "Biller beneficiary has been removed successfully.";
          break;
        case BeneficiaryType.TRANSFER:
          title = "Transfer Beneficiary Removed";
          message = "Transfer beneficiary has been removed successfully.";
          break;
      }
      await showSuccess(context, title: title, message: message);
      return true;
    } else if(result is Error) {
      await showError(context, message: result.message);
      return false;
    }
    return false;
  }
}

class _ManagedBeneficiaryScreen extends State<ManagedBeneficiaryScreen> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  final GlobalKey<BeneficiaryListState> _transferBeneficiaryState = GlobalKey<BeneficiaryListState>();
  final GlobalKey<BeneficiaryListState> _airtimeBeneficiaryState = GlobalKey<BeneficiaryListState>();
  final GlobalKey<BeneficiaryListState> _billBeneficiaryState = GlobalKey<BeneficiaryListState>();

  void _registerTabController(TabController? controller) {
    if(controller != null) {
      controller.addListener(() {
        final currentTabIndex = controller.index;
        print(currentTabIndex);
        if(currentTabIndex == 0) {
          _searchController.text = _transferBeneficiaryState.currentState?.searchValue ?? "";
        } else if(currentTabIndex == 1) {
          _searchController.text = _airtimeBeneficiaryState.currentState?.searchValue ?? "";
        }
        else {
          _searchController.text = _billBeneficiaryState.currentState?.searchValue ?? "";
        }
      });
    }
  }

  void _updateSearch(int currentIndex, String value) {
    if (currentIndex == 0) {
      _transferBeneficiaryState.currentState?.updateSearch(value);
    } else if (currentIndex == 1) {
      _airtimeBeneficiaryState.currentState?.updateSearch(value);
    } else {
      _billBeneficiaryState.currentState?.updateSearch(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TransferBeneficiaryViewModel()),
          ChangeNotifierProvider(create: (_) => AirtimeBeneficiaryViewModel()),
          ChangeNotifierProvider(create: (_) => BillBeneficiaryViewModel()),
        ],
        child: SessionedWidget(
          context: context,
          child: DefaultTabController(
              length: 3,
              child: Builder(builder: (BuildContext mContext) {
                _registerTabController(DefaultTabController.of(mContext));
                return Scaffold(
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
                      elevation: 0
                  ),
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
                                controller: _searchController,
                                padding: EdgeInsets.only(top: 20, bottom: 20),
                                startIcon: Icon(CustomFont.search, color: Colors.colorFaded),
                                hint: 'Search Beneficiary',
                                fontSize: 13,
                                onChanged: (value) {
                                  final currentIndex = DefaultTabController.of(mContext)?.index;
                                  _updateSearch(currentIndex ?? 0, value);
                                }
                            ),
                          )
                      ),
                      SizedBox(height: 16,),
                      Expanded(
                          child: TabBarView(
                              children: [
                                TransferBeneficiaryListScreen(key: _transferBeneficiaryState,scaffoldKey: this._scaffoldKey, isSelectMode: false,),
                                AirtimeBeneficiaryListScreen(key:_airtimeBeneficiaryState,scaffoldKey: this._scaffoldKey, isSelectMode: false,),
                                BillBeneficiaryListScreen(key:_billBeneficiaryState,scaffoldKey: this._scaffoldKey, isSelectMode: false,)
                              ]
                          )
                      )
                    ],
                  ),
                );
              }))
        ),
    );
  }
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
