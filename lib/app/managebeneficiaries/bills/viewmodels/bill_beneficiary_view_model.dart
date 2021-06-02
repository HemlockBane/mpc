import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/bills/model/data/bill_beneficiary.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/bills/model/data/bill_beneficiary_delegate.dart';
import 'package:moniepoint_flutter/core/paging/paging_source.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class BillBeneficiaryViewModel extends BaseViewModel {

  late final BillBeneficiaryServiceDelegate _delegate;

  BillBeneficiaryViewModel({BillBeneficiaryServiceDelegate? delegate}) {
    this._delegate = delegate ?? GetIt.I<BillBeneficiaryServiceDelegate>();
  }

  PagingSource<int, BillBeneficiary> getBillBeneficiaries() => _delegate.getBillBeneficiaries(customerId);


}