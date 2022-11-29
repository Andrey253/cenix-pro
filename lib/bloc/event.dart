import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {}

class PhoneEnteredEvent extends LoginEvent {
  PhoneEnteredEvent(this.phone);

  final String phone;

  @override
  List<Object?> get props => [phone];
}
class PhoneChangeEvent extends LoginEvent {
  PhoneChangeEvent(this.phone);

  final String phone;

  @override
  List<Object?> get props => [phone];
}

class ResendSmsEvent extends LoginEvent {
  @override
  List<Object?> get props => [];
}

class ReenterPhoneEvent extends LoginEvent {
  @override
  List<Object?> get props => [];
}

class CheckEnteredCode extends LoginEvent {
  CheckEnteredCode(this.code, this.phone);
  final String code;
  // added phone
  final String phone;

  @override
  List<Object?> get props => [code,phone];
}
