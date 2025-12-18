import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final double amount;
  final String iconUrl;

  const TransactionItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    this.iconUrl = '',
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: iconUrl.isNotEmpty ? NetworkImage(iconUrl) : null,
        child: iconUrl.isEmpty ? const Icon(Icons.shopping_cart) : null,
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
      trailing: Text(
        amount < 0
            ? '-\$${amount.abs().toStringAsFixed(2)}'
            : '+\$${amount.toStringAsFixed(2)}',
        style: TextStyle(
          color: amount < 0 ? Colors.red : Colors.green,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
