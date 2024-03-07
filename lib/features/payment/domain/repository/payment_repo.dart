import 'dart:convert';

import 'package:fatora/core/api/core_models/base_result_model.dart';
import 'package:fatora/core/api/core_models/empty_model.dart';
import 'package:fatora/features/payment/data/models/create_full_payment_request_model.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/api/data_source/remote_data_source.dart';
import '../../../../core/api/http/api_urls.dart';
import '../../../../core/api/http/http_method.dart';
import '../../data/models/confirm_reverse_request_model.dart';
import '../../data/models/create_full_payment_response_model.dart';
import '../../data/models/decrypt_qr_response.dart';
import '../../data/models/pay_with_otp_request_model.dart';
import '../../data/models/pay_with_otp_response_model.dart';
import '../../data/models/payment_creation_response.dart';
import '../../data/models/payment_list_response.dart';
import '../../data/models/payment_model.dart';
import '../../data/models/resend_otp_response_model.dart';
import '../../data/models/reverse_payment_response_model.dart';

class PaymentRepository {

  /// Gets the list of payments based on a filter
  static Future<BaseResultModel> getPayments(
    dynamic requestData,
    dynamic paymentsRequestModel,
  ) async {
    var res;
    Map<String, dynamic> map1 = requestData.toJson();
    Map<String, dynamic> map2 = paymentsRequestModel.toJson();
    Map<String, dynamic> combinedMap = {...map1, ...map2};
    try {
      res = await RemoteDataSource.request<PaymentListResponse>(
          converter: (json) => PaymentListResponse.fromJson(json),
          method: HttpMethod.post,
          data: combinedMap,
          withAuthentication: true,
          url: ApiURLs.getTransactions);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return res;
  }

  /// Gets payment by ID
  static Future<BaseResultModel?> getPaymentById(
    dynamic requestData,
  ) async {
    var res;
    try {
      res = await RemoteDataSource.request<Payment>(
          converter: (json) => Payment.fromJson(json),
          method: HttpMethod.post,
          queryParameters: requestData.toJson(),
          withAuthentication: true,
          url: ApiURLs.getPaymentById
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return res;
  }

  /// Creates a new payment
  static Future<BaseResultModel?> createPayment(
    dynamic createPaymentModel,
  ) async {
    var res;
    try {
      res = await RemoteDataSource.request(
          converter: (json) => PaymentCreationResponse.fromJson(json),
          method: HttpMethod.post,
          data: createPaymentModel.toJson(),
          withAuthentication: true,
          url: ApiURLs.createPayment,
          passAuthentication: true
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return res;
  }

  /// Creates a full payment
  static Future<BaseResultModel?> createFullPayment(CreateFullPaymentRequestModel createFullPaymentRequestModel,) async {
    var res;
    res = await RemoteDataSource.request(
        converter: (json) => CreateFullPaymentResponse.fromJson(json),
        data: createFullPaymentRequestModel.toJson(),
        method: HttpMethod.post,
        withAuthentication: true,
        url: ApiURLs.createFullPayment,
        passAuthentication: true
    );
    return res;
  }

  /// Pays With Otp
  static Future<BaseResultModel?> payWithOtp(PayWithOtpRequestModel payWithOtpRequestModel,) async {
    final res = await RemoteDataSource.request(
        converter: (json) => PayWithOtpResponse.fromJson(json),
        data: payWithOtpRequestModel.toJson(),
        method: HttpMethod.post,
        withAuthentication: true,
        url: ApiURLs.payWithOtp,
        passAuthentication: true
    );

    return res;
  }

  /// Resend OTP when creating a new payment
  static Future<BaseResultModel?> resendOTP(String paymentId) async {
    final res = await RemoteDataSource.request<ResendOtpResponse>(
        converter: (json) => ResendOtpResponse.fromJson(json),
        method: HttpMethod.get,
        queryParameters: {
          "paymentId": paymentId
        },
        withAuthentication: true,
        url: ApiURLs.resendPaymentOtp,
        passAuthentication: true
    );
    return res;
  }


  /// Decrypts a given qr code
  static Future<BaseResultModel?> decryptQR(String qr,) async {
    print("jony qr");
    print(qr);
    final res = await RemoteDataSource.request<DecryptQrResponse>(
        converter: (json) => DecryptQrResponse.fromJson(json),
        data: Map.from(jsonDecode(qr)),
        method: HttpMethod.post,
        withAuthentication: true,
        url: ApiURLs.decryptQR,
        passAuthentication: true
    );

    return res;
  }

  /// Reverses a payment
  static Future<BaseResultModel?> reversePayment(dynamic paymentId) async {
    var res;
    try {
     res = await RemoteDataSource.request(
          converter: (json) => ReversePaymentResponse.fromJson(json),
          method: HttpMethod.post,
          url: ApiURLs.reversePayment,
          data: {
            "transaction": {
              "id": paymentId,
            }
          }
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return res;
  }

  /// Cancels a payment
  static Future<BaseResultModel?> cancelPayment(dynamic paymentId) async {
    BaseResultModel? res;
    try {
      res = await RemoteDataSource.request(
         converter: (json) => EmptyModel.fromJson(json),
          method: HttpMethod.post,
          url: ApiURLs.cancelPayment,
          queryParameters: {
            "paymentId": paymentId
          },
          passAuthentication: true
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return res;
  }

  /// Confirm reverse payment
  static Future<BaseResultModel?> confirmReversePayment(ConfirmReverseRequestModel confirmReverseRequestModel) async {
    var res;
    try {
      Map<String, dynamic>? queryParams = {
        "paymentId": confirmReverseRequestModel.paymentId,
        "otp": confirmReverseRequestModel.otp,
      };
      res = await RemoteDataSource.request(
          converter: (json) => ReversePaymentResponse.fromJson(json),
          method: HttpMethod.post,
          url: ApiURLs.confirmReversePayment,
          queryParameters: queryParams,
          passAuthentication: true
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return res;
  }
}
