import 'package:flutter/material.dart';

class RecipientItem extends StatelessWidget {
  final String name;
  final String subtitle;
  final String? avatarUrl;
  final VoidCallback onTap;

  const RecipientItem({
    super.key,
    required this.name,
    required this.subtitle,
    this.avatarUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 28,
        backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
        child: avatarUrl == null ? Text(name[0].toUpperCase(), style: const TextStyle(fontSize: 24)) : null,
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
      trailing: const Text('- \$500', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
      onTap: onTap,
    );
  }
}