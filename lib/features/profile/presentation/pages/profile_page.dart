import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black54),
            onPressed: () {
              // TODO: редактирование профиля
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Аватар + данные
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                'https://i.pravatar.cc/300?u=mehedi', // заглушка, заменишь на реальную
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Mehedi Hasan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'hello.youthmind@gmail.com',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              '+8801995857406',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),

            const SizedBox(height: 40),

            // Список настроек
            _buildProfileTile(
              icon: Icons.dark_mode,
              title: 'Dark Mode',
              trailing: Switch(
                value: false, // потом из Theme или Hive
                onChanged: (val) {
                  // TODO: переключение темы
                },
                activeColor: const Color(0xFF0066FF),
              ),
            ),
            _buildProfileTile(
              icon: Icons.person_outline,
              title: 'Personal Info',
              onTap: () => context.push('/personal-info'),
            ),
            _buildProfileTile(
              icon: Icons.account_balance,
              title: 'Bank & Cards',
              onTap: () => context.push('/bank-cards'),
            ),
            _buildProfileTile(
              icon: Icons.receipt_long_outlined,
              title: 'Transaction',
              onTap: () => context.push('/transactions'),
            ),
            _buildProfileTile(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () => context.push('/settings'),
            ),
            _buildProfileTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Data Privacy',
              onTap: () => context.push('/data-privacy'),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: _getIconColor(icon).withOpacity(0.1),
        child: Icon(icon, color: _getIconColor(icon), size: 26),
      ),
      title: Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
      trailing: trailing ??
          const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  Color _getIconColor(IconData icon) {
    switch (icon) {
      case Icons.dark_mode:
        return Colors.grey;
      case Icons.person_outline:
        return Colors.blue;
      case Icons.account_balance:
        return Colors.orange;
      case Icons.receipt_long_outlined:
        return Colors.purple;
      case Icons.settings_outlined:
        return Colors.cyan;
      case Icons.privacy_tip_outlined:
        return Colors.green;
      default:
        return const Color(0xFF0066FF);
    }
  }
}