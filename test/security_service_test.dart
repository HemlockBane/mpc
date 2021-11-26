
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moniepoint_flutter/app/securityquestion/model/data/security_question.dart';
import 'package:moniepoint_flutter/app/securityquestion/model/security_question_delegate.dart';
import 'package:moniepoint_flutter/app/securityquestion/model/security_question_service.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:test/test.dart';
import 'security_service_test.mocks.dart';

@GenerateMocks([SecurityQuestionService])
void main() {
  test('Test that we can fetch questions successfully', () {
    //Arrange
    final securityService = MockSecurityQuestionService();
    final delegate = SecurityQuestionDelegate(securityService);

    final mockResponse = ServiceResult(true, <SecurityQuestion>[
      SecurityQuestion.fromJson({'id': 1, 'question': "Who is Paul Okeke"}),
      SecurityQuestion(2, 'who is Ayo Kolawole'),
      SecurityQuestion(3, 'who is Adrian Agho'),
    ], null, null);

    when(securityService.getAllQuestions())
        .thenAnswer((realInvocation) => Future.value(mockResponse));

    //Act
    final securityQuestions = delegate.getAllQuestions();

    //Assert
    expect(securityQuestions, emitsInOrder([
      isA<Loading>(),
      isA<Success<List<SecurityQuestion>>>().having((Success<List<SecurityQuestion>> e) => e.data?.length, 'length', equals(3)),
      emitsDone
    ]));

  });

}