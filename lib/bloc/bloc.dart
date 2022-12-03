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
    LoginState _state;

    if (event is PhoneChangeEvent) {
      if (regex.hasMatch(event.phone)) {
        _state = const PhoneInputState();
      } else {
        _state = const PhoneInputState(error: 'Не вырный формат');
      }
      if (_state != state) yield _state;
    } else if (event is CheckEnteredCode) {
      _state = const LoginSuccessState(true);
      if (_state != state) yield _state;
      try {
        //  final token =
        await repository.checkCode(event.phone, event.code);
        _state = const LoginSuccessState(false);
        if (_state != state) yield _state;
      } on Exception catch (_) {
        _state = const PhoneInputState(error: 'Pin is not valid');
        if (_state != state) yield _state;
      }
    } else if (event is ReenterPhoneEvent) {
      _state = const PhoneInputState();
      if (_state != state) yield _state;
    } else if (event is PhoneEnteredEvent) {
      if (regex.hasMatch(event.phone)) {
        try {
          _state = const LoginSuccessState(true);
          if (_state != state) yield _state;
          await repository.requestSms(event.phone);
          const LoginSuccessState(false);
          _state = SmsRequestedState(event.phone);
        } on Exception catch (_) {
          _state = const PhoneInputState(error: 'Error geting Sms');
          if (_state != state) yield _state;
        }
      }

      //TODO: describe logic
    }
  }
}
