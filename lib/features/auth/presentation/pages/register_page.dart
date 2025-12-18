import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:myapp/core/router/domain/app_routes.dart';
import 'package:myapp/features/auth/presentation/cubit/register_state.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../cubit/register_cubit.dart';
import '../widgets/confirm_phone_dialog.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterCubit(),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state.status == RegisterStatus.success) {
          // context.go(AppRoutes.journal);
        }
      },
      builder: (context, state) {
        // Первый экран — ввод номера и пароля
        if (state.status == RegisterStatus.initial) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                TextButton(
                  onPressed: () => context.go(AppRoutes.login),
                  child: const Text('Log In', style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Иллюстрация (замени на свою)
                    Expanded(
                      flex: 2,
                      child: Image.network(
                        'https://thumbs.dreamstime.com/b/financial-technology-mobile-banking-illustration-conceptual-render-composition-features-cartoon-style-smartphone-404327631.jpg', // [image:4]
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Create your\nCoinpay account',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Coinpay is a powerful tool that allows you to easily send, receive, and track all your transactions.',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    const SizedBox(height: 40),

                    // Поле номера с выбором страны
                    Row(
                      children: [
                        CountryCodePicker(
                          onChanged: (country) {
                            context.read<RegisterCubit>().updateCountryCode(country.dialCode ?? '+880');
                          },
                          initialSelection: 'BD',
                          favorite: ['+880', '+1'],
                          showCountryOnly: false,
                          showOnlyCountryWhenClosed: false,
                          alignLeft: false,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              hintText: 'Mobile number',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) => context.read<RegisterCubit>().updatePhone(value),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Пароль
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => context.read<RegisterCubit>().updatePassword(value),
                    ),
                    const SizedBox(height: 40),

                    // Кнопка Sign up
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state.phone.length > 8
                            ? () async {
                                final fullPhone = '${state.countryCode}${state.phone}';
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => ConfirmPhoneDialog(phone: fullPhone),
                                );
                                if (confirmed == true && mounted) {
                                  context.read<RegisterCubit>().sendOtp();
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0066FF),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: const Text('Sign up', style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                    const Spacer(),
                    const Center(
                      child: Text(
                        'By continuing you accept our\nTerms of Service and Privacy Policy',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Экран OTP
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.read<RegisterCubit>().reset(),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Иллюстрация OTP
                  Expanded(
                    child: Image.network(
                      'https://thumbs.dreamstime.com/b/chat-message-mobile-cell-phone-smartphone-icon-simple-pictogram-graphic-line-stroke-outline-password-verification-code-sms-sign-389703837.jpg', // [image:2]
                      fit: BoxFit.contain,
                    ),
                  ),
                  const Text(
                    'Confirm your phone',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'We send 6 digits code to ${state.countryCode} ${state.phone}',
                    style: const TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // OTP поля
                  PinCodeTextField(
                    appContext: context,
                    length: 6,
                    onChanged: (value) {},
                    onCompleted: (code) {
                      context.read<RegisterCubit>().verifyOtp(code);
                    },
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(12),
                      fieldHeight: 60,
                      fieldWidth: 50,
                      activeFillColor: Colors.white,
                      inactiveFillColor: Colors.grey[100],
                      selectedFillColor: Colors.blue[50],
                    ),
                    enableActiveFill: true,
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {}, // resend
                    child: const Text('Didn\'t get a code? Resend'),
                  ),
                  if (state.status == RegisterStatus.sendingOtp || state.status == RegisterStatus.verifying)
                    const CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}