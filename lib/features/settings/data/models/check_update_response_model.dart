import '../../../../core/api/core_models/base_result_model.dart';

class CheckUpdateResponseModel extends BaseResultModel{
  String? version;
  String? url;
  String? description;
  bool? isMajor;
  bool? availableUpdate;

  CheckUpdateResponseModel(
      {
        this.version,
        this.url,
        this.description,
        this.isMajor,
        this.availableUpdate,
      });

  CheckUpdateResponseModel.fromJson(Map<String, dynamic> json) {
    version = json['version'] ?? '';
    url = json['url'] ?? '';
    isMajor = json['isMajor'] ?? '';
    availableUpdate = json['availableUpdate'] ?? '';
    description = json['description'] ?? '';
  }
}