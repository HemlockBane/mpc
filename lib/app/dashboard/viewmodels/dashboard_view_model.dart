import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/accounts/model/account_service_delegate.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_balance.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_status.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/tier.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/customer_service_delegate.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/data/account_upgrade_state.dart';
import 'package:moniepoint_flutter/app/dashboard/model/slider_item.dart';
import 'package:moniepoint_flutter/app/growth/growth_notification_data_bus.dart';
import 'package:moniepoint_flutter/app/growth/growth_notification_data_type.dart';
import 'package:moniepoint_flutter/app/growth/growth_notification_member.dart';
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
import 'package:collection/collection.dart';

class DashboardViewModel extends BaseViewModel implements GrowthNotificationMember {
  late final CustomerServiceDelegate _customerServiceDelegate;
  late final TransferBeneficiaryServiceDelegate _transferBeneficiaryDelegate;
  late final FileManagementServiceDelegate _fileServiceDelegate;

  bool _isAccountUpdateCompleted = true;
  bool get isAccountUpdateCompleted => _isAccountUpdateCompleted;

  DashboardViewModel(
      {AccountServiceDelegate? accountServiceDelegate,
      CustomerServiceDelegate? customerServiceDelegate,
      TransferBeneficiaryServiceDelegate? transferBeneficiaryDelegate,
      FileManagementServiceDelegate? fileServiceDelegate}) : super(accountServiceDelegate: accountServiceDelegate) {
    this._customerServiceDelegate = customerServiceDelegate ?? GetIt.I<CustomerServiceDelegate>();
    this._transferBeneficiaryDelegate = transferBeneficiaryDelegate ?? GetIt.I<TransferBeneficiaryServiceDelegate>();
    this._fileServiceDelegate = fileServiceDelegate ?? GetIt.I<FileManagementServiceDelegate>();
    GrowthNotificationDataBus.getInstance().subscribe(this);
  }

  final List<Tier> tiers = [];
  final List<SliderItem> sliderItems = [];

  ///For user profile image
  String? _userProfileBase64String;
  String? get userProfileBase64String => _userProfileBase64String;

  StreamController<DashboardState> _dashboardController = StreamController.broadcast();
  Stream<DashboardState> get dashboardUpdateStream => _dashboardController.stream;

  Stream<Resource<dynamic>> fetchAllAccountStatus() {
    return accountServiceDelegate!.updateAllAccountStatus();
  }

  ///TODO passing context here might be breaking principles
  void startSession(BuildContext context) {
    UserInstance().startSession(context);
    UserInstance().updateLastActivityTime();
  }

  Stream<Resource<List<Tier>>> getTiers() {
    return _customerServiceDelegate.getSchemes(fetchFromRemote: false).map((event) {
      if ((event is Success || event is Loading) && event.data?.isNotEmpty == true) {
        this.tiers.clear();
        this.tiers.addAll(event.data ?? []);
      }
      return event;
    });
  }

  Stream<Resource<List<TransferBeneficiary>>> getRecentlyPaidBeneficiary() {
    return _transferBeneficiaryDelegate.getFrequentBeneficiaries().asBroadcastStream();
  }

  Stream<Resource<FileResult>> getProfilePicture() {
    if (customer?.passportUUID == null) return Stream.empty();
    return _fileServiceDelegate.getFileByUUID(customer?.passportUUID ?? "", shouldFetchRemote: false)
        .map((event) {
      if (event is Success || event is Loading) {
        _userProfileBase64String = event.data?.base64String;
      }
      return event;
    });
  }

  Stream<Resource<AccountBalance>> getDashboardBalance({int? accountId, bool useLocal = true}) {
    return getCustomerAccountBalance(accountId: accountId, useLocal: useLocal).asBroadcastStream().map((event) {
      if(event is Success || event is Error) {
        update(DashboardState.DONE);
      }
      return event;
    });
  }

  void update(DashboardState state) {
    _dashboardController.sink.add(state);
  }

  void checkAccountUpdate() {
    final userAccount = UserInstance().userAccounts.firstOrNull;
    _isAccountUpdateCompleted = userAccount?.getAccountState() == AccountState.COMPLETED;
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
    final hasFingerprintPassword = (await biometricHelper.getFingerprintPassword()) != null;

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
    GrowthNotificationDataBus.getInstance().unsubscribe(this);
    super.dispose();
  }

  @override
  void accept(GrowthNotificationDataType event) {
    print(event);
  }
}

enum DashboardState {
  REFRESHING,
  DONE,
  ACCOUNT_STATUS_UPDATED
}