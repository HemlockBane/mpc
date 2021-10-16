import 'dart:async';

import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';


class SavingsFlexSetupViewModel extends BaseViewModel{

  final StreamController<Tuple<int, bool>> _pageFormController = StreamController.broadcast();
  Stream<Tuple<int, bool>> get pageFormStream => _pageFormController.stream;

  void moveToNext(int currentIndex, {bool skip = false}) {
    _pageFormController.sink.add(Tuple(currentIndex, skip));
  }


  void moveToPrev(int index, {bool skip = false}) {
    _pageFormController.sink.add(Tuple(index, skip));
  }

  @override
  void dispose() {
    _pageFormController.close();
    super.dispose();
  }
}