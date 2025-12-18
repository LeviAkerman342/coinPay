import 'package:flutter/material.dart';

class PurposeItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const PurposeItem({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: isSelected ? const Color(0xFF0066FF) : Colors.grey[200],
        child: Icon(icon, color: isSelected ? Colors.white : Colors.black54, size: 28),
      ),
      title: Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: Color(0xFF0066FF))
          : null,
      onTap: onTap,
    );
  }
}