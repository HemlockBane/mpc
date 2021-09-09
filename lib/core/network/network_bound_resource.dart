
import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/network/service_error.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';

import '../timeout_reason.dart';
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
    required Stream<K?> Function() fetchFromLocal,
    bool Function(K?)? shouldFetchFromRemote,
    bool shouldFetchLocal = false,
    required Future<ServiceResult<K>?> Function() fetchFromRemote,
    K? Function(Success<ServiceResult<K>> response)? processRemoteResponse,
    Future Function(K)? saveRemoteData,
    void Function({ServiceResult<K?>? result, int? statusCode})? onError
  }) async* {
    shouldFetchFromRemote ??= (T) => true;
    processRemoteResponse ??= (T) => null;

    //We first declare that we are loading the state
    if(shouldFetchLocal) yield Resource.loading(null);

    //let's fetch from local storage
    K? localData; //= //(shouldFetchLocal) ? await fetchFromLocal() : null;
    if(shouldFetchLocal) {
      await for (var value in fetchFromLocal()) {
        localData = value;
        yield Resource.loading(localData);
        break;
      }
    }

    if(shouldFetchFromRemote(localData)) {
      //if we are fetching from remote let's emit
      yield Resource.loading(localData);

      try {
        final response = await fetchFromRemote();

        //guide yourself from null
        if(response == null) return;

        if(response.errors == null || response.errors?.isEmpty == true) {
          response.success = true;
          K? result = processRemoteResponse(Resource.success(response) as Success<ServiceResult<K>>);
          if((result != null || response.result != null) && saveRemoteData != null) {
            await saveRemoteData(result ?? response.result!);
          }
          if(shouldFetchLocal) {
            await for (final value in fetchFromLocal()) yield Resource.success(value);
          }
          else yield Resource.success(result ?? response.result);
        } else {
          onError?.call(result: response, statusCode: 200);
          yield Resource.error(err: ServiceError(message: response.errors?.first.message ?? ""));
        }
      } catch(e) {
        print(e);
        ServiceResult<K?>? result;
        Response? response;
        if (e is DioError) {

          if(e.response?.statusCode == 401) {
            //TODO check if the user is in session first
            UserInstance().forceLogout(null, SessionTimeoutReason.SESSION_TIMEOUT);
            return;
          }
          else if(e.response?.statusCode == 404) {
            _errorString = "404";
            _onFailed<K>(response, result);
            yield Resource.error(err: this._serviceError);
            return;
          }

          response = e.response;
          final errorBody = e.response?.data;
          final errorString = e.response?.data.toString();

          if (errorBody != null) {
            try {
              result = ServiceResult.fromJson(jsonDecode(jsonEncode(errorBody)), (a) => null);
              //Dispatch the error to anyone that cares
              onError?.call(result: result, statusCode: e.response?.statusCode);
            } catch (e) {
              if (e is FormatException) _errorString = errorString;
              print(e);
            }
          } else {
            var error = e.error;
            if(error is TypeError/**/) {
              _errorString = "We encountered an error fulfilling your request. Please try again later.";//TypeError occurred here
            } else {
              _errorString = error.toString();
              print('In the else branch of error type: ${error.runtimeType}');
              print('In the else branch of error: $error');
              print('In the else branch of error: ${e.response?.statusCode}');
            }
          }
        }
        else if (e is Exception) {
          _exception = e;
        }
        _onFailed<K>(response, result);
        print('Error ${this._serviceError?.message}');
        yield Resource.error(err: this._serviceError);
      }
    }
  }

  void _onFailed<K>(Response? response, ServiceResult<K?>? result) {
    //constructErrorMessage
    //we need to be able to use a single form
    final httpStatusCode = response?.statusCode;
    if(httpStatusCode != null && httpStatusCode >= 502 && httpStatusCode <= 504) {
      _errorString = "$httpStatusCode";
    }
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
      print(e.message);
      _errorString = e.message.replaceAll('Exception', '');
    } else if(_exception != null) {
      print(_exception.runtimeType);
      _errorString = _exception?.toString();
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
          || _errorString!.toLowerCase().contains("host lookup")
          || _errorString!.toLowerCase().contains("network is unreachable")
          || _errorString!.toLowerCase().contains("connecttimeout")) {
        _errorString =
        "We are unable to reach the server at this time. Please confirm your internet connection and try again later.";
      }
      else if (_errorString != null &&
          (_errorString!.toLowerCase().contains("502") ||
              _errorString!.toLowerCase().contains("503") ||
              _errorString!.toLowerCase().contains("504"))) {
        _errorString = "We are unable to reach the service at this time. Please, Try again";
      }
      else if (_errorString!.toLowerCase().contains("exception")) {
        FirebaseCrashlytics.instance.recordError(Exception(_errorString), null);
        _errorString = "System Error";
      }
      if (_errorString!.toLowerCase().contains("database error")) {
        _errorString = "Operation was Unsuccessful";
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


  void _makeServiceError() {
    _serviceError = ServiceError(message: this._errorString??"", code: _errorCode);
  }

}

Tuple<String, String> formatError(String? errorMessage, String moduleName) {
  String? errorTitle = "";
  String? errorDescription = "";
  print("The error message is $errorMessage");
  if (errorMessage != null &&
      (errorMessage.contains("resolve host") ||
          errorMessage.toLowerCase().contains("failed to connect") ||
          errorMessage.toLowerCase().contains("failed host lookup") ||
          errorMessage.toLowerCase().contains("network is unreachable") ||
          errorMessage.toLowerCase().contains("internet connection") ||
          errorMessage.toLowerCase().contains("an unknown error occurred"))) {
    errorTitle = "No Network Connection";
    errorDescription =
        "We are unable to reach the server at this time. Please confirm your internet connection and try again.";
  } else if (errorMessage != null &&
      (errorMessage.toLowerCase().contains("exception") ||
          errorMessage.toLowerCase().contains("database error") ||
          errorMessage.toLowerCase().contains("org.springframework"))) {
    errorTitle = "Oops, Something is broken!";
    errorDescription =
        "We encountered an error loading your $moduleName. Please try again later.";
  } else if (errorMessage != null &&
      (errorMessage.toLowerCase().contains("ssl") ||
          errorMessage.toLowerCase().contains("redis") ||
          errorMessage.toLowerCase().contains("502") ||
          errorMessage.toLowerCase().contains("503") ||
          errorMessage.toLowerCase().contains("504"))) {
    errorTitle = "Oops, Something went wrong!";
    errorDescription =
        "We are unable to reach the service at this time. Please, Try again";
  } else if (errorMessage == null || errorMessage.isEmpty) {
    errorTitle = "Oops, Something is broken!";
    errorDescription =
        "We encountered an error loading your $moduleName. Please try again later.";
  } else if(errorMessage.contains("401")){
    errorTitle = "Oops, Something is broken!";
    errorDescription = "We encountered an error loading your $moduleName. Please try again later.";
  }
  else if(errorMessage.contains("404")){
    errorTitle = "Oops, Something is not right";
    errorDescription = "The requested resource was not found. We are currently investigating what might be the problem.\nPlease try again later.";
  }
  else {
    errorTitle = "Oops";
    errorDescription = "An unknown error occurred. Please try again later.";
    FirebaseCrashlytics.instance.recordError(errorMessage, null);
  }
  return Tuple(errorTitle, errorDescription);
}


/// @author Paul Okeke
///
/// Applies a re-try mechanism and delay for loading
/// resources (network bound resource) within the application
///
///
///
///
Stream<Resource<T>> streamWithExponentialBackoff<T>({
  int retries = 3,
  Duration delay = const Duration(seconds: 3),
  required Stream<Resource<T>> stream,
}) async* {
  await for (var response in stream) {
    if(response is Loading || response is Success) yield response;
    
    if(response is Error<T>) {
      if(retries > 1) {
        print("Awaiting Exponential Delay....");
        await Future.delayed(delay, () => true);
        print("Retrying Exponential Backoff....");
        yield* streamWithExponentialBackoff(
            stream: stream,
            retries: retries - 1
        );
      } else {
        yield response;
      }
    }
  }
}