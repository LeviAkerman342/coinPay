import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/core/router/domain/app_routes.dart';
import 'package:myapp/features/send_money/presentation/widgets/purpose_item.dart';
import 'package:myapp/features/send_money/presentation/widgets/recipient_item.dart';
import '../cubit/request_money_cubit.dart';
import 'request_initial_page.dart';

class RequestMoneyPage extends StatelessWidget {
  const RequestMoneyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RequestMoneyCubit(),
      child: BlocBuilder<RequestMoneyCubit, RequestMoneyState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(state.step == RequestStep.initial
                  ? ''
                  : state.step == RequestStep.recipient
                      ? 'Choose Recipient'
                      : 'Select a Purpose'),
              leading: state.step != RequestStep.initial
                  ? IconButton(icon: const Icon(Icons.close), onPressed: () => context.pop())
                  : null,
            ),
            body: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: context.read<RequestMoneyCubit>().pageController,
              children: const [
                RequestInitialPage(),
                _RecipientStep(),
                _PurposeStep(),
                _AmountStep(),
                _SuccessStep(), // confirm пропускаем или совмещаем с amount
              ],
            ),
          );
        },
      ),
    );
  }
}

// Шаги (аналогично Send, но с "Request")

class _RecipientStep extends StatelessWidget {
  const _RecipientStep();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RequestMoneyCubit>();

    final recent = [
      {'name': 'Mehed Hasan', 'email': 'hello.youthhasan@gmail.com', 'avatar': null},
      // добавь ещё
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search Recipient Email',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
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
                subtitle: item['email']!,
                onTap: () => cubit.selectRecipient('id${i+1}', item['name']!, item['avatar']),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => context.push(AppRoutes.scanQr), // переиспользуем сканер из Send
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scan to Pay'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0066FF),
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PurposeStep extends StatelessWidget {
  const _PurposeStep();

  @override
  Widget build(BuildContext context) {
    final purposes = ['Personal', 'Business'];

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(24),
          child: Text('Select a Method for Sending Money', style: TextStyle(fontSize: 18)),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: purposes.length,
            itemBuilder: (ctx, i) {
              return PurposeItem(
                title: purposes[i],
                icon: purposes[i] == 'Personal' ? Icons.person : Icons.business,
                isSelected: context.watch<RequestMoneyCubit>().state.purpose == purposes[i],
                onTap: () => context.read<RequestMoneyCubit>().selectPurpose(purposes[i]),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AmountStep extends StatelessWidget {
  const _AmountStep();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RequestMoneyCubit>().state;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          CircleAvatar(radius: 40, child: Text(state.recipientName?[0] ?? '?', style: const TextStyle(fontSize: 40))),
          const SizedBox(height: 16),
          Text(state.recipientName ?? '', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(state.purpose, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 60),
          TextField(
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(hintText: '0', border: InputBorder.none),
            onChanged: (v) => context.read<RequestMoneyCubit>().setAmount(double.tryParse(v) ?? 0),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.amount > 0
                  ? () => context.read<RequestMoneyCubit>().confirmRequest()
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0066FF),
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: Text('Request \$${state.amount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessStep extends StatelessWidget {
  const _SuccessStep();

  @override
  Widget build(BuildContext context) {
    final state = context.read<RequestMoneyCubit>().state;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, size: 100, color: Colors.green),
          const SizedBox(height: 24),
          const Text('Request Sent!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text('You requested \$${state.amount} from ${state.recipientName}'),
          const SizedBox(height: 60),
          ElevatedButton(
            onPressed: () => context.go(AppRoutes.journal),
            child: const Text('Back to Homepage'),
          ),
        ],
      ),
    );
  }
}