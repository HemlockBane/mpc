import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/drop_items.dart';
import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_saving_config.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_saving_config_request_body.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/flex_config_service_delegate.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

import 'savings_view_model.dart';

class FlexSetupViewModel extends BaseViewModel with SavingsViewModel{

  late final FlexConfigServiceDelegate _flexConfigServiceDelegate;

  FlexSetupViewModel({FlexConfigServiceDelegate? flexConfigServiceDelegate}) {
    this._flexConfigServiceDelegate = flexConfigServiceDelegate ?? GetIt.I<FlexConfigServiceDelegate>();
  }

  final StreamController<Tuple<int, bool>> _pageFormController = StreamController.broadcast();
  Stream<Tuple<int, bool>> get pageFormStream => _pageFormController.stream;

  final monthDays = <StringDropDownItem>[
    StringDropDownItem("1",title: "1st"),
    StringDropDownItem("2",title: "2nd"),
    StringDropDownItem("3",title: "3rd"),
    StringDropDownItem("4",title: "4th"),
    StringDropDownItem("5",title: "5th"),
    StringDropDownItem("6",title: "6th"),
    StringDropDownItem("7",title: "7th"),
    StringDropDownItem("8",title: "8th"),
    StringDropDownItem("9",title: "9th"),
    StringDropDownItem("10",title: "10th"),
  ];

  final weekDays = <StringDropDownItem>[
    StringDropDownItem("Sunday"),
    StringDropDownItem("Monday"),
    StringDropDownItem("Tuesday"),
    StringDropDownItem("Wednesday"),
    StringDropDownItem("Thursday"),
    StringDropDownItem("Friday"),
    StringDropDownItem("Saturday"),
  ];

  int _currentPage = 0;
  int get currentPage => _currentPage;

  FlexSaveType? _savingType;
  FlexSaveMode? _savingMode;
  FlexSaveMode? get savingMode => _savingMode ?? FlexSaveMode.MONTHLY;
  int? _contributionMonthDay;
  String? _contributionWeekDay;

  num? _flexSavingId;

  bool? _isLoading;
  bool get isLoading => _isLoading ?? false;

  final _savingModeController = StreamController<FlexSaveMode>.broadcast();
  Stream<FlexSaveMode> get savingModeStream => _savingModeController.stream;

  final _savingTypeController = StreamController<FlexSaveType>.broadcast();
  Stream<FlexSaveType> get savingTypeStream => _savingTypeController.stream;

  final _contributionMonthDayController = StreamController<StringDropDownItem?>.broadcast();
  Stream<StringDropDownItem?> get contributionMonthDayStream => _contributionMonthDayController.stream;

  final _contributionWeekDayController = StreamController<StringDropDownItem?>.broadcast();
  Stream<StringDropDownItem?> get contributionWeekDayStream => _contributionWeekDayController.stream;

  void setCurrentPage(int currentPage) {
    this._currentPage = currentPage;
  }

  void moveToNext(int currentIndex, {bool skip = false}) {
    _pageFormController.sink.add(Tuple(currentIndex, skip));
  }

  void moveToPrev({bool skip = false}) {
    _pageFormController.sink.add(Tuple(-1, skip));
  }

  void setIsLoading(bool isLoading) {
    this._isLoading = isLoading;
  }

  void setFlexSavingId(num flexSavingId) {
    _flexSavingId = flexSavingId;
  }

  @override
  void setAmount(double amount) {
    super.setAmount(amount);
    checkValidity();
  }

  void setFlexSaveType(FlexSaveType? saveType) {
    _savingType = saveType;
    _savingTypeController.sink.add(saveType ?? FlexSaveType.AUTOMATIC);
    checkValidity();
  }

  void setSavingMode(FlexSaveMode? savingMode) {
    _savingMode = savingMode;
    _contributionMonthDay = null;
    _contributionWeekDay = null;
    _savingModeController.sink.add(savingMode ?? FlexSaveMode.MONTHLY);
    checkValidity();
  }

  void setContributionMonthDay(StringDropDownItem? monthDay) {
    _contributionMonthDay = int.tryParse(monthDay?.value ?? "");
    _contributionMonthDayController.sink.add(monthDay);
    checkValidity();
  }

  void setContributionWeekDay(StringDropDownItem? weekDay) {
    _contributionWeekDay = weekDay?.value;
    _contributionWeekDayController.sink.add(weekDay);
    checkValidity();
  }

  @override
  bool validityCheck() {
    final isFirstFormValid = (this.amount ?? 0.00) >= 1 && sourceAccount != null;

    if(_currentPage == 0) return isFirstFormValid;

    final isSecondFormValid = (savingMode == FlexSaveMode.MONTHLY)
        ? _contributionMonthDay != null
        : _contributionWeekDay != null;

    return isFirstFormValid && (savingMode != null && isSecondFormValid);
  }

  @override
  void setSourceAccount(UserAccount? userAccount) {
    super.setSourceAccount(userAccount);
    this.checkValidity();
  }

  Stream<Resource<FlexSavingConfig>> createFlexConfig() {
    final request = FlexSavingConfigRequestBody(
        flexSaveMode: _savingMode,
        flexSaveType: _savingType,
        contributionWeekDay: _contributionWeekDay,
        contributionMonthDay: _contributionMonthDay,
        customerAccountId: customerAccountId,
        customerId: customerId,
        contributionAmount: ((amount ?? 0.0) * 100).toInt(),
        customerFlexSavingId: _flexSavingId as int?
    );
    return this._flexConfigServiceDelegate.createFlexConfig(request);
  }

  @override
  void dispose() {
    _pageFormController.close();
    _savingModeController.close();
    _savingTypeController.close();
    _contributionMonthDayController.close();
    _contributionWeekDayController.close();
    super.dispose();
  }

}