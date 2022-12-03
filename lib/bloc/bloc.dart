import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task/bloc/state.dart';
import 'package:test_task/repository/repository.dart';

import 'event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this.repository) : super(const PhoneInputState());

  final LoginRepository repository;
  RegExp regex = RegExp(r'^\+\d{11}$');

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is PhoneChangeEvent) {
      phoneChange(repository, state, event);
    } else if (event is CheckEnteredCode) {
      checkEnteredCode(repository, state, event);
    } else if (event is ReenterPhoneEvent) {
      reenterPhone(repository, state, event);
    } else if (event is PhoneEnteredEvent) {
      phoneEntered(repository, state, event);
    }
  }

  Stream<LoginState> phoneEntered(LoginRepository repository, LoginState state,
      PhoneEnteredEvent event) async* {
    if (regex.hasMatch(event.phone)) {
      LoginState _state;
      try {
        _state = const LoginSuccessState(true);
        if (_state != state) yield _state;
        await repository.requestSms(event.phone);
        const LoginSuccessState(false);
        _state = SmsRequestedState(event.phone);
      } on Exception catch (_) {
        _state = const PhoneInputState(error: 'Error geting Sms');
      }
      if (_state != state) yield _state;
    }
  }

  Stream<LoginState> checkEnteredCode(LoginRepository repository,
      LoginState state, CheckEnteredCode event) async* {
    LoginState _state;
    _state = const LoginSuccessState(true);
    if (_state != state) yield _state;
    try {
      //  final token =
      await repository.checkCode(event.phone, event.code);
      _state = const LoginSuccessState(false);
    } on Exception catch (_) {
      _state = const PhoneInputState(error: 'Pin is not valid');
    }
    if (_state != state) yield _state;
  }

  Stream<LoginState> phoneChange(LoginRepository repository,
      LoginState state, PhoneChangeEvent event) async* {
    LoginState _state;
    if (regex.hasMatch(event.phone)) {
      _state = const PhoneInputState();
    } else {
      _state = const PhoneInputState(error: 'Не вырный формат');
    }
    if (_state != state) yield _state;
  }

  Stream<LoginState> reenterPhone(LoginRepository repository,
      LoginState state, ReenterPhoneEvent event) async* {
    if (state != const PhoneInputState()) yield const PhoneInputState();
  }
}
