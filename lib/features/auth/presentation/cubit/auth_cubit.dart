import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/storage/app_storage.dart';
import 'package:myapp/features/auth/presentation/cubit/auth_state.dart';


class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState.initial());

  void updatePhone(String phone) => emit(state.copyWith(phone: phone));
  void updateCountryCode(String code) => emit(state.copyWith(countryCode: code));
  void updatePassword(String password) => emit(state.copyWith(password: password));

  // Логин
  Future<void> login() async {
    if (state.phone.isEmpty || state.password.isEmpty) return;

    emit(state.copyWith(status: AuthStatus.loading));

    // Заглушка — потом подключишь Dio к реальному API
    await Future.delayed(const Duration(seconds: 2));

    // Успех
    await AppStorage.setLoggedIn(true);
    emit(state.copyWith(status: AuthStatus.success));
  }

  // Для регистрации (оставляем старые методы)
  Future<void> sendOtp() async { /* ... как раньше */ }
  Future<void> verifyOtp(String code) async { /* ... как раньше */ }

  void reset() => emit(AuthState.initial());
}