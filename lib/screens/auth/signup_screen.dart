import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/custom_button.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/checkout_provider.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup(AuthProvider auth) async {
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields.')),
      );
      return;
    }

    final success = await auth.register(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      fullName: _nameController.text.trim(),
      phone: _phoneController.text.trim().isNotEmpty ? _phoneController.text.trim() : '+91 9820123456',
    );

    if (success && mounted) {
      final userId = auth.currentUser?.id ?? 1;
      // Fresh user account starts with fresh cart and wishlist
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
                const SizedBox(height: 32),

                const Text('Create Account', style: AppTextStyles.h1),
                const SizedBox(height: 6),
                const Text(
                  'Join SOFALIVING to save bespoke modular layouts and manage White Glove delivery schedules.',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 24),

                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person_outline, size: 18),
                  ),
                ),
                const SizedBox(height: 14),

                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.email_outlined, size: 18),
                  ),
                ),
                const SizedBox(height: 14),

                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number (Optional)',
                    prefixIcon: Icon(Icons.phone_outlined, size: 18),
                    hintText: '+91 9820123456',
                  ),
                ),
                const SizedBox(height: 14),

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

                CustomButton(
                  text: 'Create Atelier Account',
                  isLoading: auth.isLoading,
                  onPressed: () => _handleSignup(auth),
                ),
                const SizedBox(height: 20),

                

Center(
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.center,
    spacing: 4,
    children: [
      const Text(
        'Already have an account?',
        style: TextStyle(
          fontSize: 13,
          color: AppColors.textSecondary,
        ),
      ),
      GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const LoginScreen(),
            ),
          );
        },
        child: const Text(
          'Sign In',
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
