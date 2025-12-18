import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/storage/app_storage.dart';
import 'package:myapp/features/auth/presentation/cubit/register_state.dart';


class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterState.initial());

  void updatePhone(String phone) {
    emit(state.copyWith(phone: phone));
  }

  void updateCountryCode(String code) {
    emit(state.copyWith(countryCode: code));
  }

  void updatePassword(String password) {
    emit(state.copyWith(password: password));
  }

  // Заглушки для отправки/верификации OTP (потом подключим usecase + dio)
  Future<void> sendOtp() async {
    emit(state.copyWith(status: RegisterStatus.sendingOtp));
    // Симуляция задержки
    await Future.delayed(const Duration(seconds: 2));
    emit(state.copyWith(status: RegisterStatus.otpSent));
  }

  Future<void> verifyOtp(String code) async {
    emit(state.copyWith(otpCode: code, status: RegisterStatus.verifying));
    await Future.delayed(const Duration(seconds: 2));
    // Успех → сохраняем логин
    await AppStorage.setLoggedIn(true);
    emit(state.copyWith(status: RegisterStatus.success));
  }

  void reset() => emit(RegisterState.initial());
}