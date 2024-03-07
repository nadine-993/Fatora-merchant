import '../errors/base_error.dart';
import 'base_result_model.dart';

class BaseResponseModel<Result extends BaseResultModel> {
  Result? result;
  bool? success;
  BaseError? error;
  bool? unAuthorizedRequest;
  bool? bAbp;
  ServerError? serverError;

  BaseResponseModel(
      {this.result,
      this.success,
      this.serverError,
      this.error,
      this.unAuthorizedRequest,
      this.bAbp});

  BaseResponseModel.fromJson(
      {Map<String, dynamic>? json,
      Result Function(Map<String, dynamic>)? fromJson,
      BaseError? error}) {
      if (json == null) {
        if (error != null) {
          this.error = error;
          success = false;
        }
      } else {
        success = json['success'] ?? false;
       serverError =
            json['error'] != null ? ServerError.fromJson(json['error']) : ServerError();
        unAuthorizedRequest = json['unAuthorizedRequest'];
        bAbp = json['__abp'];
        this.error = error;

        if (fromJson != null) {
          if (json['result'] != null) {
            result = fromJson(json['result']);
          } else {
            if (success!) result = fromJson({});
          }
        }
      }
  }

}

class ServerError extends BaseResultModel {
  int? code;
  String? message;
  String? details;
  List<ValidationErrors>? validationErrors;

  ServerError({this.code, this.message, this.details, this.validationErrors});

  ServerError.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    details = json['details'];
    if (json['validationErrors'] != null) {
      validationErrors = List.from(json['validationErrors'])
          .map((e) => ValidationErrors.fromJson(e))
          .toList();
      json['validationErrors'].forEach((v) {
        validationErrors!.add(ValidationErrors.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['code'] = code;
    data['message'] = message;
    data['details'] = details;
    if (validationErrors != null) {
      data['validationErrors'] =
          validationErrors!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ValidationErrors {
  String? message;
  List<String>? members;

  ValidationErrors({this.message, this.members});

  ValidationErrors.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    members = json['members'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['message'] = message;
    data['members'] = members;
    return data;
  }
}
