enum RegisterStatus { initial, sendingOtp, otpSent, verifying, success, error }

class RegisterState {
  final String countryCode;
  final String phone;
  final String password;
  final String otpCode;
  final RegisterStatus status;

  RegisterState({
    this.countryCode = '+880',
    this.phone = '',
    this.password = '',
    this.otpCode = '',
    this.status = RegisterStatus.initial,
  });

  factory RegisterState.initial() => RegisterState();

  RegisterState copyWith({
    String? countryCode,
    String? phone,
    String? password,
    String? otpCode,
    RegisterStatus? status,
  }) {
    return RegisterState(
      countryCode: countryCode ?? this.countryCode,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      otpCode: otpCode ?? this.otpCode,
      status: status ?? this.status,
    );
  }
}