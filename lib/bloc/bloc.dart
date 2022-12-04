import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task/bloc/state.dart';
import 'package:test_task/repository/repository.dart';

class LoginBloc extends Cubit<LoginState> {
  LoginBloc(this.repository) : super(const PhoneInputState());

  final LoginRepository repository;
  RegExp regex = RegExp(r'^\+\d{11}$');

  Future<void> onPhoneChanged(String phone) async {
    emit(regex.hasMatch(phone)
        ? const PhoneInputState()
        : const PhoneInputState(error: 'Не вырный формат'));
  }

  Future<void> onPinEntered(TextEditingController code, String phone) async {
    emit(const LoadingState());
    try {
      //  final token =
      await repository.checkCode(phone, code.text);

      _state = const LoginSuccessState();
      if (_state != state) emit(_state);
    } on Exception catch (_) {
      code.text = '';
      _state = const PhoneInputState(error: 'Error checking Pin');
      if (_state != state) emit(_state);
    }
  }

  Future<void> onPhoneSubmitted(String phone) async {
    if (regex.hasMatch(phone)) {
      try {
        emit(const LoadingState());
        await repository.requestSms(phone);
        _state = SmsRequestedState(phone);
        if (_state != state) emit(_state);
      } on Exception catch (_) {
        _state = const PhoneInputState(error: 'Error geting Sms');
        if (_state != state) emit(_state);
      }
    }
  }

  Future<void> reenterPhone() async {
    emit(const PhoneInputState());
  }
}
