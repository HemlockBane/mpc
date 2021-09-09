import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/managebeneficiaries/airtime/viewmodels/airtime_beneficiary_view_model.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/airtime/views/airtime_beneficiary_list_view.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/general/beneficiary_list_state.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/viewmodels/transfer_beneficiary_view_model.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/views/transfer_beneficiary_list_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:provider/provider.dart';

class TransferSelectBeneficiaryScreen extends StatelessWidget {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<BeneficiaryListState> _transferBeneficiaryState = GlobalKey<BeneficiaryListState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => TransferBeneficiaryViewModel(),
        child: Scaffold(
          backgroundColor: Colors.backgroundWhite,
          key: _scaffoldKey,
          appBar: AppBar(
              centerTitle: false,
              titleSpacing: 0,
              iconTheme: IconThemeData(color: Colors.primaryColor),
              title: Text('Beneficiaries',
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
          body: Column(
            children: [
              SizedBox(height: 16),
              Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                child: Styles.appEditText(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    startIcon: Icon(CustomFont.search, color: Colors.colorFaded),
                    hint: 'Search Beneficiary',
                    fontSize: 13,
                    onChanged: (value) {
                      _transferBeneficiaryState.currentState?.updateSearch(value);
                    }
                ),
              ),
              SizedBox(height: 16,),
              Expanded(child: TransferBeneficiaryListScreen(key: _transferBeneficiaryState,scaffoldKey: _scaffoldKey))
            ],
          ),
        ),
    );
  }

}