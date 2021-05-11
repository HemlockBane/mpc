import 'package:moniepoint_flutter/app/securityquestion/model/data/security_question_request.dart';
import 'package:moniepoint_flutter/app/securityquestion/model/security_question_service.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';

import 'data/security_question.dart';

class SecurityQuestionDelegate with NetworkResource {
  late final SecurityQuestionService _service;

  SecurityQuestionDelegate(SecurityQuestionService service) {
    this._service = service;
  }

  Stream<Resource<List<SecurityQuestion>>> getAllQuestions() {
    return networkBoundResource(
        fetchFromLocal: () => Future.value(null),
        fetchFromRemote: () => this._service.getAllQuestions()
    );
  }

  Stream<Resource<SecurityQuestion>> getSecurityQuestionByUsername() {
    return networkBoundResource(
        fetchFromLocal: () => Future.value(null),
        fetchFromRemote: () {
          String username = UserInstance().getUser()?.username ?? "";
          return this._service.getQuestionByUsername(SecurityQuestionRequestBody().withUsername(username));
        }
    );
  }

  Stream<Resource<SecurityQuestion>> getSecurityQuestionByAccountNumber(String accountNumber) {
    return networkBoundResource(
        fetchFromLocal: () => Future.value(null),
        fetchFromRemote: () {
          return this._service.getQuestionByUsername(SecurityQuestionRequestBody().withAccountNumber(accountNumber));
        }
    );
  }


}