import 'base_error.dart';


class ConnectionError extends BaseError {
  static String errorMessage = 'ConnectionError';
  String message = errorMessage;

  List<Object> get props => [];
}