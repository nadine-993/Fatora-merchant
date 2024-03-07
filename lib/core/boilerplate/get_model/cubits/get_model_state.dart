part of 'get_model_cubit.dart';

@immutable
abstract class GetModelState {}

class GetModelInitial extends GetModelState {}


class GetModelLoading extends GetModelState  {}

class GetModelSuccessfully extends GetModelState  {
  final dynamic model;

  GetModelSuccessfully(this.model);
}

class GetModelError extends GetModelState  {
  final String message;
  GetModelError(this.message);
}