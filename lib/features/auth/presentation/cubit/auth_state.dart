enum AuthStatus {
  initial,
  loading,
  success,
  error,
  sendingOtp,
  otpSent,
  verifying,
}

class AuthState {
  final String countryCode;
  final String phone;
  final String password;
  final AuthStatus status;

  AuthState({
    this.countryCode = '+373',
    this.phone = '',
    this.password = '',
    this.status = AuthStatus.initial,
  });

  factory AuthState.initial() => AuthState();

  AuthState copyWith({
    String? countryCode,
    String? phone,
    String? password,
    AuthStatus? status,
  }) {
    return AuthState(
      countryCode: countryCode ?? this.countryCode,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }

  bool get canSubmit => phone.length > 8 && password.length >= 6;
}
