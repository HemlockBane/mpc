import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/data/transfer_beneficiary.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/transfer_beneficiary_delegate.dart';
import 'package:moniepoint_flutter/core/paging/paging_source.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class TransferBeneficiaryViewModel extends BaseViewModel {

  late final TransferBeneficiaryServiceDelegate _delegate;

  TransferBeneficiaryViewModel({TransferBeneficiaryServiceDelegate? delegate}) {
    this._delegate = delegate ?? GetIt.I<TransferBeneficiaryServiceDelegate>();
  }

  PagingSource<int, TransferBeneficiary> getAccountBeneficiaries() => _delegate.getTransferBeneficiaries();

}