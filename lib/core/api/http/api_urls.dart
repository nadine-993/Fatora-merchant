import '../../app_settings.dart';

class ApiURLs {
  ///baseUrl
  static const String baseUrl = AppSettings.baseUrl;

  // User
  static const String login = '$baseUrl/api/TokenAuth/Authenticate';
  static const String verifyUsername = '$baseUrl/api/TokenAuth/VerifyUsername';
  static const String confirmLoginOtp = '$baseUrl/api/TokenAuth/ConfirmOTP';
  static const String setPassword = '$baseUrl/api/services/app/Account/ResetPassword';
  static const String resendPasswordOtp = '$baseUrl/api/TokenAuth/ResendOTP';
  static const String getAllUserClients = '$baseUrl/api/services/app/Transaction/GetAllUserClients';
  static const String getAllClientTerminals = '$baseUrl/api/services/app/Transaction/GetAllClientTerminals';
  static const String getMyPermissions = '$baseUrl/api/services/app/Profile/GetMyPermissions';
  static const String getUserInformation = '$baseUrl/api/services/app/Session/GetCurrentLoginInformations';
  static const String getClientLogo = '$baseUrl/api/services/app/Client/GetClientLogo?image=';

  // Payment
  static const String getTransactions = '$baseUrl/api/services/app/Transaction/GetTransactions';
  static const String getPaymentById = '$baseUrl/api/services/app/Transaction/GetPaymentById';
  static const String createPayment = '$baseUrl/api/services/app/Transaction/CreateOrUpdateTransaction';
  static const String reversePayment = '$baseUrl/api/services/app/Transaction/CreateOrUpdateTransaction';
  static const String cancelPayment = '$baseUrl/api/services/app/Transaction/CancelPayment';
  static const String confirmReversePayment = '$baseUrl/api/services/app/Transaction/ConfirmReverse';
  static const String decryptQR = '$baseUrl/api/services/app/Transaction/DecryptQR';
  static const String createFullPayment = '$baseUrl/api/services/app/Transaction/CreateFullPayment';
  static const String payWithOtp = '$baseUrl/api/services/app/Transaction/PayWithOTP';
  static const String resendPaymentOtp = '$baseUrl/api/services/app/Transaction/ResendOTP';


  // Notifications
  static const String getNotifications = '$baseUrl/api/services/app/Notify/GetNotifications';
  static const String setFCMToken = '$baseUrl/api/services/app/Profile/setFCMToken';
  static const String removeFCMToken = '$baseUrl/api/services/app/Profile/removeFCMToken';
  static const String readNotification = '$baseUrl/api/services/app/Notify/ReadNotification';
  static const String getUnreadNotifications = '$baseUrl/api/services/app/Notify/GetUnreadNotificationsCount';

  // Advertisement
  static const String getAdvertisement = '$baseUrl/api/services/app/Slider/GetAds';
  static const String getAdImage = '$baseUrl/api/services/app/Slider/GetImage?image=';

  // Settings
  static const String getDefaultParams = '$baseUrl/api/services/app/Profile/GetProfile';
  static const String setDefaultParams = '$baseUrl/api/services/app/Profile/ChangeProfile';
  static const String getPrivacyPolicy = '$baseUrl/api/services/app/PrivacyPolicy/GetPrivacyPolicy';
  static const String changePassword = '$baseUrl/api/services/app/Profile/ChangePassword';
  static const String checkUpdate = '$baseUrl/api/services/app/AppVersion/CheckVersion';


}
