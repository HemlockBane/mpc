import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/drop_items.dart';
import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_saving.dart';
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

  //TODO please generate this numbers better
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
    StringDropDownItem("11",title: "11th"),
    StringDropDownItem("12",title: "12th"),
    StringDropDownItem("13",title: "13th"),
    StringDropDownItem("14",title: "14th"),
    StringDropDownItem("15",title: "15th"),
    StringDropDownItem("16",title: "16th"),
    StringDropDownItem("17",title: "17th"),
    StringDropDownItem("18",title: "18th"),
    StringDropDownItem("19",title: "19th"),
    StringDropDownItem("20",title: "20th"),
    StringDropDownItem("21",title: "21st"),
    StringDropDownItem("22",title: "22nd"),
    StringDropDownItem("23",title: "23rd"),
    StringDropDownItem("24",title: "24th"),
    StringDropDownItem("25",title: "25th"),
    StringDropDownItem("26",title: "26th"),
    StringDropDownItem("27",title: "27th"),
    StringDropDownItem("28",title: "28th"),
    StringDropDownItem("29",title: "29th"),
    StringDropDownItem("30",title: "30th"),
    StringDropDownItem("31",title: "31st"),
  ];

  final weekDays = <StringDropDownItem>[
    StringDropDownItem("SUNDAY", title: "Sunday"),
    StringDropDownItem("MONDAY", title: "Monday"),
    StringDropDownItem("TUESDAY", title: "Tuesday"),
    StringDropDownItem("WEDNESDAY", title: "Wednesday"),
    StringDropDownItem("THURSDAY", title: "Thursday"),
    StringDropDownItem("FRIDAY", title: "Friday"),
    StringDropDownItem("SATURDAY", title: "Saturday"),
  ];

  int _currentPage = 0;
  int get currentPage => _currentPage;

  String? _flexSavingName;
  String? get flexSavingName => _flexSavingName;

  FlexSaveType? _savingType;
  FlexSaveMode? _savingMode;
  FlexSaveMode? get savingMode => _savingMode ?? FlexSaveMode.MONTHLY;
  int? _contributionMonthDay;
  String? _contributionWeekDay;

  // num? _flexSavingId;
  FlexSaving? _flexSaving;
  FlexSaving? get flexSaving => _flexSaving;

  bool? _isLoading;
  bool get isLoading => _isLoading ?? false;

  final _savingsNameController = StreamController<String>.broadcast();
  Stream<String> get savingNameStream => _savingsNameController.stream;

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

  void setFlexSaving(FlexSaving flexSaving) {
    _flexSaving = flexSaving;
  }

  @override
  void setAmount(double amount) {
    super.setAmount(amount);
    checkValidity();
  }

  void setFlexSavingName(String? name) {
    _flexSavingName = name;
    _savingsNameController.sink.add(name ?? "");
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
    final isFirstFormValid = (this.amount ?? 0.00) >= 1
        && sourceAccount != null && (_flexSavingName != null && _flexSavingName?.isNotEmpty == true);

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
        customerFlexSavingId: _flexSaving?.id,
        name: _flexSavingName
    );
    return this._flexConfigServiceDelegate.createFlexConfig(request);
  }

  @override
  void dispose() {
    _pageFormController.close();
    _savingModeController.close();
    _savingTypeController.close();
    _savingsNameController.close();
    _contributionMonthDayController.close();
    _contributionWeekDayController.close();
    super.dispose();
  }

}