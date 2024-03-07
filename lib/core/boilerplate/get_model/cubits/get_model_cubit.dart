import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../api/errors/net_error.dart';
import '../../../api/core_models/base_response_model.dart';
import '../../../api/core_models/base_result_model.dart';
import '/core/api/errors/base_error.dart';

part 'get_model_state.dart'; 
typedef RepositoryCallBack  = Future<BaseResultModel?> Function( dynamic data);

class GetModelCubit<Model> extends Cubit<GetModelState> {

  final RepositoryCallBack getData;
  GetModelCubit(this.getData) : super(GetModelInitial());

  getModel({ Map<String,dynamic>? params   })async{
    emit(GetModelLoading ());
    var response = await getData(params);
    if(response is Model)
    {
      emit(GetModelSuccessfully (response ));
    }
    else if(response is NetError) {
      emit(GetModelError( response.message));
    }
    else if(response is BaseError) {
      emit(GetModelError( response.message));
    } else if (response is ServerError) {
      emit(GetModelError(response.message! ));
    }

  }

}
