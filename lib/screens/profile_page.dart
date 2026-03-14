import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            _buildProfileHeader(),
            const SizedBox(height: 24),
            
            // Menu Items
            _buildMenuSection(),
            const SizedBox(height: 24),
            
            // Account Section
            _buildAccountSection(),
            const SizedBox(height: 24),
            
            // Support Section
            _buildSupportSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 50,
              color: Colors.blue[700],
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Demo User',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'demo@example.com',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 20,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Premium Member',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection() {
    return Card(
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.shopping_bag_outlined,
            title: 'My Orders',
            subtitle: 'Track, return, or exchange orders',
            onTap: () {},
          ),
          const Divider(height: 1),
          _buildMenuItem(
            icon: Icons.favorite_outline,
            title: 'Wishlist',
            subtitle: 'Your saved items',
            onTap: () {},
          ),
          const Divider(height: 1),
          _buildMenuItem(
            icon: Icons.location_on_outlined,
            title: 'Manage Addresses',
            subtitle: 'Add, edit delivery addresses',
            onTap: () {},
          ),
          const Divider(height: 1),
          _buildMenuItem(
            icon: Icons.payment_outlined,
            title: 'Payment Methods',
            subtitle: 'Manage cards and wallets',
            onTap: () {},
          ),
        ],\n      ),\n    );\n  }\n\n  Widget _buildAccountSection() {\n    return Card(\n      child: Column(\n        children: [\n          Padding(\n            padding: const EdgeInsets.all(16),\n            child: Row(\n              children: [\n                const Icon(Icons.account_circle, color: Colors.blue),\n                const SizedBox(width: 12),\n                const Text(\n                  'Account Settings',\n                  style: TextStyle(\n                    fontSize: 16,\n                    fontWeight: FontWeight.bold,\n                  ),\n                ),\n              ],\n            ),\n          ),\n          const Divider(height: 1),\n          _buildMenuItem(\n            icon: Icons.person_outline,\n            title: 'Edit Profile',\n            subtitle: 'Update your personal information',\n            onTap: () {},\n          ),\n          const Divider(height: 1),\n          _buildMenuItem(\n            icon: Icons.security_outlined,\n            title: 'Privacy & Security',\n            subtitle: 'Password, privacy settings',\n            onTap: () {},\n          ),\n          const Divider(height: 1),\n          _buildMenuItem(\n            icon: Icons.notifications_outlined,\n            title: 'Notifications',\n            subtitle: 'Manage notification preferences',\n            onTap: () {},\n          ),\n        ],\n      ),\n    );\n  }\n\n  Widget _buildSupportSection() {\n    return Card(\n      child: Column(\n        children: [\n          Padding(\n            padding: const EdgeInsets.all(16),\n            child: Row(\n              children: [\n                const Icon(Icons.help_outline, color: Colors.blue),\n                const SizedBox(width: 12),\n                const Text(\n                  'Support & Legal',\n                  style: TextStyle(\n                    fontSize: 16,\n                    fontWeight: FontWeight.bold,\n                  ),\n                ),\n              ],\n            ),\n          ),\n          const Divider(height: 1),\n          _buildMenuItem(\n            icon: Icons.help_center_outlined,\n            title: 'Help Center',\n            subtitle: 'FAQs and support',\n            onTap: () {},\n          ),\n          const Divider(height: 1),\n          _buildMenuItem(\n            icon: Icons.chat_outlined,\n            title: 'Contact Us',\n            subtitle: 'Get in touch with our team',\n            onTap: () {},\n          ),\n          const Divider(height: 1),\n          _buildMenuItem(\n            icon: Icons.description_outlined,\n            title: 'Terms & Conditions',\n            subtitle: 'Read our terms of service',\n            onTap: () {},\n          ),\n          const Divider(height: 1),\n          _buildMenuItem(\n            icon: Icons.privacy_tip_outlined,\n            title: 'Privacy Policy',\n            subtitle: 'How we protect your data',\n            onTap: () {},\n          ),\n          const Divider(height: 1),\n          _buildMenuItem(\n            icon: Icons.info_outline,\n            title: 'About',\n            subtitle: 'App version and info',\n            onTap: () => _showAboutDialog(),\n          ),\n          const Divider(height: 1),\n          _buildMenuItem(\n            icon: Icons.logout,\n            title: 'Logout',\n            subtitle: 'Sign out of your account',\n            onTap: () => _showLogoutDialog(),\n            titleColor: Colors.red,\n          ),\n        ],\n      ),\n    );\n  }\n\n  Widget _buildMenuItem({\n    required IconData icon,\n    required String title,\n    required String subtitle,\n    required VoidCallback onTap,\n    Color? titleColor,\n  }) {\n    return ListTile(\n      leading: Icon(icon, color: titleColor ?? Colors.grey[700]),\n      title: Text(\n        title,\n        style: TextStyle(\n          fontWeight: FontWeight.w500,\n          color: titleColor,\n        ),\n      ),\n      subtitle: Text(\n        subtitle,\n        style: TextStyle(\n          fontSize: 12,\n          color: Colors.grey[600],\n        ),\n      ),\n      trailing: const Icon(Icons.arrow_forward_ios, size: 16),\n      onTap: onTap,\n    );\n  }\n\n  void _showAboutDialog() {\n    // This would typically show app info\n  }\n\n  void _showLogoutDialog() {\n    // This would typically show logout confirmation\n  }\n}