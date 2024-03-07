import '../errors/base_error.dart';

class CustomError extends BaseError {

  final String message;

  CustomError({this.message = ""});

  List<Object> get props => [];
}