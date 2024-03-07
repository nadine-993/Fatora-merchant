import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:fatora/core/api/errors/net_error.dart';
import 'package:fatora/core/utils/toast.dart';
import 'package:fatora/features/login/domain/repository/user_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../constants/app_keys.dart';
import '../../utils/di.dart';
import '../../utils/shared_perefrences/shared_perefrences_helper.dart';
import '../core_models/base_result_model.dart';
import '../errors/unauthorized_error.dart';
import '../http/api_provider.dart';

class RemoteDataSource {
  static final AppPreferences _appPreferences = instance<AppPreferences>();

  static Future request<Response extends BaseResultModel>({
    required Response Function(Map<String, dynamic> json) converter,
    required String method,
    required String url,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    Map<String, String>? files,
    bool withAuthentication = true,
    bool passAuthentication = false,
    CancelToken? cancelToken,
    bool isLongTime = false,
    int retries = 0,
  }) async {

    Map<String, String> headers = {
      HEADER_CONTENT_TYPE: "application/json",
      HEADER_ACCEPT: "application/json",
    };


    if (withAuthentication) {
      if (_appPreferences.hasAccessToken()) {
        headers.putIfAbsent(
            HEADER_AUTH, () => ('Bearer ${_appPreferences.getAccessToken()}'));
      } else {
        UserRepository.logout(AppKeys.navigatorKey.currentContext!);
        return UnauthorizedError();
      }
    }

    // Send the request.
    final response = await ApiProvider.sendObjectRequest<Response>(
        method: method,
        url: url,
        converter: converter,
        headers: headers,
        queryParameters: queryParameters ?? {},
        data: data ?? {},
        files: files,
        isLongTime: isLongTime,
        cancelToken: cancelToken,
        retries: retries);

    // if success, return result
    if (response.success!) {
      return response.result;
    }

 /*   if(!response.success!){
      Toasts.showToast(response.serverError?.message ?? '', ToastType.error);
    }*/

    // If user is unauthorized, logout and return error
    if(response.unAuthorizedRequest != null) {
      if (response.unAuthorizedRequest!) {
        if(passAuthentication) {
          if (response.serverError != null) {
            return response.serverError;
          }
        }
        else {
          UserRepository.logout(AppKeys.navigatorKey.currentContext!);
          return UnauthorizedError();
        }
      }
    }

    // if there is a server error check for it
    if (response.serverError != null) {

      // if network error
      if (response.error is NetError) {
        return NetError();
      }

    return response.serverError;
  }

    else {
    return response.error;
    }
  }


  static Future<Response?> requestString({
    required String method,
    required String url,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    bool withAuthentication = true,
  }) async {
    Dio dio = Dio();
    dio.interceptors.add(PrettyDioLogger(
        request: kDebugMode,
        requestHeader: kDebugMode,
        requestBody: kDebugMode,
        responseBody: kDebugMode,
        responseHeader: kDebugMode,
        error: kDebugMode,
        compact: kDebugMode,
        maxWidth: 90));
    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      logPrint: print, // specify log function
      retryDelays: const [
        Duration(seconds: 1), // wait 1 sec before first retry
        Duration(seconds: 2), // wait 2 sec before second retry
        Duration(seconds: 3), // wait 3 sec before third retry
      ],
    ));
    Options? headers;
    if (withAuthentication) {
      if (_appPreferences.hasAccessToken()) {
        headers =
        Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
              HttpHeaders.acceptHeader: "application/json",
              HttpHeaders.authorizationHeader: 'Bearer ${_appPreferences.getAccessToken()}'
            }
        );
      } else {
        UserRepository.logout(AppKeys.navigatorKey.currentContext!);
      }
    } else {
      headers =
          Options(
              headers: {
                HttpHeaders.contentTypeHeader: "application/json",
                HttpHeaders.acceptHeader: "application/json",
              }
          );
    }

    Response? res;

    try {
      res = await dio.post(
        url,
        options: headers,
        queryParameters: queryParameters,
        data: jsonEncode(data),
      );
      if(res.data['success'] == true) {
        return res;
      }
      else if(res.data['unAuthorizedRequest'] == true) {
        UserRepository.logout(AppKeys.navigatorKey.currentContext!);
      }
      else {
        return null;
      }
    } catch(e) {
      return null;
    }



  }

}
