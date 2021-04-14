import 'package:dio/dio.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/transfer_beneficiary.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/account_info_request.dart';
import 'package:moniepoint_flutter/app/onboarding/model/onboarding_service.dart';
import 'package:moniepoint_flutter/app/onboarding/model/onboarding_service_delegate.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:test/test.dart';
import 'onboarding_service_test.mocks.dart';

@GenerateMocks([OnBoardingService])
void main() {
  test('test that we can successfully verify an account number for onboarding',
      () {
    final onBoardingService = MockOnBoardingService();
    final delegate = OnBoardingServiceDelegate(onBoardingService);
    final requestBody = AccountInfoRequestBody(accountNumber: "5000028934");

    final accountNumber = "5000028934";
    final accountName = "Tolu Gbadamosi";

    final mockedResponse = ServiceResult(
        true,
        TransferBeneficiary(
            accountNumber: '5000028934', accountName: 'Tolu Gbadamosi'),
        null);

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
    final delegate = OnBoardingServiceDelegate(onBoardingService);
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
}
