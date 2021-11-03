import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:moniepoint_flutter/app/savings/model/data/savings_product.dart';
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:retrofit/retrofit.dart';
import 'package:retrofit/http.dart';

part 'savings_product_service.g.dart';


@RestApi(baseUrl: "${ServiceConfig.SAVINGS_SERVICE}api/v1/")
abstract class SavingsProductService {

  factory SavingsProductService(Dio dio) = _SavingsProductService;

  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  @GET("flex/saving/get-product")
  Future<ServiceResult<SavingsProduct>> getFlexProduct();

}
