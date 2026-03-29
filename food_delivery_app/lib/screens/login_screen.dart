import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../utils/app_theme.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController(text: 'demo@foodrush.com');
  final _passwordController = TextEditingController(text: 'password123');
  bool _obscurePassword = true;
  late AnimationController _animController;
  late Animation<double> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _slideAnim = Tween<double>(begin: 60, end: 0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _login() {
    context.read<AuthBloc>().add(AuthLoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomeScreen()));
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header
                Container(
                  width: double.infinity,
                  height: 280,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.primary, AppTheme.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: -40, right: -40,
                        child: Container(
                          width: 160, height: 160,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -30, left: -20,
                        child: Container(
                          width: 120, height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('🍔', style: TextStyle(fontSize: 64)),
                            SizedBox(height: 12),
                            Text('FoodRush',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -1)),
                            Text('Welcome back! 👋',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 16)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Form
                AnimatedBuilder(
                  animation: _slideAnim,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(0, _slideAnim.value),
                    child: child,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),
                        const Text('Sign In',
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary)),
                        const SizedBox(height: 4),
                        const Text('Enter your credentials to continue',
                            style: TextStyle(color: AppTheme.textSecondary)),
                        const SizedBox(height: 32),

                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email Address',
                            prefixIcon: Icon(Icons.email_outlined,
                                color: AppTheme.textSecondary),
                            hintText: 'demo@foodrush.com',
                          ),
                        ),
                        const SizedBox(height: 16),

                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline,
                                color: AppTheme.textSecondary),
                            suffixIcon: IconButton(
                              icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppTheme.textSecondary),
                              onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword),
                            ),
                            hintText: '••••••••',
                          ),
                        ),
                        const SizedBox(height: 12),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text('Forgot Password?',
                                style: TextStyle(color: AppTheme.primary)),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Error message
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            if (state is AuthFailure) {
                              return Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: Colors.red.shade200),
                                ),
                                child: Row(children: [
                                  const Icon(Icons.error_outline,
                                      color: Colors.red, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: Text(state.error,
                                          style: const TextStyle(
                                              color: Colors.red, fontSize: 13))),
                                ]),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),

                        // Login button
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) => ElevatedButton(
                            onPressed: state is AuthLoading ? null : _login,
                            child: state is AuthLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 2))
                                : const Text('Sign In'),
                          ),
                        ),
                        const SizedBox(height: 24),

                        Row(children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            child: Text('or continue with',
                                style: TextStyle(
                                    color: Colors.grey.shade500, fontSize: 13)),
                          ),
                          const Expanded(child: Divider()),
                        ]),
                        const SizedBox(height: 20),

                        Row(children: [
                          Expanded(
                              child: _SocialButton(
                                  icon: '🔵', label: 'Google', onTap: () {})),
                          const SizedBox(width: 12),
                          Expanded(
                              child: _SocialButton(
                                  icon: '🍎', label: 'Apple', onTap: () {})),
                        ]),
                        const SizedBox(height: 24),

                        Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          const Text("Don't have an account? ",
                              style:
                                  TextStyle(color: AppTheme.textSecondary)),
                          TextButton(
                            onPressed: () {},
                            child: const Text('Sign Up',
                                style: TextStyle(
                                    color: AppTheme.primary,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ]),

                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(children: [
                            Text('💡', style: TextStyle(fontSize: 16)),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Demo: demo@foodrush.com / password123',
                                style: TextStyle(
                                    color: AppTheme.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;
  const _SocialButton(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppTheme.divider),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(icon, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 8),
        Text(label,
            style: const TextStyle(
                color: AppTheme.textPrimary, fontWeight: FontWeight.w500)),
      ]),
    );
  }
}
