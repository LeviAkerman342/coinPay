import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/core/router/domain/app_routes.dart';
import '../cubit/send_money_cubit.dart';
import '../widgets/recipient_item.dart';
import '../widgets/purpose_item.dart';

class SendMoneyPage extends StatelessWidget {
  const SendMoneyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SendMoneyCubit(),
      child: BlocBuilder<SendMoneyCubit, SendMoneyState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                state.step == SendStep.recipient
                    ? 'Choose Recipient'
                    : 'Select a Purpose',
              ),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => context.pop(),
              ),
            ),
            body: SafeArea(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: context.read<SendMoneyCubit>().pageController,
                children: [
                  _RecipientStep(),
                  _PurposeStep(),
                  _AmountStep(),
                  _ConfirmStep(),
                  _SuccessStep(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Добавим PageController в Cubit (добавь в cubit.dart)
late PageController pageController = PageController();

// Шаги как отдельные виджеты

class _RecipientStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SendMoneyCubit>();

    // Заглушка недавних получателей
    final recent = [
      {'name': 'Ahmed Hasan', 'phone': 'ahmed.hasan@gmail.com', 'avatar': null},
      {'name': 'Wahid Hasan', 'phone': 'wahid@gmail.com', 'avatar': null},
     
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search your contact or email/phone',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: recent.length,
            itemBuilder: (ctx, i) {
              final item = recent[i];
              return RecipientItem(
                name: item['name']!,
                subtitle: item['phone']!,
                onTap: () {
                  cubit.selectRecipient(
                    'id${i + 1}',
                    item['name']!,
                    item['avatar'],
                  );
                  cubit.nextPage();
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => context.push(AppRoutes.scanQr),
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scan to Pay'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0066FF),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PurposeStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final purposes = ['Personal', 'Business', 'Payment', 'Gift', 'Other'];

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Select a transaction purpose',
            style: TextStyle(fontSize: 18),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: purposes.length,
            itemBuilder: (ctx, i) {
              return PurposeItem(
                title: purposes[i],
                icon: _getPurposeIcon(purposes[i]),
                isSelected:
                    context.watch<SendMoneyCubit>().state.purpose ==
                    purposes[i],
                onTap: () =>
                    context.read<SendMoneyCubit>().selectPurpose(purposes[i]),
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _getPurposeIcon(String purpose) {
    switch (purpose) {
      case 'Personal':
        return Icons.person;
      case 'Business':
        return Icons.business;
      case 'Payment':
        return Icons.payment;
      case 'Gift':
        return Icons.card_giftcard;
      default:
        return Icons.more_horiz;
    }
  }
}

class _AmountStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<SendMoneyCubit>().state;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(state.recipientAvatar ?? ''),
          ),
          const SizedBox(height: 16),
          Text(
            state.recipientName ?? '',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(state.purpose, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 40),
          TextField(
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              hintText: '0',
              border: InputBorder.none,
            ),
            onChanged: (v) => context.read<SendMoneyCubit>().setAmount(
              double.tryParse(v) ?? 0,
            ),
          ),
          const Text('Choose Account', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          // Заглушка аккаунтов
          ElevatedButton(
            onPressed: () => context.read<SendMoneyCubit>().selectAccount(
              'Main Account ••••1234',
            ),
            child: const Text('Main Account ••••1234'),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.amount > 0
                  ? () => context.read<SendMoneyCubit>().confirmSend()
                  : null,
              child: Text('Pay \$${state.amount.toStringAsFixed(0)}'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.read<SendMoneyCubit>().state;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, size: 100, color: Colors.green),
          const SizedBox(height: 24),
          Text(
            'Transaction Completed',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text('at ${DateTime.now().toString().substring(0, 16)}'),
          const SizedBox(height: 40),
          Text('You sent \$${state.amount} to ${state.recipientName}'),
          const SizedBox(height: 60),
          ElevatedButton(
            onPressed: () => context.go(AppRoutes.journal),
            child: const Text('Back to Homepage'),
          ),
          TextButton(
            onPressed: () => context.read<SendMoneyCubit>().reset(),
            child: const Text('Make another Payment'),
          ),
        ],
      ),
    );
  }
}
class _ConfirmStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<SendMoneyState>();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text('Review & Confirm', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          CircleAvatar(radius: 50, child: Text(state.recipientName?[0] ?? '?', style: const TextStyle(fontSize: 40))),
          const SizedBox(height: 16),
          Text(state.recipientName ?? '', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(state.purpose, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 40),
          Text('\$${state.amount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Text('From: ${state.fromAccount ?? 'Main Account'}'),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.read<SendMoneyCubit>().confirmSend(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0066FF),
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text('Confirm & Send Money', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => context.read<SendMoneyCubit>().previousPage(),
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }
}