import 'dart:convert';
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_transaction.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/tier.dart';
import 'package:moniepoint_flutter/app/accounts/model/transaction_service_delegate.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/customer_service_delegate.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class AccountTransactionDetailViewModel extends BaseViewModel {
  late final TransactionServiceDelegate _delegate;
  late final CustomerServiceDelegate _customerServiceDelegate;
  final List<Tier> tiers = [];

  AccountTransactionDetailViewModel({TransactionServiceDelegate? delegate, CustomerServiceDelegate? customerServiceDelegate}) {
    this._delegate = delegate ?? GetIt.I<TransactionServiceDelegate>();
    this._customerServiceDelegate = customerServiceDelegate ?? GetIt.I<CustomerServiceDelegate>();

  }

  Future<AccountTransaction?> getSingleTransactionById(String transRef) {
    return _delegate.getSingleAccountTransaction(transRef);
  }

  Stream<Uint8List> downloadTransactionReceipt(AccountTransaction transaction) {
    print(jsonEncode(transaction.metaData));
    return _delegate.downloadTransactionReceipt(transaction);
  }

  Stream<Resource<List<Tier>>> getTiers() {
    return _customerServiceDelegate
        .getSchemes(fetchFromRemote: false)
        .map((event) {
      if ((event is Success || event is Loading) &&
          event.data?.isNotEmpty == true) {
        this.tiers.clear();
        this.tiers.addAll(event.data ?? []);
      }
      return event;
    });
  }
}
