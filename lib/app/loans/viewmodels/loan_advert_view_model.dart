import 'dart:async';

import 'package:moniepoint_flutter/app/loans/models/short_term_loan_eligibility_criteria.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/network/service_error.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';
import 'package:rxdart/rxdart.dart';

class LoanAdvertViewModel extends BaseViewModel {

  final StreamController<bool> _eligibilityController = StreamController<bool>.broadcast();
  Stream<bool> get isValid => _eligibilityController.stream;


  Stream<Resource<ShortTermLoanEligibilityCriteria>> getEligibility() {
    final criteria = ShortTermLoanEligibilityCriteria.fromJson(json);
    final success = Resource.success(criteria);

    final error = Resource<ShortTermLoanEligibilityCriteria>.error(err: ServiceError(message: "error"));
    final loading = Resource<ShortTermLoanEligibilityCriteria>.loading(null);


    return Stream.value(success).map((event){
      _eligibilityController.sink.add(_isEligible(event));
      return event;
    });
  }


  bool _isEligible(Resource<ShortTermLoanEligibilityCriteria?>? _resource){
    if(_resource == null) return false;
    if (_resource is Error || _resource is Loading) return false;
    return _resource.data != null && _resource.data!.isEligible != null && _resource.data!.isEligible == true;
  }


  void dispose(){
    _eligibilityController.close();
    super.dispose();
  }

}

final json = {"passedCriteria": ["test", "test"], "failedCriteria": ["test"], "eligible": true};
