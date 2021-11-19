import 'dart:async';

import 'package:moniepoint_flutter/app/accountupdates/model/drop_items.dart';
import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

import 'SavingsViewModel.dart';

class FlexSetupViewModel extends BaseViewModel with SavingsViewModel{

  final StreamController<Tuple<int, bool>> _pageFormController = StreamController.broadcast();
  Stream<Tuple<int, bool>> get pageFormStream => _pageFormController.stream;

  final monthDays = <StringDropDownItem>[
    StringDropDownItem("1st"),
    StringDropDownItem("2nd"),
    StringDropDownItem("3rd"),
    StringDropDownItem("4th"),
    StringDropDownItem("5th"),
    StringDropDownItem("6th"),
    StringDropDownItem("7th"),
  ];

  int _currentPage = 0;
  String? _frequency;
  String? _savingMode;
  int? _contributionMonthDay;
  String? _contributionWeekDay;

  final _savingModeController = StreamController<String>.broadcast();
  Stream<String> get savingModeStream => _savingModeController.stream;

  final _contributionMonthDayController = StreamController<int>.broadcast();
  Stream<int> get contributionMonthDayStream => _contributionMonthDayController.stream;

  final _contributionWeekDayController = StreamController<StringDropDownItem?>.broadcast();
  Stream<StringDropDownItem?> get contributionWeekDayStream => _contributionWeekDayController.stream;

  void moveToNext(int currentIndex, {bool skip = false}) {
    _currentPage = currentIndex;
    _pageFormController.sink.add(Tuple(currentIndex, skip));
  }

  void moveToPrev({bool skip = false}) {
    _pageFormController.sink.add(Tuple(-1, skip));
  }

  @override
  void setAmount(double amount) {
    super.setAmount(amount);
    checkValidity();
  }

  void setFrequency(String? frequency) {
    _frequency = frequency;
    checkValidity();
  }

  void setSavingMode(String? savingMode) {
    _savingMode = savingMode;
    _savingModeController.sink.add(savingMode ?? "");
    checkValidity();
  }

  void setContributionMonthDay(int? monthDay) {
    _contributionMonthDay = monthDay;
    _contributionMonthDayController.sink.add(monthDay ?? 0);
    checkValidity();
  }

  void setContributionWeekDay(StringDropDownItem? weekDay) {
    _contributionWeekDay = weekDay?.value;
    _contributionWeekDayController.sink.add(weekDay);
    checkValidity();
  }

  @override
  bool validityCheck() => (this.amount ?? 0.00) >= 1 && sourceAccount != null;

  @override
  void setSourceAccount(UserAccount? userAccount) {
    super.setSourceAccount(userAccount);
    this.checkValidity();
  }

  @override
  void dispose() {
    _pageFormController.close();
    _savingModeController.close();
    _contributionMonthDayController.close();
    _contributionWeekDayController.close();
    super.dispose();
  }

}