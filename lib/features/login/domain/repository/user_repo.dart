import 'package:fatora/core/api/core_models/empty_model.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/api/core_models/base_result_model.dart';
import '../../../../core/api/data_source/remote_data_source.dart';
import '../../../../core/api/http/api_urls.dart';
import '../../../../core/api/http/http_method.dart';
import '../../../../core/notification/notification.dart';
import '../../../../core/utils/di.dart';
import '../../../../core/utils/navigation.dart';
import '../../../../core/utils/shared_perefrences/shared_perefrences_helper.dart';
import '../../../payment/data/models/resend_otp_response_model.dart';
import '../../data/models/confirm_login_request_model.dart';
import '../../data/models/confirm_login_response_model.dart';
import '../../data/models/login_request_model.dart';
import '../../data/models/login_response_model.dart';
import '../../data/models/set_password_request_model.dart';
import '../../data/models/set_password_response_model.dart';
import '../../data/models/verify_username_response_model.dart';
import '../../presentation/pages/login_page.dart';

class UserRepository {
  static final AppPreferences _appPreferences = instance<AppPreferences>();

  /// Login using username
  static Future<BaseResultModel?> login(
      LoginRequestModel loginRequestModel) async {
    final res = await RemoteDataSource.request<LoginResponseModel>(
        converter: (json) => LoginResponseModel.fromJson(json),
        method: HttpMethod.post,
        data: loginRequestModel.toJson(),
        withAuthentication: false,
        passAuthentication: true,
        url: ApiURLs.login);
    //await afterLogin(res);

    return res;
  }

  /// Login using username
  static Future<BaseResultModel?> verifyUsername(String usernameOrEmail) async {
    final res = await RemoteDataSource.request<VerifyUsernameResponseModel>(
        converter: (json) => VerifyUsernameResponseModel.fromJson(json),
        method: HttpMethod.get,
        queryParameters: {
          "usernameOrEmail": usernameOrEmail
        },
        withAuthentication: false,
        url: ApiURLs.verifyUsername);
    return res;
  }

  /// Confirm Login Otp
  static Future<BaseResultModel?> confirmLoginOtp(ConfirmLoginRequestModel confirmLoginRequestModel) async {
    final res = await RemoteDataSource.request<ConfirmOtpResponseModel>(
        converter: (json) => ConfirmOtpResponseModel.fromJson(json),
        method: HttpMethod.post,
        queryParameters: confirmLoginRequestModel.toJson(),
        withAuthentication: false,
        url: ApiURLs.confirmLoginOtp);
    return res;
  }

  /// Confirm Login Otp
  static Future<BaseResultModel?> setPassword(SetPasswordRequestModel setPasswordRequestModel) async {
    final res = await RemoteDataSource.request<SetPasswordResponseModel>(
        converter: (json) => SetPasswordResponseModel.fromJson(json),
        method: HttpMethod.post,
        data: setPasswordRequestModel.toJson(),
        withAuthentication: false,
        url: ApiURLs.setPassword);
    return res;
  }

  /// Resend OTP when assigning a new password
  static Future<BaseResultModel?> resendOTP(String usernameOrEmail) async {
    final res = await RemoteDataSource.request<ResendOtpResponse>(
        converter: (json) => ResendOtpResponse.fromJson(json),
        method: HttpMethod.post,
        queryParameters: {
          "usernameOrEmail": usernameOrEmail
        },
        withAuthentication: false,
        url: ApiURLs.resendPasswordOtp);
    return res;
  }

  static Future<void> afterLogin(LoginResponseModel loginResponse) async {
    _appPreferences.setAccessToken(loginResponse.accessToken ?? '');
  }

  /// Remove FCM token
  static Future<void> removeFCMToken() async {
    if(Messaging.token != null) {
      Messaging.deleteToken();
      //await NotificationRepository.removeFCMToken(Messaging.token);
    }
  }

  /// Logout
  static Future<void> logout(BuildContext context) async {
    await removeFCMToken();
    _appPreferences.clearForLogOut();
    _appPreferences.setName('');
    _appPreferences.setUsername('');
    Future.delayed(const Duration(milliseconds: 0), () {
      Navigation.pushReplacement(context, const LoginPage());
    },);
  }
}
