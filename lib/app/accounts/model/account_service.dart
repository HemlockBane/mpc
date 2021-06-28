import 'package:dio/dio.dart' hide Headers;
import 'package:moniepoint_flutter/app/accounts/model/data/account_balance.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_status.dart';
import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/data/transfer_beneficiary.dart';
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:retrofit/http.dart';

part 'account_service.g.dart';

@RestApi(baseUrl: "${ServiceConfig.ROOT_SERVICE}api/v1/account/")
abstract class AccountService {

  factory AccountService(Dio dio) = _AccountService;

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @GET("account-balance")
  Future<ServiceResult<AccountBalance>> getCustomerAccountBalance(
      @Query("customerAccountId") int customerAccountId);


  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @GET("account_with_balance")
  Future<ServiceResult<List<UserAccount>>> getUserAccountsWithBalance();

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @GET("status")
  Future<ServiceResult<AccountStatus>> getAccountStatus(
      @Query("customerAccountId") int customerAccountId);

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @GET("account-name")
  Future<ServiceResult<TransferBeneficiary>> getBeneficiaryDetails(
    @Query("accountProviderCode") String accountProviderCode,
    @Query("accountNumber") String accountNumber,
  );
}
