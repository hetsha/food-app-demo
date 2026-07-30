import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool isAuthenticated;
  final bool isVerifyingOtp;
  final String? phoneNumber;
  final String? userName;
  final String? errorMessage;
  final bool isLoading;

  AuthState({
    this.isAuthenticated = false,
    this.isVerifyingOtp = false,
    this.phoneNumber,
    this.userName,
    this.errorMessage,
    this.isLoading = false,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isVerifyingOtp,
    String? phoneNumber,
    String? userName,
    String? errorMessage,
    bool? isLoading,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isVerifyingOtp: isVerifyingOtp ?? this.isVerifyingOtp,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userName: userName ?? this.userName,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  void sendOtp(String phone) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    await Future.delayed(const Duration(seconds: 1)); // simulated api delay
    state = state.copyWith(
      isLoading: false,
      isVerifyingOtp: true,
      phoneNumber: phone,
    );
  }

  bool verifyOtp(String code) {
    state = state.copyWith(isLoading: true, errorMessage: null);
    if (code == '123456') {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        isVerifyingOtp: false,
        userName: 'Rohan Patel', // Mock authenticated user name
      );
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Invalid OTP code. Use 123456.',
      );
      return false;
    }
  }

  void loginWithGoogle() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(
      isLoading: false,
      isAuthenticated: true,
      userName: 'Rohan Patel (Google)',
    );
  }

  void loginWithApple() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(
      isLoading: false,
      isAuthenticated: true,
      userName: 'Rohan Patel (Apple)',
    );
  }

  void loginAsGuest() {
    state = state.copyWith(
      isAuthenticated: true,
      userName: 'Guest Foodie',
    );
  }

  void logout() {
    state = AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
