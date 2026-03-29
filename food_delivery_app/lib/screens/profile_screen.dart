import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_providers.dart';
import '../app_theme.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, LocationProvider>(
      builder: (_, auth, loc, __) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 8),
              _buildAvatar(auth),
              const SizedBox(height: 24),
              _buildLocationCard(loc),
              const SizedBox(height: 16),
              _buildMenuSection(context, auth, loc),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(AuthProvider auth) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primary, AppTheme.accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  auth.userName.isNotEmpty
                      ? auth.userName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.success,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 10),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          auth.userName.isEmpty ? 'User' : auth.userName,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          auth.userEmail,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (auth.userPhone.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            auth.userPhone,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textLight,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLocationCard(LocationProvider loc) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1614), Color(0xFF2D2A26)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.location_on_rounded, color: AppTheme.primary, size: 18),
              SizedBox(width: 6),
              Text(
                'Delivery Details',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _locationRow(
            'Your Location',
            loc.isLoadingLocation ? 'Detecting...' : loc.currentAddress,
            Icons.person_pin_circle_outlined,
            AppTheme.accent,
          ),
          const SizedBox(height: 10),
          _locationRow(
            'Restaurant',
            'FoodieHub Kitchen, Bandra West',
            Icons.storefront_outlined,
            AppTheme.primary,
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statItem('Distance', loc.formattedDistance, Icons.straighten_rounded),
                _verticalDivider(),
                _statItem('Est. Time', loc.estimatedTime, Icons.access_time_rounded),
                _verticalDivider(),
                _statItem(
                  'Delivery',
                  loc.distanceKm != null && loc.totalAmount > 500 ? 'FREE' : '₹40',
                  Icons.delivery_dining_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Property needed to access totalAmount from LocationProvider is not available
  // so using a Consumer workaround
  double get totalAmount => 0;

  Widget _locationRow(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 11,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _statItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white60, size: 18),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 10),
        ),
      ],
    );
  }

  Widget _verticalDivider() {
    return Container(
      height: 36,
      width: 1,
      color: Colors.white.withOpacity(0.15),
    );
  }

  Widget _buildMenuSection(
      BuildContext context, AuthProvider auth, LocationProvider loc) {
    return Column(
      children: [
        _menuItem(Icons.receipt_long_rounded, 'My Orders', 'View order history', () {}),
        _menuItem(Icons.location_on_outlined, 'Saved Addresses', 'Manage delivery addresses', () {}),
        _menuItem(Icons.payment_outlined, 'Payment Methods', 'Cards, UPI & more', () {}),
        _menuItem(Icons.local_offer_outlined, 'Offers & Coupons', 'Save on your next order', () {}),
        _menuItem(Icons.help_outline_rounded, 'Help & Support', 'FAQs and customer service', () {}),
        _menuItem(Icons.info_outline_rounded, 'About FoodieHub', 'Version 1.0.0', () {}),
        const SizedBox(height: 8),
        _menuItem(
          Icons.logout_rounded,
          'Sign Out',
          'Logged in as ${auth.userEmail}',
          () => _confirmLogout(context, auth),
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _menuItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    final color = isDestructive ? AppTheme.error : AppTheme.primary;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isDestructive
                              ? AppTheme.error
                              : AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.textLight,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Sign Out?',
            style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              auth.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
            child: const Text('Sign Out',
                style: TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );
  }
}
