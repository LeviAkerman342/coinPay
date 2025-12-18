import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum RequestStep { initial, recipient, purpose, amount, confirm, success }

class RequestMoneyState {
  final RequestStep step;
  final String? recipientId;
  final String? recipientName;
  final String? recipientAvatar;
  final String purpose;
  final double amount;

  RequestMoneyState({
    this.step = RequestStep.initial,
    this.recipientId,
    this.recipientName,
    this.recipientAvatar,
    this.purpose = 'Personal',
    this.amount = 0.0,
  });

  RequestMoneyState copyWith({
    RequestStep? step,
    String? recipientId,
    String? recipientName,
    String? recipientAvatar,
    String? purpose,
    double? amount,
  }) {
    return RequestMoneyState(
      step: step ?? this.step,
      recipientId: recipientId ?? this.recipientId,
      recipientName: recipientName ?? this.recipientName,
      recipientAvatar: recipientAvatar ?? this.recipientAvatar,
      purpose: purpose ?? this.purpose,
      amount: amount ?? this.amount,
    );
  }
}

class RequestMoneyCubit extends Cubit<RequestMoneyState> {
  RequestMoneyCubit() : super(RequestMoneyState());

  late final PageController pageController = PageController(initialPage: 0);

  void startRequest() {
    emit(state.copyWith(step: RequestStep.recipient));
    nextPage();
  }

  void selectRecipient(String id, String name, String? avatar) {
    emit(
      state.copyWith(
        recipientId: id,
        recipientName: name,
        recipientAvatar: avatar,
        step: RequestStep.purpose,
      ),
    );
    nextPage();
  }

  void selectPurpose(String purpose) {
    emit(state.copyWith(purpose: purpose, step: RequestStep.amount));
    nextPage();
  }

  void setAmount(double amount) {
    emit(state.copyWith(amount: amount));
  }

  void confirmRequest() {
    emit(state.copyWith(step: RequestStep.success));
    nextPage();
  }

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

  void reset() {
    emit(RequestMoneyState());
    pageController.jumpToPage(0);
  }

  @override
  Future<void> close() async {
    pageController.dispose();
    await super.close();
  }
}
