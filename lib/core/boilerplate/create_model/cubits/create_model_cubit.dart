import 'package:bloc/bloc.dart';
import '../../../api/core_models/base_response_model.dart';
import '../../../api/core_models/base_result_model.dart';
import '/core/api/errors/base_error.dart';
import 'package:meta/meta.dart';

part 'create_model_state.dart';

typedef RepositoryCallBack = Future<BaseResultModel?> Function(dynamic data);

class CreateModelCubit<Model> extends Cubit<CreateModelState> {
  final RepositoryCallBack getData;

  CreateModelCubit(this.getData) : super(CreateModelInitial());

  Future createModel(dynamic requestData) async {
    emit(Loading());
    try {
      var response = await getData(requestData);
      if (response is Model) {
        emit(CreateModelSuccessfully(response));
      } else if (response is ServerError) {
        emit(Error(
            '${response.message.toString()}\n${response.details ?? ''}'));
      } else if (response is BaseError) {
        emit(Error(response.message));
      }
    } catch (e) {
      emit(Error(e.toString()));
    }
  }
}
