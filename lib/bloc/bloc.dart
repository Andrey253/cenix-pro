import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task/bloc/state.dart';
import 'package:test_task/repository/repository.dart';

import 'event.dart';

class LoginBloc extends Cubit<LoginState> {
  LoginBloc(this.repository) : super(const PhoneInputState());

  final LoginRepository repository;
  RegExp regex = RegExp(r'^\+\d{11}$');

  Future<void> onPhoneChanged(String phone) async {
    emit(regex.hasMatch(phone)
        ? const PhoneInputState()
        : const PhoneInputState(error: 'Не вырный формат'));
  }

  Future<void> onPinEntered(String code, String phone) async {
    emit(const LoginSuccessState(true));
    try {
      //  final token =
      await repository.checkCode(phone, code);
      emit(const LoginSuccessState(false));
    } on Exception catch (_) {
      emit(const PhoneInputState(error: 'Pin is not valid'));
    }
  }

  Future<void> onPhoneSubmitted(String phone) async {
 if (regex.hasMatch(phone)) {
        try {
          emit( const LoginSuccessState(true));
          await repository.requestSms(phone);
          const LoginSuccessState(false);
           emit(  SmsRequestedState(phone));
        } on Exception catch (_) {
           emit(  const PhoneInputState(error: 'Error geting Sms'));
        }
      }
  }

  Future<void> reenterPhone() async {
    emit(const PhoneInputState());
  }
  // @override
  // Stream<LoginState> mapEventToState(
  //   LoginEvent event,
  // ) async* {
  //   if (event is PhoneChangeEvent) {
  //     if (regex.hasMatch(event.phone)) {
  //       yield const PhoneInputState();
  //     } else {
  //       yield const PhoneInputState(error: 'Не вырный формат');
  //     }
  //   } else if (event is CheckEnteredCode) {
  //     yield const LoginSuccessState(true);
  //     try {
  //     //  final token =
  //       await repository.checkCode(event.phone, event.code);
  //       yield const LoginSuccessState(false);
  //     } on Exception catch (_) {
  //       yield const PhoneInputState(error: 'Pin is not valid');
  //     }
  //   } else if (event is ReenterPhoneEvent) {
  //     yield const PhoneInputState();
  //   } else if (event is PhoneEnteredEvent) {
  //     if (regex.hasMatch(event.phone)) {
  //       try {
  //         yield const LoginSuccessState(true);
  //         await repository.requestSms(event.phone);
  //         const LoginSuccessState(false);
  //         yield SmsRequestedState(event.phone);
  //       } on Exception catch (_) {
  //         yield const PhoneInputState(error: 'Error geting Sms');
  //       }
  //     }

  //     //TODO: describe logic
  //   } else {}
  // }
}
