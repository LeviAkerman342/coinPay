import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/core/router/domain/app_routes.dart';

class JournalPage extends StatelessWidget {
  const JournalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const TextField(
          decoration: InputDecoration(
            hintText: 'Search "Payments"',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Color(0xFFF0F0F0),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Баланс секция
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0066FF), Color(0xFF0088FF)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 60),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'US Dollar',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      Icon(Icons.keyboard_arrow_down, color: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '\$20,000',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Available Balance',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.push(AppRoutes.sendMoney);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Money'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF0066FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Быстрые действия
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _quickAction(
                    icon: Icons.send,
                    label: 'Send',
                    onTap: () => context.push(AppRoutes.spendingDetail),
                  ),
                  _quickAction(
                    icon: Icons.download,
                    label: 'Request',
                    onTap: () => context.push(AppRoutes.requestMoney),
                  ),
                  _quickAction(
                    icon: Icons.account_balance,
                    label: 'Bank',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            // Transaction Categories
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Transaction',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'See All >',
                      style: TextStyle(color: Color(0xFF0066FF)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            _transactionCategory(
              icon: Icons.shopping_cart_outlined,
              color: Colors.purple,
              title: 'Spending',
              amount: '-\$500',
              amountColor: Colors.red,
            ),
            _transactionCategory(
              icon: Icons.trending_up,
              color: Colors.green,
              title: 'Income',
              amount: '\$3000',
              amountColor: Colors.green,
            ),
            _transactionCategory(
              icon: Icons.receipt_long,
              color: Colors.orange,
              title: 'Bills',
              amount: '-\$800',
              amountColor: Colors.red,
            ),
            _transactionCategory(
              icon: Icons.savings,
              color: Colors.blue,
              title: 'Savings',
              amount: '\$1000',
              amountColor: Colors.green,
            ),

            const SizedBox(height: 100), // отступ для bottom nav
          ],
        ),
      ),
    );
  }

  Widget _quickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: const Color(0xFF0066FF).withOpacity(0.1),
          child: Icon(icon, color: const Color(0xFF0066FF), size: 28),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _transactionCategory({
    required IconData icon,
    required Color color,
    required String title,
    required String amount,
    required Color amountColor,
  }) {
    return ListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color, size: 28),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            amount,
            style: TextStyle(
              color: amountColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
      onTap: () {},
    );
  }
}
