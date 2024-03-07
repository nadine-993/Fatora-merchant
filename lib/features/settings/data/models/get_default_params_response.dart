import 'package:fatora/core/api/core_models/base_result_model.dart';

class GetDefaultParamsResponse extends BaseResultModel{
  String? callbackURL;
  String? triggerURL;
  String? notes;
  List<String>? status;

  GetDefaultParamsResponse(
      {
        this.callbackURL,
        this.triggerURL,
        this.notes,
        this.status,
      });

  GetDefaultParamsResponse.fromJson(Map<String, dynamic> json) {
    callbackURL = json['callbackURL'] ?? '';
    triggerURL = json['triggerURL'] ?? '';
    notes = json['notes'] ?? '';
    status = (json['status'] as List)?.map((item) => item as String)?.toList() ?? [];
  }
}