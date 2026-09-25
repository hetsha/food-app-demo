import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../core/network/api_client.dart';
import '../data/repositories/payment_repository.dart';

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepository(ApiClient.instance);
});

enum PaymentStatus {
  idle,
  creatingOrder,
  waitingForPayment,
  verifying,
  success,
  failed,
}

class PaymentState {
  final PaymentStatus status;
  final String? error;
  final String? orderId;
  final bool isCancelled;

  const PaymentState({
    this.status = PaymentStatus.idle,
    this.error,
    this.orderId,
    this.isCancelled = false,
  });

  PaymentState copyWith({
    PaymentStatus? status,
    String? error,
    String? orderId,
    bool? isCancelled,
  }) {
    return PaymentState(
      status: status ?? this.status,
      error: error,
      orderId: orderId ?? this.orderId,
      isCancelled: isCancelled ?? this.isCancelled,
    );
  }

  bool get isProcessing =>
      status == PaymentStatus.creatingOrder ||
      status == PaymentStatus.waitingForPayment ||
      status == PaymentStatus.verifying;
}

class PaymentNotifier extends StateNotifier<PaymentState> {
  final PaymentRepository _repo;
  Razorpay? _razorpay;
  Completer<bool>? _paymentCompleter;

  PaymentNotifier(this._repo) : super(const PaymentState()) {
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay?.clear();
    _razorpay = null;
    super.dispose();
  }

  Future<bool> initiatePayment({
    required String orderId,
    required double amount,
    required String userPhone,
    required String userName,
  }) async {
    _paymentCompleter = Completer<bool>();

    state = state.copyWith(
      status: PaymentStatus.creatingOrder,
      error: null,
      orderId: orderId,
      isCancelled: false,
    );

    try {
      final paymentOrder = await _repo.createOrder(orderId, amount);

      state = state.copyWith(status: PaymentStatus.waitingForPayment);

      final options = {
        'key': paymentOrder.keyId,
        'amount': paymentOrder.amount,
        'currency': paymentOrder.currency,
        'name': 'Parabdi',
        'order_id': paymentOrder.orderId,
        'description': 'Food Order #$orderId',
        'prefill': {
          'contact': userPhone,
          'email': '',
        },
        'theme': {
          'color': '#0E7A46',
        },
        'modal': {
          'confirm_close': true,
        },
      };

      _razorpay!.open(options);

      return _paymentCompleter!.future;
    } catch (e) {
      state = state.copyWith(
        status: PaymentStatus.failed,
        error: e.toString(),
      );
      return false;
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (state.orderId == null) return;

    state = state.copyWith(status: PaymentStatus.verifying);

    try {
      final verified = await _repo.verifyPayment(
        orderId: state.orderId!,
        razorpayOrderId: response.orderId ?? '',
        razorpayPaymentId: response.paymentId ?? '',
        razorpaySignature: response.signature ?? '',
      );

      if (verified) {
        state = state.copyWith(status: PaymentStatus.success);
        _paymentCompleter?.complete(true);
      } else {
        state = state.copyWith(
          status: PaymentStatus.failed,
          error: 'Payment verification failed. Please contact support.',
        );
        _paymentCompleter?.complete(false);
      }
    } catch (e) {
      state = state.copyWith(
        status: PaymentStatus.failed,
        error: 'Payment verification failed. Please contact support.',
      );
      _paymentCompleter?.complete(false);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    final code = response.code ?? 0;
    final message = response.message ?? '';

    if (code == 2) {
      state = state.copyWith(
        status: PaymentStatus.idle,
        isCancelled: true,
      );
    } else {
      state = state.copyWith(
        status: PaymentStatus.failed,
        error: _getErrorMessage(code, message),
      );
    }
    _paymentCompleter?.complete(false);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet if needed
  }

  String _getErrorMessage(int code, String message) {
    switch (code) {
      case 2:
        return 'Payment cancelled by user.';
      case 1:
        return 'Payment failed. Please try again.';
      default:
        return message.isNotEmpty ? message : 'Payment failed. Please try again.';
    }
  }

  void reset() {
    _razorpay?.clear();
    state = const PaymentState();
  }
}

final paymentProvider =
    StateNotifierProvider<PaymentNotifier, PaymentState>((ref) {
  final repo = ref.read(paymentRepositoryProvider);
  return PaymentNotifier(repo);
});
