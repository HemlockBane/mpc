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
      await showError(
          context, title: "Failed Removing Beneficiary", message: result.message
      );
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

  Widget _listSection(BuildContext mContext) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: Column(
        children: [
          SizedBox(height: 24),
          TransactionTab(tabBar: TabBar(
            isScrollable: true,
            padding: EdgeInsets.zero,
            labelPadding: EdgeInsets.only(left: 4, right: 4, bottom: 0, top: 0),
            indicatorPadding: EdgeInsets.only(left: 0, right: 0, bottom: 1, top: 0),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.primaryColor.withOpacity(0.1)
            ),
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.primaryColor.withOpacity(0.13),
            labelColor: Colors.primaryColor,
            tabs: [
              Tab(
                child: Container(
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Transfer"),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Airtime"),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Bills"),
                  ),
                ),
              )
            ],
          )),
          SizedBox(height: 21),
          Divider(
            color: Colors.black.withOpacity(0.1),
            height: 0.8,
          ),
          SizedBox(height: 22),
          Flexible(
              flex: 0,
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Styles.appEditText(
                    fillColor: Color(0XFF97A6C0).withOpacity(0.2),
                    controller: _searchController,
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    startIcon: Icon(CustomFont.search, color: Colors.black.withOpacity(0.3)),
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
                  key: _scaffoldKey,
                  backgroundColor: Colors.white,
                  extendBodyBehindAppBar: true,
                  appBar: AppBar(
                      centerTitle: false,
                      titleSpacing: 0,
                      iconTheme: IconThemeData(color: Colors.primaryColor),
                      title: Text('Settings',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.textColorBlack
                          )
                      ),
                      backgroundColor: Colors.backgroundWhite.withOpacity(0.05),
                      elevation: 0
                  ),
                  body: Container(
                    padding: EdgeInsets.only(top: 120),
                    decoration: BoxDecoration(
                        color: Colors.backgroundWhite,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("res/drawables/ic_app_new_bg.png")
                        )
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text(
                            "Manage\nBeneficiaries",
                            style: TextStyle(
                                color: Colors.textColorBlack,
                                fontSize: 24,
                                fontWeight: FontWeight.w700
                            ),
                          ),
                        ),
                        SizedBox(height: 2),
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text(
                            "Customize your Moniepoint experience",
                            style: TextStyle(
                              color: Colors.textColorBlack.withOpacity(0.5),
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        SizedBox(height: 26),
                        Expanded(child: _listSection(mContext))
                      ],
                    ),
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
