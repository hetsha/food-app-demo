import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import 'auth_provider.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _onAction(AuthState authState, AuthNotifier notifier) {
    if (!authState.isVerifyingOtp) {
      if (_phoneController.text.trim().length >= 10) {
        notifier.sendOtp(_phoneController.text.trim());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid phone number.')),
        );
      }
    } else {
      if (_otpController.text.trim().length == 6) {
        final success = notifier.verifyOtp(_otpController.text.trim());
        if (success) {
          context.go('/home');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter the 6-digit OTP.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);

    // Auto navigate if already authenticated
    if (authState.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/home');
      });
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.s48),
              
              // Top luxury branding header
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.s16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.restaurant_menu_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    Text(
                      'Ambo',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).colorScheme.primary,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      'Sign in to order gourmet meals',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppSpacing.s48),
              
              // Main credentials card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.s24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        authState.isVerifyingOtp ? 'Enter Verification Code' : 'Verify Mobile Number',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s8),
                      Text(
                        authState.isVerifyingOtp
                            ? 'A 6-digit code has been sent to +91 ${_phoneController.text}'
                            : 'Enter your phone number to receive a secure OTP verification.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: AppSpacing.s24),
                      
                      if (!authState.isVerifyingOtp) ...[
                        // Phone input
                        TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          decoration: InputDecoration(
                            hintText: 'Phone Number',
                            prefixIcon: const Icon(Icons.phone_iphone_rounded, size: 20),
                            prefixText: '+91 ',
                            prefixStyle: TextStyle(
                              color: Theme.of(context).textTheme.bodyLarge?.color,
                              fontWeight: FontWeight.w600,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppRadius.r12),
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 16),
                            counterText: '',
                          ),
                        ),
                      ] else ...[
                        // OTP input
                        TextField(
                          controller: _otpController,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 22, letterSpacing: 8, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            hintText: '123456',
                            hintStyle: const TextStyle(fontSize: 22, letterSpacing: 8, color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(AppRadius.r12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 16),
                            counterText: '',
                          ),
                        ),
                      ],
                      
                      if (authState.errorMessage != null) ...[
                        const SizedBox(height: AppSpacing.s12),
                        Text(
                          authState.errorMessage!,
                          style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 13),
                        ),
                      ],
                      
                      const SizedBox(height: AppSpacing.s24),
                      
                      ElevatedButton(
                        onPressed: authState.isLoading ? null : () => _onAction(authState, authNotifier),
                        child: authState.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
                              )
                            : Text(authState.isVerifyingOtp ? 'Verify & Login' : 'Send OTP'),
                      ),
                      
                      if (authState.isVerifyingOtp) ...[
                        const SizedBox(height: AppSpacing.s12),
                        TextButton(
                          onPressed: () {
                            authNotifier.logout();
                            _otpController.clear();
                          },
                          child: const Text('Change Phone Number'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: AppSpacing.s32),
              
              // Divider
              Row(
                children: [
                  Expanded(child: Divider(color: Theme.of(context).dividerColor.withOpacity(0.5))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
                    child: Text('or continue with', style: Theme.of(context).textTheme.bodySmall),
                  ),
                  Expanded(child: Divider(color: Theme.of(context).dividerColor.withOpacity(0.5))),
                ],
              ),
              
              const SizedBox(height: AppSpacing.s24),
              
              // Social login row
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r12)),
                      ),
                      onPressed: () {
                        authNotifier.loginWithGoogle();
                        context.go('/home');
                      },
                      icon: const Icon(Icons.g_mobiledata_rounded, size: 28, color: Colors.red),
                      label: const Text('Google', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s16),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r12)),
                      ),
                      onPressed: () {
                        authNotifier.loginWithApple();
                        context.go('/home');
                      },
                      icon: const Icon(Icons.apple_rounded, size: 24),
                      label: const Text('Apple', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppSpacing.s32),
              
              // Guest checkout option
              Center(
                child: TextButton(
                  onPressed: () {
                    authNotifier.loginAsGuest();
                    context.go('/home');
                  },
                  child: Text(
                    'Explore as Guest',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s24),
            ],
          ),
        ),
      ),
    );
  }
}
