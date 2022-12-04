import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState({this.error, this.isLoading = false});

  final String? error;
  final bool isLoading;

  @override
  List<Object?> get props => [error, isLoading];
}

class PhoneInputState extends LoginState {
  const PhoneInputState({String? error}) : super(error: error);
      @override
  List<Object?> get props => [error];
}

class SmsRequestedState extends LoginState {
  const SmsRequestedState(this.phone, {String? error}) : super(error: error);

  final String phone;
    @override
  List<Object?> get props => [phone, error];
}

class LoginSuccessState extends LoginState {
  const LoginSuccessState(bool isLoading) : super(isLoading: isLoading);
      @override
  List<Object?> get props => [isLoading];
}

