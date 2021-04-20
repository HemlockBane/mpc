import 'package:dio/dio.dart' hide Headers;
import 'package:moniepoint_flutter/app/securityquestion/model/data/security_question.dart';
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:retrofit/retrofit.dart';

part 'security_question_service.g.dart';

@RestApi(baseUrl: "${ServiceConfig.OPERATION_SERVICE}api/v1/security_question")
abstract class SecurityQuestionService  {

  factory SecurityQuestionService (Dio dio) = _SecurityQuestionService;

  @GET("/questions")
  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
    "client-id": BuildConfig.CLIENT_ID,
    "appVersion": BuildConfig.APP_VERSION
  })
  Future<ServiceResult<List<SecurityQuestion>>> getAllQuestions();

}