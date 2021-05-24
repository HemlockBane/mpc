import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/accounts/model/account_service.dart';
import 'package:moniepoint_flutter/app/accounts/model/account_service_delegate.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/customer_service.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/customer_service_delegate.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/data/nationality_dao.dart';
import 'package:moniepoint_flutter/app/institutions/institution_dao.dart';
import 'package:moniepoint_flutter/app/institutions/institution_repository.dart';
import 'package:moniepoint_flutter/app/institutions/institution_service.dart';
import 'package:moniepoint_flutter/app/login/model/login_service.dart';
import 'package:moniepoint_flutter/app/login/model/login_service_delegate.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/data/transfer_beneficiary_dao.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/transfer_beneficiary_delegate.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/transfer_beneficiary_service.dart';
import 'package:moniepoint_flutter/app/onboarding/model/account_creation_service.dart';
import 'package:moniepoint_flutter/app/onboarding/model/onboarding_service.dart';
import 'package:moniepoint_flutter/app/onboarding/model/onboarding_service_delegate.dart';
import 'package:moniepoint_flutter/app/onboarding/model/services/liveliness_service.dart';
import 'package:moniepoint_flutter/app/onboarding/model/services/liveliness_service_delegate.dart';
import 'package:moniepoint_flutter/app/securityquestion/model/security_question_delegate.dart';
import 'package:moniepoint_flutter/app/securityquestion/model/security_question_service.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/fee_vat_config_dao.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/transfer_dao.dart';
import 'package:moniepoint_flutter/app/transfers/model/transfer_service.dart';
import 'package:moniepoint_flutter/app/transfers/model/transfer_service_delegate.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/usermanagement_service.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/usermanagement_service_delegate.dart';
import 'package:moniepoint_flutter/app/validation/model/validation_service.dart';
import 'package:moniepoint_flutter/app/validation/model/validation_service_delegate.dart';
import 'package:moniepoint_flutter/core/device_manager.dart';
import 'package:moniepoint_flutter/core/models/services/location_service.dart';
import 'package:moniepoint_flutter/core/models/services/location_service_delegate.dart';
import 'package:moniepoint_flutter/core/network/auth_interceptor.dart';
import 'package:moniepoint_flutter/core/network/http_logging_interceptor.dart';

class ServiceModule {

  static Dio getConfiguredApiClient() {
    final dio = Dio(BaseOptions(
      connectTimeout: 60000,
      receiveTimeout: 60000 * 2,
      sendTimeout: 60000
    ))
      ..interceptors.addAll([
        AuthInterceptor(),
        LoggingInterceptor()
      ]);
    return dio;
  }

  static void inject() {
    final dio = getConfiguredApiClient();

    //initialize all the service/delegate here

    /// Onboarding Service
    GetIt.I.registerLazySingleton<OnBoardingServiceDelegate>(() {
      return OnBoardingServiceDelegate(OnBoardingService(dio), AccountCreationService(dio));
    });

    /// UserManagement Delegate
    GetIt.I.registerLazySingleton<UserManagementServiceDelegate>(() {
      return UserManagementServiceDelegate(UserManagementService(dio));
    });

    /// Login Delegate
    GetIt.I.registerLazySingleton<LoginServiceDelegate>(() {
      return LoginServiceDelegate(LoginService(dio));
    });

    /// Security Question Delegate
    GetIt.I.registerLazySingleton<SecurityQuestionDelegate>(() {
      return SecurityQuestionDelegate(SecurityQuestionService(dio));
    });

    /// Validation Service Delegate
    GetIt.I.registerLazySingleton<ValidationServiceDelegate>(() {
      return ValidationServiceDelegate(ValidationService(dio));
    });

    /// Account Service
    GetIt.I.registerLazySingleton<AccountServiceDelegate>(() {
      return AccountServiceDelegate(AccountService(dio));
    });

    /// Location Service
    GetIt.I.registerLazySingleton<LocationServiceDelegate>(() {
      return LocationServiceDelegate(GetIt.I<NationalityDao>(), LocationService(dio));
    });

    /// Liveliness checks
    GetIt.I.registerLazySingleton<LivelinessServiceDelegate>(() {
      return LivelinessServiceDelegate(LivelinessService(dio));
    });

    /// Customer checks
    GetIt.I.registerLazySingleton<CustomerServiceDelegate>(() {
      return CustomerServiceDelegate(CustomerService(dio));
    });

    /// Transfer checks
    GetIt.I.registerLazySingleton<TransferServiceDelegate>(() {
      return TransferServiceDelegate(TransferService(dio), GetIt.I<TransferDao>(),  GetIt.I<FeeVatConfigDao>());
    });

    /// Transfer Beneficiary checks
    GetIt.I.registerLazySingleton<TransferBeneficiaryServiceDelegate>(() {
      return TransferBeneficiaryServiceDelegate(
          TransferBeneficiaryService(dio),
          GetIt.I<TransferBeneficiaryDao>(),
      );
    });

    /// Institution checks
    GetIt.I.registerLazySingleton<InstitutionRepository>(() {
      return InstitutionRepository(InstitutionService(dio), GetIt.I<InstitutionDao>());
    });

    GetIt.I.registerLazySingleton<DeviceInfoPlugin>(() {
      return DeviceInfoPlugin();
    });

    GetIt.I.registerLazySingleton<DeviceManager>(() {
      return DeviceManager();
    });

  }
}