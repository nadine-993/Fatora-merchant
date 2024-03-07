import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_http_cache_lts/dio_http_cache_lts.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../.,/../../core/api/errors/custom_error.dart';
import '../core_models/base_response_model.dart';
import '../core_models/base_result_model.dart';
import '../errors/bad_request_error.dart';
import '../errors/base_error.dart';
import '../errors/cancel_error.dart';
import '../errors/conflict_error.dart';
import '../errors/forbidden_error.dart';
import '../errors/http_error.dart';
import '../errors/internal_server_error.dart';
import '../errors/net_error.dart';
import '../errors/not_found_error.dart';
import '../errors/socket_error.dart';
import '../errors/timeout_error.dart';
import '../errors/unauthorized_error.dart';
import '../errors/unknown_error.dart';

// Headers
const HEADER_LANGUAGE = 'Accept-Language';
const String HEADER_AUTH = 'authorization';
const String HEADER_CONTENT_TYPE = 'Content-Type';
const String HEADER_ACCEPT = 'accept';
class ApiProvider {
  static Future<BaseResponseModel>
      sendObjectRequest<T extends BaseResultModel>({
    required T Function(Map<String, dynamic>) converter,
    required String method,
    required String url,
    Map<String, dynamic>? data,
    required Map<String, String> headers,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? files,
    CancelToken? cancelToken,
    bool isLongTime = false,
    int retries = 0,
  }) async {
    var baseOptions = BaseOptions(
      connectTimeout: isLongTime ?  60 * 1000 :  15 * 1000,
        validateStatus: (statusCode) {
          print("STATUS CODE: $statusCode");
          return true;
        }
    );
    var dio = Dio();

    dio.options = baseOptions;
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
      retries: retries, // retry count
      retryDelays: const [
        Duration(seconds: 1), // wait 1 sec before first retry
        Duration(seconds: 2), // wait 2 sec before second retry
        Duration(seconds: 3), // wait 3 sec before third retry
      ],
    ));

    Options options = Options(
      headers: headers,
      method: method,
      contentType: Headers.jsonContentType,
      sendTimeout: files == null ?  4000 : null,
    );

    if (files != null) {
      headers.remove(HEADER_CONTENT_TYPE);
      data ??= {};

      await Future.forEach(files.entries, (MapEntry entry) async {
        if (entry.value != null) {
          data!.addAll({
            entry.key: await MultipartFile.fromFile(entry.value,
                filename: entry.value, contentType: MediaType("image", "jpeg"))
          });
        }
      });
    }
    try {
      Response response;
      response = await dio.request(url,
          queryParameters: queryParameters,
          options: options, onSendProgress: (sent, total) {
      },

          //   options: buildCacheOptions(Duration(days: 7),maxStale: Duration(days: 14),options: options,forceRefresh: true),
          //   cancelToken: cancelToken,
          data: files != null ? FormData.fromMap(data!) : data);
      if (null != response.headers.value(DIO_CACHE_HEADER_KEY_DATA_SOURCE)) {
        // data come from cache
      } else {
        // data come from net
      }
      // Get the decoded json
      dynamic decodedJson;

      if (response.data is String) {
        if (response.data.length == 0) {
          decodedJson = {"": ""};
        } else {
          decodedJson = json.decode(response.data);
        }
      } else {
        decodedJson = response.data;
      }

      return BaseResponseModel.fromJson(
          json: decodedJson, fromJson: converter,);
    }

    // Handling errors
    on DioError catch (e) {
      var error = _handleDioError(e);
      dynamic json;
      if (e.response != null) {
        if (e.response!.data != null) {
          if (e.response!.data is! String) {
            json = e.response!.data;
          }
        }
      }

      return BaseResponseModel.fromJson(
          json: json, error: error);
    }

    // Couldn't reach out the server
    on SocketException catch (e) {
      return BaseResponseModel.fromJson(
          error: SocketError());
    } catch (e, s) {
      if (kDebugMode) {
        print(e);
        print(s);
      }
      return BaseResponseModel.fromJson(
          error: HttpError(),
          );
    }
  }

  static BaseError _handleDioError(DioError error) {
    if (error.type == DioErrorType.other ||
        error.type == DioErrorType.response) {
      if (error is SocketException) return SocketError();
      if (error.type == DioErrorType.response) {
        switch (error.response?.statusCode ?? 400) {
          case 400:
            return BadRequestError();
          case 401:
            return UnauthorizedError();
          case 403:
            return ForbiddenError();
          case 404:
            return NotFoundError();
          case 409:
            return ConflictError();
          case 500:
            return InternalServerError();

          default:
            return HttpError();
        }
      }
      return NetError();
    } else if (error.type == DioErrorType.connectTimeout ||
        error.type == DioErrorType.sendTimeout ||
        error.type == DioErrorType.receiveTimeout) {
      return TimeoutError();
    } else if (error.type == DioErrorType.cancel) {
      return CancelError();
    } else {
      return UnknownError();
    }
  }
}
