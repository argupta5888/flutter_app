import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/location/location_bloc.dart';
import '../utils/app_theme.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        return BlocBuilder<LocationBloc, LocationState>(
          builder: (context, locationState) {
            return BlocBuilder<CartBloc, CartState>(
              builder: (context, cartState) {
                final user = authState is AuthAuthenticated ? authState.user : null;

                return SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        _buildAvatar(user),
                        const SizedBox(height: 24),
                        _buildLocationCard(locationState, cartState),
                        const SizedBox(height: 16),
                        _buildMenuSection(context, user),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildAvatar(user) {
    final initial = user?.initials.isNotEmpty == true ? user!.initials[0] : '?';
    final name = user?.name ?? 'Guest';
    final email = user?.email ?? '';
    final phone = user?.phone ?? '';

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
                  initial,
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
          name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          email,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (phone.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            phone,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textLight,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLocationCard(LocationState loc, CartState cartState) {
    final distanceText = loc.hasLocation ? loc.formattedDistance(19.0760, 72.8777) : '--';
    final etaText = loc.hasLocation
        ? '${loc.estimatedTime(19.0760, 72.8777)} min'
        : '--';
    final isFreeDelivery = cartState.subtotal > 500;

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
            loc.isLoading ? 'Detecting...' : loc.userAddress,
            Icons.person_pin_circle_outlined,
            AppTheme.accent,
          ),
          const SizedBox(height: 10),
          _locationRow(
            'Restaurant',
            'FoodRush Kitchen, Bandra West',
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
                _statItem('Distance', distanceText, Icons.straighten_rounded),
                _verticalDivider(),
                _statItem('Est. Time', etaText, Icons.access_time_rounded),
                _verticalDivider(),
                _statItem(
                  'Delivery',
                  isFreeDelivery ? 'FREE' : '₹40',
                  Icons.delivery_dining_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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

  Widget _buildMenuSection(BuildContext context, user) {
    final email = user?.email ?? '';
    const errorColor = Color(0xFFD32F2F);

    return Column(
      children: [
        _menuItem(Icons.receipt_long_rounded, 'My Orders', 'View order history', () {}),
        _menuItem(Icons.location_on_outlined, 'Saved Addresses', 'Manage delivery addresses', () {}),
        _menuItem(Icons.payment_outlined, 'Payment Methods', 'Cards, UPI & more', () {}),
        _menuItem(Icons.local_offer_outlined, 'Offers & Coupons', 'Save on your next order', () {}),
        _menuItem(Icons.help_outline_rounded, 'Help & Support', 'FAQs and customer service', () {}),
        _menuItem(Icons.info_outline_rounded, 'About FoodRush', 'Version 1.0.0', () {}),
        const SizedBox(height: 8),
        _menuItem(
          Icons.logout_rounded,
          'Sign Out',
          email.isNotEmpty ? 'Logged in as $email' : 'Sign out of your account',
          () => _confirmLogout(context),
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
    const errorColor = Color(0xFFD32F2F);
    final color = isDestructive ? errorColor : AppTheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppTheme.cardBg,
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
                          color: isDestructive ? errorColor : AppTheme.textPrimary,
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
                const Icon(
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

  void _confirmLogout(BuildContext context) {
    const errorColor = Color(0xFFD32F2F);
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
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
            child: const Text('Sign Out',
                style: TextStyle(color: errorColor)),
          ),
        ],
      ),
    );
  }
}
