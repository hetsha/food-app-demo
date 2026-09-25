import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../data/models/country.dart';
import 'auth_provider.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  Country _selectedCountry = Country.defaultCountry;
  Timer? _cooldownTimer;

  @override
  void initState() {
    super.initState();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final state = ref.read(authProvider);
      if (state.resendCooldownSeconds > 0) {
        ref.read(authProvider.notifier).tickResendCooldown();
      }
    });
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  /// Normalizes raw input (autofill / paste / typing) to national digits only.
  /// 1. Strip all non-digit characters.
  /// 2. If the result starts with the selected country's dial-code digits
  ///    AND there are extra digits beyond the code, strip the code prefix.
  /// 3. Truncate to nationalNumberLength.
  String _normalizePhoneInput(String raw) {
    final digitsOnly = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.isEmpty) return '';

    final dialCodeDigits = _selectedCountry.dialCode.replaceAll(RegExp(r'[^0-9]'), '');

    String national = digitsOnly;
    if (national.startsWith(dialCodeDigits) &&
        national.length > dialCodeDigits.length) {
      national = national.substring(dialCodeDigits.length);
    }

    // Cap at the expected national-number length (e.g. 10 for India).
    if (national.length > _selectedCountry.nationalNumberLength) {
      national = national.substring(0, _selectedCountry.nationalNumberLength);
    }

    return national;
  }

  bool get _isPhoneValid {
    final phone = _phoneController.text.trim();
    return phone.length == _selectedCountry.nationalNumberLength &&
        RegExp(r'^\d+$').hasMatch(phone);
  }

  String get _fullPhoneNumber {
    final national = _phoneController.text.trim();
    return '${_selectedCountry.dialCode}$national';
  }

  void _onAction(AuthState authState, AuthNotifier notifier) async {
    if (!authState.isVerifyingOtp) {
      if (_isPhoneValid) {
        await notifier.sendOtp(_fullPhoneNumber);
        if (mounted) _otpController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please enter a valid ${_selectedCountry.nationalNumberLength}-digit phone number.',
            ),
          ),
        );
      }
    } else {
      if (_otpController.text.trim().length == 6) {
        final success = await notifier.verifyOtp(_otpController.text.trim());
        if (success && mounted) {
          context.go('/home');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter the 6-digit OTP.')),
        );
      }
    }
  }

  Future<void> _resendOtp(AuthState authState, AuthNotifier notifier) async {
    if (!authState.canResend) return;
    _otpController.clear();
    await notifier.resendOtp();
    if (!mounted) return;
    final after = ref.read(authProvider);
    if (after.successMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(after.successMessage!),
          backgroundColor: Colors.green.shade700,
        ),
      );
    } else if (after.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(after.errorMessage!)),
      );
    }
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.r20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: AppSpacing.s12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              Text(
                'Select Country',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.s8),
              ...Country.supportedCountries.map((country) {
                final isSelected = country == _selectedCountry;
                return ListTile(
                  leading: Text(country.flag, style: const TextStyle(fontSize: 28)),
                  title: Text(
                    country.name,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  trailing: Text(
                    country.dialCode,
                    style: TextStyle(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : AppColors.textSecondaryLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  selected: isSelected,
                  selectedTileColor:
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                  onTap: () {
                    setState(() => _selectedCountry = country);
                    Navigator.pop(ctx);
                    _phoneController.selection = TextSelection.fromPosition(
                      TextPosition(offset: _phoneController.text.length),
                    );
                  },
                );
              }),
              const SizedBox(height: AppSpacing.s16),
            ],
          ),
        );
      },
    );
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
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
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
                      'Parabdi',
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
                            ? 'A 6-digit code has been sent to $_fullPhoneNumber'
                            : 'Enter your phone number to receive a secure OTP verification.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: AppSpacing.s24),
                      
                      if (!authState.isVerifyingOtp) ...[
                        // Country selector + Phone input row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Country selector
                            GestureDetector(
                              onTap: _showCountryPicker,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.s12,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.outline,
                                  ),
                                  borderRadius: BorderRadius.circular(AppRadius.r12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _selectedCountry.flag,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(width: AppSpacing.s4),
                                    Text(
                                      _selectedCountry.dialCode,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: Theme.of(context).textTheme.bodyLarge?.color,
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.s4),
                                    Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 18,
                                      color: Theme.of(context).textTheme.bodySmall?.color,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.s12),
                            // Phone number input — no prefixIcon, no maxLength on widget
                            Expanded(
                              child: TextField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                autofillHints: const [AutofillHints.telephoneNumber],
                                // NO maxLength here — we handle limit in onChanged
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (value) {
                                  final normalized = _normalizePhoneInput(value);
                                  if (normalized != value) {
                                    _phoneController.text = normalized;
                                    _phoneController.selection = TextSelection.fromPosition(
                                      TextPosition(offset: normalized.length),
                                    );
                                  }
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                  hintText: 'Phone Number',
                                  prefixIcon: const Icon(Icons.phone_iphone_rounded, size: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(AppRadius.r12),
                                    borderSide: BorderSide(
                                      color: Theme.of(context).colorScheme.outline,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                                  counterText: '',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.s8),
                        // Validation hint
                        if (_phoneController.text.isNotEmpty && !_isPhoneValid)
                          Padding(
                            padding: const EdgeInsets.only(left: AppSpacing.s4),
                            child: Text(
                              'Enter ${_selectedCountry.nationalNumberLength} digits',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ] else ...[
                        // Dev OTP display
                        if (authState.devOtp != null) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline, color: Colors.green.shade700, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Dev Mode — OTP: ${authState.devOtp}',
                                    style: TextStyle(
                                      color: Colors.green.shade800,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        // OTP input
                        TextField(
                          controller: _otpController,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 22, letterSpacing: 8, fontWeight: FontWeight.bold),
                          onChanged: (_) {
                            if (ref.read(authProvider).errorMessage != null) {
                              ref.read(authProvider.notifier).clearError();
                            }
                          },
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
                      if (authState.successMessage != null &&
                          authState.errorMessage == null) ...[
                        const SizedBox(height: AppSpacing.s12),
                        Text(
                          authState.successMessage!,
                          style: TextStyle(color: Colors.green.shade700, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],

                      const SizedBox(height: AppSpacing.s24),

                      ElevatedButton(
                        onPressed: authState.isLoading || authState.isResending
                            ? null
                            : (!authState.isVerifyingOtp && !_isPhoneValid)
                                ? null
                                : () => _onAction(authState, authNotifier),
                        child: authState.isLoading || authState.isResending
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
                          onPressed: authState.canResend
                              ? () => _resendOtp(authState, authNotifier)
                              : null,
                          child: Text(
                            authState.resendCooldownSeconds > 0
                                ? 'Resend OTP in ${authState.resendCooldownSeconds}s'
                                : 'Resend OTP',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: authState.canResend
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            authNotifier.resetOtpState();
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
                  Expanded(child: Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.5))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
                    child: Text('or continue with', style: Theme.of(context).textTheme.bodySmall),
                  ),
                  Expanded(child: Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.5))),
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
                      onPressed: authState.isLoading ? null : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Google Sign-In coming soon.')),
                        );
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
                      onPressed: authState.isLoading ? null : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Apple Sign-In coming soon.')),
                        );
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
