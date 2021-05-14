
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/network/service_error.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:retrofit/dio.dart';

import '../tuple.dart';

// -------------------------------------------------------------------
// A mixin that serves as a bridge for handling all api calls
// -------------------------------------------------------------------

/// @author Paul Okeke
///
mixin NetworkResource {

  ServiceError? _serviceError;
  String? _errorString;
  int? _errorCode;
  Exception? _exception;

  Stream<Resource<K>> networkBoundResource<K>({
    required Future<K?> Function() fetchFromLocal,
    bool Function(K?)? shouldFetchFromRemote,
    bool shouldFetchLocal = false,
    required Future<ServiceResult<K>?> Function() fetchFromRemote,
    Function(Success<ServiceResult<K>> response)? processRemoteResponse,
    Future Function(K)? saveRemoteData,
  }) async* {
    shouldFetchFromRemote ??= (T) => true;
    processRemoteResponse ??= (T) => {};

    //We first declare that we are loading the state
    if(shouldFetchLocal) yield Resource.loading(null);

    //let's fetch from local storage
    final localData = (shouldFetchLocal) ? await fetchFromLocal() : null;

    if(shouldFetchFromRemote(localData)) {
      //if we are fetching from remote let's emit
      yield Resource.loading(localData);

      try {
        final response = await fetchFromRemote();

        //guide yourself from null
        if(response == null) return;

        if(response.errors == null || response.errors?.isEmpty == true) {
          response.success = true;
          processRemoteResponse(Resource.success(response) as Success<ServiceResult<K>>);
          yield Resource.success(shouldFetchLocal ? await fetchFromLocal() : response.result);
        } else {

        }
      } catch(e) {
        print(e);
        _exception = e as Exception;

        ServiceResult<K?>? result;
        Response? response;
        //
        if (e is DioError) {
          response = e.response;
          final errorBody = e.response?.data;
          final errorString = e.response?.data.toString();

          if (errorBody != null) {
            try {
              result = ServiceResult.fromJson(jsonDecode(jsonEncode(errorBody)), (a) => null);
            } catch (e) {
              if (e is FormatException) _errorString = errorString;
              print(e);
            }
          } else {
            var error = e.error;
            print('In the else branch of error: $error');
            print('In the else branch of error: ${e.response?.statusMessage}');
          }
        }
        // }

        _onFailed<K>(response, result);
        print('Error ${this._serviceError?.message}');
        yield Resource.error(err: this._serviceError);
      }
    }
  }

  void _onFailed<K>(Response? response, ServiceResult<K?>? result) {
    //constructErrorMessage
    //we need to be able to use a single form
    if(result?.errors != null && result!.errors!.length > 0) {
        _errorString = result.errors!.first.message;
        _errorCode = result.errors!.first.code;
    }
    else if(response != null) {
      final errorBodyString = response.data.toString();
      _errorString = (errorBodyString.isNotEmpty) ? errorBodyString : response.statusCode.toString();
      print('This is where we got it $_errorString');
    } else if (_exception != null && !_exception.toString().contains('DioErrorType.other')) {
      _errorString = _exception.toString().replaceAll('Exception', '');
    } else if(_exception is DioError) {
      var e = _exception as DioError;
      _errorString = "${e.response?.statusCode.toString()}  ${e.response?.statusMessage}";
    }

    _formatErrorMessage();
    _makeServiceError();
  }

  void _formatErrorMessage() {
    if (_errorString == null) {
      _errorString = "An unknown error occurred";
    } else {
      if (_errorString!.contains("resolve host")
          || _errorString!.toLowerCase().contains("failed to connect")
          || _errorString!.toLowerCase().contains("connecttimeout")) {
        _errorString =
        "We are unable to reach the server at this time. Please confirm your internet connection and try again later.";
      }
      if (_errorString!.toLowerCase().contains("exception")) {
        _errorString = "System Error";
      }
      if (_errorString!.toLowerCase().contains("database error")) {
        _errorString = "Operation Was Unsuccessful";
      }
      if (_errorString!.toLowerCase().contains("ssl") || _errorString!.toLowerCase().contains("redis")) {
        _errorString = "We are unable to reach the service at this time. Try again";
      }
      if (_errorString!.toLowerCase().contains("org.springframework")) {
        _errorString = "An unknown error occurred";
      }
    }
    print('Error String : $_errorString');
  }

  static Tuple<String, String> formatError(String? errorMessage, String moduleName) {
    String? errorTitle = "";
    String? errorDescription = "";

    if (errorMessage != null && (errorMessage.contains("resolve host")
        || errorMessage.toLowerCase().contains("failed to connect")
        || errorMessage.toLowerCase().contains("an unknown error occurred")
    )) {
      errorTitle = "No Network Connection";
      errorDescription =
      "We are unable to reach the server at this time. Please confirm your internet connection and try again.";
    }
    else if (errorMessage != null && (errorMessage.toLowerCase().contains("exception")
        || errorMessage.toLowerCase().contains("database error")
        || errorMessage.toLowerCase().contains("org.springframework"))) {
      errorTitle = "Oops, Something is broken!";
      errorDescription =
      "We encountered an error loading your $moduleName. Please try again later.";
    }
    else if (errorMessage != null && (errorMessage.toLowerCase().contains("ssl")
        || errorMessage.toLowerCase().contains("redis")
        || errorMessage.toLowerCase().contains("502")
        || errorMessage.toLowerCase().contains("503")
        || errorMessage.toLowerCase().contains("504"))) {
      errorTitle = "Oops, Something went wrong!";
      errorDescription =
      "We are unable to reach the service at this time. Please, Try again";
    }
    else if (errorMessage == null || errorMessage.isEmpty) {
      errorTitle = "Oops, Something is broken!";
      errorDescription =
      "We encountered an error loading your $moduleName. Please try again later.";
    } else {
      errorTitle = "Oops";
      errorDescription = errorMessage;
    }
    return Tuple(errorTitle, errorDescription);
  }

  void _makeServiceError() {
    _serviceError = ServiceError(message: this._errorString??"", code: _errorCode);
  }

}
