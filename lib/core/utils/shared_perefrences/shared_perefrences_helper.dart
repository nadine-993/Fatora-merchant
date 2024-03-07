import 'package:fatora/features/payment/data/models/filter_params.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/settings/data/models/get_default_params_response.dart';
import '../../../features/settings/domain/repository/settings_repo.dart';
import '../../api/core_models/base_result_model.dart';
import '../../constants/constants.dart';


const KEY_ACCESS_TOKEN = "PREF_KEY_ACCESS_TOKEN";
const String PREFS_KEY_LANG = 'PREFS_KEY_LANG';
const String PREFS_KEY_ONBOARDING_SCREEN_VIEWED = 'PREFS_KEY_ONBOARDING_SCREEN_VIEWED';
const String PREFS_KEY_IS_USER_LOGGED_IN = 'PREFS_KEY_IS_USER_LOGGED_IN';

// Filtering
const String PREFS_KEY_FILTER_AMOUNT = 'PREFS_KEY_FILTER_AMOUNT';
const String PREFS_KEY_FILTER_STATUSES = 'PREFS_KEY_FILTER_STATUSES';
const String PREFS_KEY_FILTER_STARTDATE = 'PREFS_KEY_FILTER_STARTDATE';
const String PREFS_KEY_FILTER_ENDDATE = 'PREFS_KEY_FILTER_ENDDATE';
const String PREFS_KEY_FIRST_FILTER = 'PREFS_KEY_FIRST_FILTER';

// Default Params
const String PREFS_KEY_TRIGGER_URL = 'PREFS_KEY_TRIGGER_URL';
const String PREFS_KEY_CALLBACK_URL = 'PREFS_KEY_CALLBACK_URL';

// Local Auth
const String PREFS_KEY_FINGERPRINT = 'PREFS_KEY_FINGERPRINT';
const String PREFS_KEY_SAVE_PASSWORD = 'PREFS_KEY_SAVE_PASSWORD';

// User info
const String PREFS_KEY_NAME = 'PREFS_KEY_NAME';
const String PREFS_KEY_USERNAME = 'PREFS_KEY_USERNAME';



class AppPreferences{
  final SharedPreferences _sharedPreferences;
  AppPreferences(this._sharedPreferences);

  // NAME
  Future<void> setName(String? name) async{
    _sharedPreferences.setString(PREFS_KEY_NAME, name ?? '');
  }

  String getName() {
    return _sharedPreferences.getString(PREFS_KEY_NAME) ?? '';
  }

  // USERNAME
  Future<void> setUsername(String? username) async{
    _sharedPreferences.setString(PREFS_KEY_USERNAME, username ?? '');
  }

  String getUsername() {
    return _sharedPreferences.getString(PREFS_KEY_USERNAME) ?? '';
  }

  // Fingerprint
  Future<void> setFingerprint(bool? fingerprint) async{
    _sharedPreferences.setBool(PREFS_KEY_FINGERPRINT, fingerprint ?? false);
  }

  bool getFingerprint() {
    return _sharedPreferences.getBool(PREFS_KEY_FINGERPRINT) ?? false;
  }

  // SavePassword
  Future<void> setSavePassword(bool? savePassword) async{
    _sharedPreferences.setBool(PREFS_KEY_SAVE_PASSWORD, savePassword ?? true);
  }

  bool getSavePassword() {
    return _sharedPreferences.getBool(PREFS_KEY_SAVE_PASSWORD) ?? true;
  }


  // Lang
  Future<void> setLanguage(String? language) async{
    _sharedPreferences.setString(PREFS_KEY_LANG, language ?? 'en');
  }

  String getLanguage() {
    return _sharedPreferences.getString(PREFS_KEY_LANG) ?? 'en';
  }

  // First Filter
  Future<void> setFirstFilter() async{
    _sharedPreferences.setBool(PREFS_KEY_FIRST_FILTER, false);
  }

  // Clear First Filter
  Future<void> clearFirstFilter() async{
    _sharedPreferences.setBool(PREFS_KEY_FIRST_FILTER, true);
  }

  bool getFirstFilter() {
    return _sharedPreferences.getBool(PREFS_KEY_FIRST_FILTER) ?? true;
  }

  // Set Filters
  Future<void> setFilters(String? amount, List<String>? statuses, String? startDate, String? endDate) async{
    _sharedPreferences.setString(PREFS_KEY_FILTER_AMOUNT, amount ?? '');
    _sharedPreferences.setString(PREFS_KEY_FILTER_STARTDATE, startDate ?? Constants.defaultStartDate.toString());
    _sharedPreferences.setString(PREFS_KEY_FILTER_ENDDATE, endDate ?? Constants.defaultEndDate.toString());
    _sharedPreferences.setStringList(PREFS_KEY_FILTER_STATUSES, statuses ?? ['Approved', 'Reversed']);
  }

  List<String> selectedStatus = [];
  void _getDefaultList() async {
      BaseResultModel? res = await SettingsRepository.getDefaultParams();
      if(res is GetDefaultParamsResponse?) {
        selectedStatus = res!.status!;
      }
  }

  FilterParams getFilters() {
    return FilterParams(
      amount: _sharedPreferences.getString(PREFS_KEY_FILTER_AMOUNT) ?? '',
      statuses: _sharedPreferences.getStringList(PREFS_KEY_FILTER_STATUSES) ?? selectedStatus,
      startDate: _sharedPreferences.getString(PREFS_KEY_FILTER_STARTDATE),
      endDate: _sharedPreferences.getString(PREFS_KEY_FILTER_ENDDATE)
    );
  }

  Future<void> clearFilters() async {
    _sharedPreferences.remove(PREFS_KEY_FILTER_AMOUNT);
    _sharedPreferences.remove(PREFS_KEY_FILTER_STATUSES);
    _sharedPreferences.remove(PREFS_KEY_FILTER_STARTDATE);
    _sharedPreferences.remove(PREFS_KEY_FILTER_ENDDATE);
  }

  // OnBoarding
  Future<void> setOnBoardingScreenViewed() async{
    _sharedPreferences.setBool(PREFS_KEY_ONBOARDING_SCREEN_VIEWED, true);
  }

  bool isOnBoardingScreenViewed() {
    return _sharedPreferences.getBool(PREFS_KEY_ONBOARDING_SCREEN_VIEWED) ?? false;
  }

  // Login
  Future<void> setUserLoggedIn() async{
    _sharedPreferences.setBool(PREFS_KEY_IS_USER_LOGGED_IN, true);
  }

  Future<bool> isUserLoggedIn() async{
    return _sharedPreferences.getBool(PREFS_KEY_IS_USER_LOGGED_IN) ?? false;
  }

  // Login
  Future<void> setAccessToken(String token) async{
    _sharedPreferences.setString(KEY_ACCESS_TOKEN, token);
  }

  String getAccessToken() {
    return _sharedPreferences.getString(KEY_ACCESS_TOKEN) ?? '';
  }

  bool hasAccessToken() {
    return _sharedPreferences.containsKey(KEY_ACCESS_TOKEN);
  }

  Future<bool> removeAccessToken() async{
    return _sharedPreferences.remove(KEY_ACCESS_TOKEN);
  }

  Future<void> clearForLogOut() {
    return _sharedPreferences!.remove(KEY_ACCESS_TOKEN);
  }

  // Default Params
  Future<void> setCallback(String callback) async{
    _sharedPreferences.setString(PREFS_KEY_CALLBACK_URL, callback ?? '');
  }

  Future<void> setTrigger(String trigger) async{
    _sharedPreferences.setString(PREFS_KEY_TRIGGER_URL, trigger ?? '');
  }

  String getCallback() {
    return _sharedPreferences.getString(PREFS_KEY_CALLBACK_URL) ?? '';
  }

  String getTrigger() {
    return _sharedPreferences.getString(PREFS_KEY_TRIGGER_URL) ?? '';
  }
}