import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/custom_button.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/checkout_provider.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'aarav.mehta@example.com');
  final _passwordController = TextEditingController(text: 'password123');
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(AuthProvider auth) async {
    final success = await auth.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (success && mounted) {
      final userId = auth.currentUser?.id ?? 1;
      // Refresh providers for logged in user
      Provider.of<CartProvider>(context, listen: false).loadCart(userId);
      Provider.of<WishlistProvider>(context, listen: false).loadWishlist(userId);
      Provider.of<CheckoutProvider>(context, listen: false).loadSavedAddresses(userId);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text('SOFALIVING', style: AppTextStyles.brandHeader),
                ),
                const SizedBox(height: 6),
                const Center(
                  child: Text(
                    'BESPOKE ATELIER LIVING',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.0,
                      color: AppColors.accent,
                    ),
                  ),
                ),
                const SizedBox(height: 36),

                const Text('Sign In', style: AppTextStyles.h1),
                const SizedBox(height: 6),
                const Text(
                  'Access your customized sofa configurations, wishlist, and bespoke atelier orders.',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 24),

                // Quick Demo Login Button Pill
            
Container(
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: AppColors.cardBg,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: AppColors.border),
  ),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const Icon(
        Icons.auto_awesome,
        color: AppColors.accent,
        size: 20,
      ),
      const SizedBox(width: 10),
      const Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Demo Credentials',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
            Text(
              'aarav.mehta@example.com / password123',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
              softWrap: true,
            ),
          ],
        ),
      ),
      const SizedBox(width: 8),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () async {
          _emailController.text = 'aarav.mehta@example.com';
          _passwordController.text = 'password123';
          await _handleLogin(auth);
        },
        child: const Text(
          'Auto Fill',
          style: TextStyle(color: Colors.white, fontSize: 11),
        ),
      ),
    ],
  ),
),



                const SizedBox(height: 24),

                // Email Field
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.email_outlined, size: 18),
                  ),
                ),
                const SizedBox(height: 16),

                // Password Field
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline, size: 18),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, size: 18),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                ),

                if (auth.errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    auth.errorMessage!,
                    style: const TextStyle(color: AppColors.error, fontSize: 12),
                  ),
                ],
                const SizedBox(height: 24),

                // Sign In Button
                CustomButton(
                  text: 'Sign In to Atelier',
                  isLoading: auth.isLoading,
                  onPressed: () => _handleLogin(auth),
                ),
                const SizedBox(height: 20),

                // Register Link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? ", style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const SignupScreen()),
                          );
                        },
                        child: const Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
