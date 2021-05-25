class CubitState {}

class InitialState extends CubitState {}

class LoadingState extends CubitState {
  String loadingMessage;

  LoadingState({this.loadingMessage});
}

class SuccessState extends CubitState {
  String message;

  SuccessState({this.message});
}

class FailedState extends CubitState {
  String message;
  String status;
  Exception exception;
  int errorCode;

  FailedState({this.errorCode ,this.message, this.status, this.exception});
}
class NoInternetState extends CubitState {
  String message;

  NoInternetState({this.message});
}