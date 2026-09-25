import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import 'chef_provider.dart';

class ChefLoginScreen extends ConsumerStatefulWidget {
  const ChefLoginScreen({super.key});

  @override
  ConsumerState<ChefLoginScreen> createState() => _ChefLoginScreenState();
}

class _ChefLoginScreenState extends ConsumerState<ChefLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final List<String> _pinDigits = ['', '', '', '', '', ''];
  final List<FocusNode> _pinFocusNodes = List.generate(6, (_) => FocusNode());
  int _pinLength = 6;
  bool _isPinEntry = false;

  @override
  void dispose() {
    _phoneController.dispose();
    for (final node in _pinFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onPinDigitChanged(int index, String value) {
    if (value.length == 1) {
      _pinDigits[index] = value;
      if (index < _pinLength - 1) {
        _pinFocusNodes[index + 1].requestFocus();
      } else {
        _submitPin();
      }
    } else if (value.isEmpty && index > 0) {
      _pinDigits[index] = '';
      _pinFocusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  void _onKeyPress(String key) {
    if (key == 'back') {
      for (int i = _pinLength - 1; i >= 0; i--) {
        if (_pinDigits[i].isNotEmpty) {
          _pinDigits[i] = '';
          _pinFocusNodes[i].requestFocus();
          setState(() {});
          return;
        }
      }
    } else {
      for (int i = 0; i < _pinLength; i++) {
        if (_pinDigits[i].isEmpty) {
          _pinDigits[i] = key;
          _pinFocusNodes[i].requestFocus();
          if (i == _pinLength - 1) {
            _submitPin();
          }
          setState(() {});
          return;
        }
      }
    }
  }

  void _submitPhone() {
    final phone = _phoneController.text.trim();
    if (phone.length >= 10) {
      setState(() => _isPinEntry = true);
      _pinFocusNodes[0].requestFocus();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 10-digit phone number.')),
      );
    }
  }

  void _submitPin() async {
    final pin = _pinDigits.join();
    if (pin.length != _pinLength) return;

    final notifier = ref.read(chefAuthProvider.notifier);
    final success = await notifier.login(_phoneController.text.trim(), pin);
    if (success && mounted) {
      context.go('/chef/dashboard');
    }
  }

  void _resetPin() {
    _pinDigits.fillRange(0, _pinLength, '');
    _pinFocusNodes[0].requestFocus();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(chefAuthProvider);

    if (authState.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/chef/dashboard');
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

              // Branding
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.s16),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.motorcycle_rounded,
                        color: AppColors.accent,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    Text(
                      'Chef Panel',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: AppColors.accent,
                            letterSpacing: 1,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.s4),
                    Text(
                      _isPinEntry
                          ? 'Enter your 6-digit PIN'
                          : 'Sign in to manage orders',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.1),

              const SizedBox(height: AppSpacing.s48),

              // Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.s24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!_isPinEntry) ...[
                        Text(
                          'Phone Number',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: AppSpacing.s8),
                        Text(
                          'Enter the phone number linked to your chef account.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: AppSpacing.s24),
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
                        const SizedBox(height: AppSpacing.s24),
                        ElevatedButton(
                          onPressed: _submitPhone,
                          child: const Text('Continue'),
                        ),
                      ] else ...[
                        // PIN Display
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(_pinLength, (i) {
                              final isFilled = _pinDigits[i].isNotEmpty;
                              return Container(
                                width: 44,
                                height: 52,
                                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isFilled
                                        ? AppColors.accent
                                        : Theme.of(context).colorScheme.outline,
                                    width: isFilled ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(AppRadius.r12),
                                  color: isFilled
                                      ? AppColors.accent.withValues(alpha: 0.05)
                                      : Colors.transparent,
                                ),
                                child: Text(
                                  isFilled ? '●' : '',
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),

                        if (authState.errorMessage != null) ...[
                          const SizedBox(height: AppSpacing.s12),
                          Text(
                            authState.errorMessage!,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 13),
                          ),
                        ],

                        const SizedBox(height: AppSpacing.s8),

                        TextButton(
                          onPressed: _resetPin,
                          child: const Text('Clear PIN'),
                        ),

                        const SizedBox(height: AppSpacing.s16),

                        // Custom number pad
                        _buildNumberPad(),

                        const SizedBox(height: AppSpacing.s16),

                        ElevatedButton(
                          onPressed: authState.isLoading
                              ? null
                              : () {
                                  final pin = _pinDigits.join();
                                  if (pin.length == _pinLength) _submitPin();
                                },
                          child: authState.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(Colors.white),
                                  ),
                                )
                              : const Text('Sign In'),
                        ),
                      ],
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 100.ms, duration: 300.ms).slideY(begin: 0.05),

              const SizedBox(height: AppSpacing.s32),

              if (_isPinEntry)
                Center(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _isPinEntry = false;
                        _resetPin();
                      });
                    },
                    child: const Text('Change Phone Number'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberPad() {
    return Column(
      children: [
        for (int row = 0; row < 3; row++)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.s8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int col = 0; col < 3; col++)
                  _buildKey('${row * 3 + col + 1}'),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.s8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 72, height: 52),
              _buildKey('0'),
              _buildKey('back', isBackspace: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKey(String label, {bool isBackspace = false}) {
    return GestureDetector(
      onTap: () => _onKeyPress(label),
      child: Container(
        width: 72,
        height: 52,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.r12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        alignment: Alignment.center,
        child: isBackspace
            ? const Icon(Icons.backspace_outlined, size: 22)
            : Text(
                label,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}
