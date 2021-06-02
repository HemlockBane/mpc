import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/airtime/model/airtime_beneficiary_delegate.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/airtime/model/data/airtime_beneficiary.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/bills/model/data/bill_beneficiary.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/bills/model/data/bill_beneficiary_delegate.dart';
import 'package:moniepoint_flutter/core/paging/paging_source.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class AirtimeBeneficiaryViewModel extends BaseViewModel {

  late final AirtimeBeneficiaryServiceDelegate _delegate;

  AirtimeBeneficiaryViewModel({AirtimeBeneficiaryServiceDelegate? delegate}) {
    this._delegate = delegate ?? GetIt.I<AirtimeBeneficiaryServiceDelegate>();
  }

  PagingSource<int, AirtimeBeneficiary> getAirtimeBeneficiaries() => _delegate.getAirtimeBeneficiaries();

}