import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/accounts/model/account_service_delegate.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_status.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/tier.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/customer_service_delegate.dart';
import 'package:moniepoint_flutter/app/dashboard/model/slider_item.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/data/transfer_beneficiary.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/transfer_beneficiary_delegate.dart';
import 'package:moniepoint_flutter/core/login_mode.dart';
import 'package:moniepoint_flutter/core/models/file_result.dart';
import 'package:moniepoint_flutter/core/models/services/file_management_service_delegate.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/biometric_helper.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class DashboardViewModel extends BaseViewModel {
  late final CustomerServiceDelegate _customerServiceDelegate;
  late final TransferBeneficiaryServiceDelegate _transferBeneficiaryDelegate;
  late final FileManagementServiceDelegate _fileServiceDelegate;

  bool _isAccountUpdateCompleted = true;
  bool get isAccountUpdateCompleted => _isAccountUpdateCompleted;

  DashboardViewModel(
      {AccountServiceDelegate? accountServiceDelegate,
      CustomerServiceDelegate? customerServiceDelegate,
      TransferBeneficiaryServiceDelegate? transferBeneficiaryDelegate,
      FileManagementServiceDelegate? fileServiceDelegate})
      : super(accountServiceDelegate: accountServiceDelegate) {
    this._customerServiceDelegate =
        customerServiceDelegate ?? GetIt.I<CustomerServiceDelegate>();
    this._transferBeneficiaryDelegate = transferBeneficiaryDelegate ??
        GetIt.I<TransferBeneficiaryServiceDelegate>();
    this._fileServiceDelegate =
        fileServiceDelegate ?? GetIt.I<FileManagementServiceDelegate>();
  }

  final List<Tier> tiers = [];
  final List<SliderItem> sliderItems = [];

  ///For user profile image
  String? _userProfileBase64String;
  String? get userProfileBase64String => _userProfileBase64String;

  StreamController<bool> _dashboardController = StreamController.broadcast();
  Stream<bool> get dashboardUpdateStream => _dashboardController.stream;

  StreamController<bool> _refreshDoneStreamController = StreamController.broadcast();
  Stream<bool> get refreshDoneStream => _refreshDoneStreamController.stream;

  StreamController<bool> _refreshStartStreamController = StreamController.broadcast();
  Stream<bool> get refreshStartStream => _refreshStartStreamController.stream;


  Stream<Resource<AccountStatus>> fetchAccountStatus() {
    return this.accountServiceDelegate!.getAccountStatus(customerAccountId);
  }

  ///TODO passing context here might be breaking principles
  void startSession(BuildContext context) {
    UserInstance().startSession(context);
    UserInstance().updateLastActivityTime();
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

  Stream<Resource<List<TransferBeneficiary>>> getRecentlyPaidBeneficiary() {
    return _transferBeneficiaryDelegate
        .getFrequentBeneficiaries()
        .asBroadcastStream();
  }

  String getFirstName() {
    return UserInstance().getUser()?.firstName ?? "";
  }

  Stream<Resource<FileResult>> getProfilePicture() {
    if (customer?.passportUUID == null) return Stream.empty();
    return _fileServiceDelegate
        .getFileByUUID(customer?.passportUUID ?? "")
        .map((event) {
      if (event is Success || event is Loading) {
        _userProfileBase64String = event.data?.base64String;
      }
      return event;
    });
  }

  void update() {
    _dashboardController.sink.add(true);
  }

  void startRefresh() {
    _refreshStartStreamController.sink.add(true);
  }

  void finishRefresh() {
    _refreshDoneStreamController.sink.add(true);
  }

  void checkAccountUpdate() {
    AccountStatus? accountStatus = UserInstance().accountStatus;
    final flags = accountStatus?.listFlags() ?? customer?.listFlags();
    if (flags == null) return;
    _isAccountUpdateCompleted =
        flags.where((element) => element?.status != true).isEmpty;
    _populateSliderItems();
  }


  void _populateSliderItems() {
    sliderItems.clear();
    if (isAccountUpdateCompleted) return;
    sliderItems.add(SliderItem(
        key: "account_update",
        primaryText: "Upgrade Account",
        secondaryText: "Upgrade your savings account\nto enjoy higher limits",
        iconPath: "res/drawables/ic_dashboard_edit.png"));
  }

  Future<Tuple<bool, BiometricType>> shouldRequestFingerPrintSetup() async {
    final fingerprintRequestCount =
        PreferenceUtil.getFingerprintRequestCounter();
    //We should only request 3 times from the dashboard
    if (fingerprintRequestCount >= 2 ||
        PreferenceUtil.getLoginMode() == LoginMode.ONE_TIME) {
      return Tuple(false, BiometricType.NONE);
    }
    final biometricHelper = BiometricHelper.getInstance();
    final biometricType = await biometricHelper.getBiometricType();
    final hasFingerprintPassword =
        (await biometricHelper.getFingerprintPassword()) != null;

    final shouldRequest =
        biometricType != BiometricType.NONE && !hasFingerprintPassword;
    if (shouldRequest) {
      PreferenceUtil.setFingerprintRequestCounter(fingerprintRequestCount + 1);
    }
    return Tuple(shouldRequest, biometricType);
  }

  @override
  void dispose() {
    _dashboardController.close();
    _refreshStartStreamController.close();
    _refreshDoneStreamController.close();
    super.dispose();
  }
}
