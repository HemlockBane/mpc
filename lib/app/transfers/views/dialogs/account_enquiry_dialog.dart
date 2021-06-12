import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/customer/account_provider.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/data/transfer_beneficiary.dart';
import 'package:moniepoint_flutter/app/transfers/viewmodels/account_enquiry_view_model.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:provider/provider.dart';
import 'package:moniepoint_flutter/core/utils/text_utils.dart';

class AccountEnquiryDialog extends StatefulWidget {

  final AccountProvider _accountProvider;
  final TransferBeneficiary _beneficiary;
  final bool saveBeneficiary;

  AccountEnquiryDialog(this._accountProvider, this._beneficiary, {this.saveBeneficiary = true});

  @override
  State<StatefulWidget> createState() {
    return _AccountEnquiryDialog();
  }

}

class _AccountEnquiryDialog extends State<AccountEnquiryDialog> {

  Stream<Resource<TransferBeneficiary>>? fetchBeneficiaryStream;
  bool _saveBeneficiary = false;
  bool hasError = false;

  Widget _displayLoadingState() {
    return Container(
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // SizedBox(height: 50),
            SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(Colors.darkBlue),
              ),
            ),
            SizedBox(height: 24,),
            Text(
              'Fetching Beneficiary\nDetails...',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.darkBlue, fontSize: 16, fontWeight: FontWeight.w400),
            )
          ],
        ),
      ),
    );
  }

  void onConfirm(TransferBeneficiary beneficiary) {
    final mBeneficiary = TransferBeneficiary(
        id: 0,
        accountName: beneficiary.accountName,
        accountNumber: beneficiary.accountNumber,
        accountProviderName: widget._accountProvider.name,
        accountProviderCode: widget._accountProvider.bankCode
    );
    Navigator.of(context).pop(Tuple(mBeneficiary, _saveBeneficiary));
  }

  Widget _saveBeneficiaryWidget() {
    return Expanded(
        flex: 0,
        child: Container(
          padding: EdgeInsets.only(top: 0, bottom: 0),
          color: Colors.darkBlue.withOpacity(0.05),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Save beneficiary?',
                style: TextStyle(color: Colors.primaryColor, fontWeight: FontWeight.w600, fontSize: 14),
              ),
              SizedBox(width: 12),
              Switch(
                value: _saveBeneficiary,
                onChanged: (onChanged) => setState(()=> _saveBeneficiary = onChanged) ,
                trackColor: MaterialStateProperty.resolveWith((states) {
                  if(states.contains(MaterialState.selected)) {
                    return Colors.solidOrange.withOpacity(0.5);
                  } else {
                    return Colors.grey.withOpacity(0.5);
                  }
                }),
                thumbColor: MaterialStateProperty.resolveWith((states) {
                  if(states.contains(MaterialState.selected)) {
                    return Colors.solidOrange;
                  } else {
                    return Colors.white.withOpacity(0.5);
                  }
                }),
              )
            ],
          ),
        )
    );
  }

  Widget _mainContent(TransferBeneficiary beneficiary) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 24),
          Expanded(flex:0,child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('res/drawables/ic_beneficiary.svg'),
              SizedBox(width: 12),
              Text('${beneficiary.accountName}', style: TextStyle(color: Colors.solidDarkBlue, fontSize: 18, fontWeight: FontWeight.w600),)
            ],
          )),
          SizedBox(height: 2),
          Flexible(
            child: Text(
              '${widget._accountProvider.name} - ${beneficiary.accountNumber}',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.deepGrey, fontSize: 14, fontFamily: Styles.defaultFont),)
                .colorText({beneficiary.accountNumber : Tuple(Colors.deepGrey, null)}, underline: false),
          ),
          SizedBox(height: 24),
          Visibility(
              visible: widget.saveBeneficiary,
              child: _saveBeneficiaryWidget()
          ),
          SizedBox(height: widget.saveBeneficiary ? 52 : 32),
          Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 16),
                    Flexible(
                        flex: 1,
                        child: SizedBox(
                          width: double.infinity,
                          child: Styles.appButton(
                              paddingTop: 18,
                              paddingBottom: 18,
                              buttonStyle: Styles.greyButtonStyle,
                              onClick: () => Navigator.of(context).pop(),
                              text: 'Cancel',
                              elevation: 0),
                        )),
                    SizedBox(width: 32),
                    Flexible(
                        flex: 1,
                        child: SizedBox(
                          width: double.infinity,
                          child: Styles.appButton(
                              paddingTop: 18,
                              paddingBottom: 18,
                              onClick: () => onConfirm(beneficiary),
                              text: 'Confirm',
                              elevation: 0
                          ),
                        )),
                    SizedBox(width: 16),
                  ],
                )),
          SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _handleError(Error error) {
    Future.delayed(Duration(milliseconds: 100), () => Navigator.of(context).pop(error));
    return Container(color: Colors.white);
  }

  @override
  void initState() {
    final viewModel = Provider.of<AccountEnquiryViewModel>(context, listen: false);
    fetchBeneficiaryStream = viewModel.getAccountBeneficiary(
        widget._accountProvider.bankCode!, widget._beneficiary.accountNumber
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheets.makeAppBottomSheet(
      height: widget.saveBeneficiary ? 400 : 350,
      curveBackgroundColor: Colors.white,
      centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
      contentBackgroundColor: Colors.white,
      centerImageRes: 'res/drawables/ic_bank.svg',
      centerImageColor: Colors.primaryColor,
      centerImageWidth: 40,
      centerImageHeight: 40,
      content: StreamBuilder(
        stream: fetchBeneficiaryStream,
        builder: (c, AsyncSnapshot<Resource<TransferBeneficiary>> a) {
          final resource = a.data;
          if(!a.hasData || resource is Loading) return _displayLoadingState();
          if(a.data is Error || resource == null || resource.data == null) return _handleError(a.data as Error);
          return _mainContent(resource.data!);
        },
      )
    );
  }

}