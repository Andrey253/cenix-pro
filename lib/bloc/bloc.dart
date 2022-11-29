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
      if (regex.hasMatch(event.phone)) {
        yield const PhoneInputState();
      } else {
        yield const PhoneInputState(error: 'Не вырный формат');
      }
    } else if (event is CheckEnteredCode) {
      yield const LoginSuccessState(true);
      try {
        final token = await repository.checkCode(event.phone, event.code);
        yield const LoginSuccessState(false);
      } on Exception catch (e) {
        yield const PhoneInputState(error: 'Pin is not valid');
      }
    } else if (event is ReenterPhoneEvent) {
      yield const PhoneInputState();
    } else if (event is PhoneEnteredEvent) {
      if (regex.hasMatch(event.phone)) {
        try {
          yield const LoginSuccessState(true);
          await repository.requestSms(event.phone);
          yield const LoginSuccessState(false);
          yield SmsRequestedState(event.phone);
        } on Exception catch (e) {
          yield const PhoneInputState(error: 'Error geting Sms');
        }
      }

      //TODO: describe logic
    } else {}
  }
}
