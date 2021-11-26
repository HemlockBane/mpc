import 'dart:math';

import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/data/transfer_beneficiary.dart';
import 'package:moniepoint_flutter/app/onboarding/model/account_creation_service.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/account_info_request.dart';
import 'package:moniepoint_flutter/app/onboarding/model/onboarding_service.dart';
import 'package:moniepoint_flutter/app/onboarding/model/onboarding_service_delegate.dart';
import 'package:moniepoint_flutter/app/onboarding/viewmodel/onboarding_view_model.dart';
import 'package:moniepoint_flutter/app/securityquestion/model/data/security_question.dart';
import 'package:moniepoint_flutter/app/securityquestion/model/security_question_delegate.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:test/test.dart';
import 'onboarding_service_test.mocks.dart';

@GenerateMocks([OnBoardingService, AccountCreationService, SecurityQuestionDelegate])
void main() {
  test('test that we can successfully verify an account number for on-boarding', () {
    final onBoardingService = MockOnBoardingService();
    final delegate = OnBoardingServiceDelegate(onBoardingService, MockAccountCreationService());
    final requestBody = AccountInfoRequestBody(accountNumber: "5000028934");

    final accountNumber = "5000028934";
    final accountName = "Tolu Gbadamosi";

    final mockedResponse = ServiceResult(
        true,
        TransferBeneficiary(
            accountNumber: '5000028934', accountName: 'Tolu Gbadamosi'),
        null, null);

    when(onBoardingService.getAccount(requestBody))
        .thenAnswer((realInvocation) => Future.value(mockedResponse));

    expect(
        delegate.getAccount(requestBody),
        emitsInOrder([
          isA<Loading>().having((e) => null, 'data', isNull),
          isA<Success<TransferBeneficiary>>()
              .having((Success<TransferBeneficiary> e) => e.data?.accountNumber, 'accountNumber', equals(accountNumber))
              .having((Success<TransferBeneficiary> e) => e.data?.accountName, 'accountName', equals(accountName)),
          emitsDone
        ]));
  });

  test('test that the proper error is received when an unknown error occurs',
      () {
    final onBoardingService = MockOnBoardingService();
    final delegate = OnBoardingServiceDelegate(onBoardingService, MockAccountCreationService());
    final requestBody = AccountInfoRequestBody(accountNumber: "5000028934");

    when(onBoardingService.getAccount(requestBody)).thenThrow(
        DioError(requestOptions: RequestOptions(data: {}, path: ''))
    );

    expect(
        delegate.getAccount(requestBody),
        emitsInOrder([
          isA<Loading>().having((e) => null, 'data', isNull),
          isA<Error>().having((e) => e.message, 'message', equals('An unknown error occurred')),
          emitsDone
        ]));
  });

  test('test Service Errors',
          () {
        final onBoardingService = MockOnBoardingService();
        final delegate = OnBoardingServiceDelegate(onBoardingService, MockAccountCreationService());
        final requestBody = AccountInfoRequestBody(accountNumber: "5000028934");

        when(onBoardingService.getAccount(requestBody)).thenThrow(
            DioError(requestOptions: RequestOptions(data: "", path: ''))
        );

        expect(
            delegate.getAccount(requestBody),
            emitsInOrder([
              isA<Loading>().having((e) => null, 'data', isNull),
              isA<Error>().having((e) => e.message, 'message', equals('An unknown error occurred')),
              emitsDone
            ]));
      });

  group('OnBoardingViewModelTest', () {
    //The rationale behind this is to avoid rebuilding the page
    // test('Test that security questions is cached on subsequent calls', () async {
    //   //Arrange
    //   final securityDelegate = MockSecurityQuestionDelegate();
    //   final delegate = OnBoardingServiceDelegate(MockOnBoardingService(), MockAccountCreationService());
    //   final viewModel = OnBoardingViewModel(delegate: delegate, questionDelegate: securityDelegate);
    //
    //   final mockResponse = Resource.success(<SecurityQuestion>[
    //     SecurityQuestion.fromJson({'id': 1, 'question': "Who is Paul Okeke"}),
    //   ]);
    //
    //   when(securityDelegate.getAllQuestions())
    //       .thenAnswer((_) => Stream.fromIterable([mockResponse]));
    //
    //   //Act
    //   var value = viewModel.getSecurityQuestions();
    //
    //   //Assert
    //   expect(value, emitsInOrder([
    //     isA<Success>(),
    //     emitsDone
    //   ]));
    //
    //   await Future.delayed(Duration(seconds: 1), () => viewModel.getSecurityQuestions());
    //
    //   verify(securityDelegate.getAllQuestions()).called(equals(1));
    // });
  });
}
