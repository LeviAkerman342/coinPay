import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum SendStep { recipient, purpose, amount, confirm, success }

class SendMoneyState {
  final SendStep step;
  final String? recipientId;
  final String? recipientName;
  final String? recipientAvatar;
  final String purpose;
  final double amount;
  final String? fromAccount;

  SendMoneyState({
    this.step = SendStep.recipient,
    this.recipientId,
    this.recipientName,
    this.recipientAvatar,
    this.purpose = 'Personal',
    this.amount = 0.0,
    this.fromAccount,
  });

  SendMoneyState copyWith({
    SendStep? step,
    String? recipientId,
    String? recipientName,
    String? recipientAvatar,
    String? purpose,
    double? amount,
    String? fromAccount,
  }) {
    return SendMoneyState(
      step: step ?? this.step,
      recipientId: recipientId ?? this.recipientId,
      recipientName: recipientName ?? this.recipientName,
      recipientAvatar: recipientAvatar ?? this.recipientAvatar,
      purpose: purpose ?? this.purpose,
      amount: amount ?? this.amount,
      fromAccount: fromAccount ?? this.fromAccount,
    );
  }
}

class SendMoneyCubit extends Cubit<SendMoneyState> {
  SendMoneyCubit() : super(SendMoneyState());

  late final PageController pageController = PageController();

  // Публичные методы для переходов
  void nextPage() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void previousPage() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void selectRecipient(String id, String name, String? avatar) {
    emit(
      state.copyWith(
        recipientId: id,
        recipientName: name,
        recipientAvatar: avatar,
        step: SendStep.purpose,
      ),
    );
    nextPage();
  }

  void selectPurpose(String purpose) {
    emit(state.copyWith(purpose: purpose, step: SendStep.amount));
    nextPage();
  }

  void setAmount(double amount) {
    emit(state.copyWith(amount: amount));
  }

  void selectAccount(String account) {
    emit(state.copyWith(fromAccount: account, step: SendStep.confirm));
    nextPage();
  }

  void confirmSend() {
    emit(state.copyWith(step: SendStep.success));
    nextPage();
  }

  void reset() {
    emit(SendMoneyState());
    pageController.jumpToPage(0);
  }

  @override
  Future<void> close() async {
    pageController.dispose();
    await super.close();
  }
}
