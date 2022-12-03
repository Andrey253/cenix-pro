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
      yield* phoneChange(repository, state, event);
    } else if (event is CheckEnteredCode) {
      yield* checkEnteredCode(repository, state, event);
    } else if (event is ReenterPhoneEvent) {
      yield* reenterPhone(repository, state, event);
    } else if (event is PhoneEnteredEvent) {
      yield* phoneEntered(repository, state, event);
    }
  }

  Stream<LoginState> phoneEntered(
      LoginRepository repository, LoginState state, PhoneEnteredEvent event) async* {
    if (regex.hasMatch(event.phone)) {
      try {
        yield const LoginSuccessState(true);
        await repository.requestSms(event.phone);
        const LoginSuccessState(false);
        yield SmsRequestedState(event.phone);
      } on Exception catch (_) {
        yield const PhoneInputState(error: 'Error geting Sms');
      }
    }
  }

  Stream<LoginState> checkEnteredCode(
      LoginRepository repository, LoginState state, CheckEnteredCode event) async* {
    yield const LoginSuccessState(true);
    try {
      //  final token =
      await repository.checkCode(event.phone, event.code);
      yield const LoginSuccessState(false);
    } on Exception catch (_) {
      yield const PhoneInputState(error: 'Pin is not valid');
    }
  }

  Stream<LoginState> phoneChange(
      LoginRepository repository, LoginState state, PhoneChangeEvent event) async* {
    if (regex.hasMatch(event.phone)) {
      yield const PhoneInputState();
    } else {
      yield const PhoneInputState(error: 'Не вырный формат');
    }
  }

  Stream<LoginState> reenterPhone(
      LoginRepository repository, LoginState state, ReenterPhoneEvent event) async* {
    yield const PhoneInputState();
  }
}
