import 'dart:async';
import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:moniepoint_flutter/app/airtime/viewmodels/airtime_view_model.dart';
import 'package:moniepoint_flutter/app/billpayments/viewmodels/bill_purchase_view_model.dart';
import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/beneficiary.dart';
import 'package:moniepoint_flutter/app/transfers/viewmodels/transfer_view_model.dart';

import 'models/transaction_meta_data.dart';

mixin PaymentViewModel {

  StreamController<bool> _isValidController = StreamController.broadcast();
  Stream<bool>? get isValid => _isValidController.stream;

  Beneficiary? _beneficiary;
  Beneficiary? get beneficiary => _beneficiary;

  double? get amount => _amount;
  double? _amount;

  bool? get saveBeneficiary => _saveBeneficiary;
  bool? _saveBeneficiary = false;

  String get pin => _pin;
  String _pin = "";

  UserAccount? _sourceAccount;
  UserAccount? get sourceAccount => _sourceAccount;

  Position? _paymentLocation;
  Position? get paymentLocation => _paymentLocation;

  void setSourceAccount(UserAccount? userAccount) {
    print(jsonEncode(userAccount));
    this._sourceAccount = userAccount;
  }
  void setSaveBeneficiary(bool save) => this._saveBeneficiary = save;
  void setBeneficiary(Beneficiary beneficiary) =>this._beneficiary = beneficiary;
  void setAmount(double amount) => this._amount = amount;
  void setPin(String pin) => this._pin = pin;
  void setLocation(Position? paymentLocation) {
    print(paymentLocation?.latitude);
    this._paymentLocation = paymentLocation;
  }


  TransactionMetaData buildTransactionMetaData(String type) {
    Location? mLocation;
    if(_paymentLocation != null)  {
      mLocation = Location(
          latitude: "${_paymentLocation?.latitude}",
          longitude: "${_paymentLocation?.longitude}"
      );
    }

    final String? name;

    if(this is BillPurchaseViewModel) name = _beneficiary?.getBeneficiaryProviderName();
    else if(this is AirtimeViewModel) name = _beneficiary?.getBeneficiaryDigits();
    else if(this is TransferViewModel) name = _beneficiary?.getAccountName();
    else throw UnsupportedError("Purchase not supported");

    final recipient = Recipient(
      name: name,
      accountNumber: (this is TransferViewModel) ? _beneficiary?.getBeneficiaryDigits() : null,
      bankName: (this is TransferViewModel) ? _beneficiary?.getBeneficiaryProviderName() : null,
      bankCode: (this is TransferViewModel) ? _beneficiary?.getBeneficiaryProviderCode() : null,
    );

    return TransactionMetaData(
      location: mLocation,
      transactionType: type,
      recipient: recipient
    );
  }

  void checkValidity() {
    _isValidController.sink.add(validityCheck());
  }

  bool validityCheck();

  void dispose() {
    _isValidController.close();
  }
}