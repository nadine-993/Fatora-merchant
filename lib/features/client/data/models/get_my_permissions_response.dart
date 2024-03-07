import 'package:fatora/core/api/core_models/base_result_model.dart';

class GetMyPermissionsResponse extends BaseResultModel{
  Items? items;

  GetMyPermissionsResponse(
      {
        this.items,
      });

  GetMyPermissionsResponse.fromJson(Map<String, dynamic> json) {
    items = Items.fromJson(json['items']);
  }
}

class Items {
  bool? cancel;
  bool? reverse;

  Items(
      {
        this.cancel,
        this.reverse,
      });

  Items.fromJson(List<dynamic> permissions) {
    reverse = permissions.contains('Pages.Administration.Transactions.Reverse') ? true : false;
    cancel = permissions.contains('Pages.Administration.Transactions.Cancel') ? true : false;
  }
}

