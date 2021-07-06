import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/airtime/model/airtime_beneficiary_delegate.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/airtime/model/data/airtime_beneficiary.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/beneficiary.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/bills/model/data/bill_beneficiary.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/bills/model/data/bill_beneficiary_delegate.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/general/remove_beneficiary_dialog.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/data/transfer_beneficiary.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/transfer_beneficiary_delegate.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class RemoveBeneficiaryViewModel extends BaseViewModel {

  late final TransferBeneficiaryServiceDelegate _transferBeneficiaryServiceDelegate;
  late final AirtimeBeneficiaryServiceDelegate _airtimeBeneficiaryServiceDelegate;
  late final BillBeneficiaryServiceDelegate _billBeneficiaryServiceDelegate;


  RemoveBeneficiaryViewModel({
    TransferBeneficiaryServiceDelegate? transferBeneficiaryServiceDelegate,
    AirtimeBeneficiaryServiceDelegate? airtimeBeneficiaryServiceDelegate,
    BillBeneficiaryServiceDelegate? billBeneficiaryServiceDelegate,
  }) {
    this._transferBeneficiaryServiceDelegate = transferBeneficiaryServiceDelegate ?? GetIt.I<TransferBeneficiaryServiceDelegate>();
    this._airtimeBeneficiaryServiceDelegate = airtimeBeneficiaryServiceDelegate ?? GetIt.I<AirtimeBeneficiaryServiceDelegate>();
    this._billBeneficiaryServiceDelegate = billBeneficiaryServiceDelegate ?? GetIt.I<BillBeneficiaryServiceDelegate>();
  }

  Stream<Resource<bool>> deleteBeneficiary(Beneficiary b, String pin, BeneficiaryType type) {
    switch(type) {
      case BeneficiaryType.AIRTIME:
        return _airtimeBeneficiaryServiceDelegate.deleteAirtimeBeneficiary(b.getRecordId(), int.tryParse(pin) ?? 0, customerId).asyncMap((event) async {
          if(event is Success) await _airtimeBeneficiaryServiceDelegate.deleteLocalBeneficiary(b as AirtimeBeneficiary);
          return event;
        });
      case BeneficiaryType.BILL:
        return _billBeneficiaryServiceDelegate.deleteBillBeneficiary(b.getRecordId(), int.tryParse(pin) ?? 0, customerId).asyncMap((event) async {
          if(event is Success) await _billBeneficiaryServiceDelegate.deleteLocalBeneficiary(b as BillBeneficiary);
          return event;
        });
      case BeneficiaryType.TRANSFER:
        return _transferBeneficiaryServiceDelegate.deleteTransferBeneficiary(b.getRecordId(), int.tryParse(pin) ?? 0, customerId).asyncMap((event) async {
          if(event is Success) await _transferBeneficiaryServiceDelegate.deleteLocalBeneficiary(b as TransferBeneficiary);
          return event;
        });
    }
  }

}