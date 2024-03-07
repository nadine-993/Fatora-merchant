import 'base_model.dart';

class BaseResultModel extends BaseModel {
  BaseResultModel();

  factory BaseResultModel.fromJson(json) => BaseResultModel();

  Map<String, dynamic> toJson() =>
      {'From BaseResultModel': 'You must extends this'};
}

abstract class ListResultModel<Model> extends BaseResultModel {
  List<Model> list = [];

  @override
  Map<String, dynamic> toJson() =>
      {'From ListResultModel': 'You must extends this'};
}
