import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/flex_saving_config.dart';

class SetupFlexForm extends ChangeNotifier{
  final FlexSavingConfig _config = FlexSavingConfig(id: 0);

  final _frequencyController = StreamController<String>.broadcast();
  Stream<String> get frequencyStream => _frequencyController.stream;

  final _amountController = StreamController<String>.broadcast();
  Stream<String> get amountStream => _amountController.stream;

  // final _amountController = StreamController<String>.broadcast();
  // Stream<String> get amountStream => _amountController.stream;

  @override
  void dispose() {
    _frequencyController.close();
    _amountController.close();
    super.dispose();
  }
}