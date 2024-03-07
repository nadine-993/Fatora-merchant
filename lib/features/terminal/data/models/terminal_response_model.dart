import '../../../../core/api/core_models/base_result_model.dart';

class TerminalResponseModel extends BaseResultModel {
  List<String>? terminals;

  TerminalResponseModel(
      {
        this.terminals,
      });

  TerminalResponseModel.fromJson(Map<String, dynamic> json) {
    terminals = json['terminals'].cast<String>().toList();
  }
}

