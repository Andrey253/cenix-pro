import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState({this.error});

  final String? error;


  @override
  List<Object?> get props => [error];
}

class PhoneInputState extends LoginState {
  const PhoneInputState({String? error}) : super(error: error);
}

class SmsRequestedState extends LoginState {
  const SmsRequestedState(this.phone, {String? error}) : super(error: error);

  final String phone;
}

class LoginSuccessState extends LoginState {
  const LoginSuccessState();
}
class LoadingState extends LoginState {
  const LoadingState();
}

