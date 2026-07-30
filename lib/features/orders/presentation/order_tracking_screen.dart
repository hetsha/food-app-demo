import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;
  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  int _currentStep = 2; // 0: Confirmed, 1: Cooking, 2: Out for Delivery, 3: Delivered
  int _minutesRemaining = 18;
  Timer? _timer;

  final List<TrackingStep> _steps = [
    TrackingStep(title: 'Order Confirmed', subtitle: 'Kitchen accepted your order', time: '11:30 AM'),
    TrackingStep(title: 'Preparing Meal', subtitle: 'Chef Rohan is preparing your hot meal', time: '11:45 AM'),
    TrackingStep(title: 'Out for Delivery', subtitle: 'Rider Mahesh is on his way', time: '12:05 PM'),
    TrackingStep(title: 'Delivered', subtitle: 'Secure OTP delivery', time: 'Expected 12:20 PM'),
  ];

  @override
  void initState() {
    super.initState();
    _startSimulatedETA();
  }

  void _startSimulatedETA() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_minutesRemaining > 1) {
        setState(() {
          _minutesRemaining--;
        });
      } else {
        setState(() {
          _currentStep = 3;
          _minutesRemaining = 0;
        });
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Track Order ${widget.orderId}'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: Column(
        children: [
          // Simulated Map Box
          Expanded(
            child: Stack(
              children: [
                _buildSimulatedMap(context),
                _buildRiderInfoOverlay(context),
              ],
            ),
          ),
          _buildStatusTimelineSheet(context),
        ],
      ),
    );
  }

  Widget _buildSimulatedMap(BuildContext context) {
    return Container(
      color: Theme.of(context).brightness == Brightness.light ? const Color(0xFFE3F2FD) : const Color(0xFF1E293B),
      child: Center(
        child: Stack(
          children: [
            // Custom vector layout drawing a delivery path route
            Positioned.fill(
              child: CustomPaint(
                painter: MapRoutePainter(
                  color: Theme.of(context).colorScheme.primary,
                  isDark: Theme.of(context).brightness == Brightness.dark,
                ),
              ),
            ),
            
            // Rider Icon floating on path
            Positioned(
              left: 150,
              top: 180,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.premiumShadow(color: Theme.of(context).colorScheme.primary.withOpacity(0.4)),
                ),
                child: const Icon(Icons.directions_bike_rounded, color: Colors.white, size: 24),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .move(begin: Offset.zero, end: const Offset(0, -10), duration: 1.seconds, curve: Curves.easeInOut),
            ),
            
            // Delivery Destination marker
            Positioned(
              left: 260,
              top: 80,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: AppShadows.premiumShadow(),
                    ),
                    child: const Text('Your Home', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.black)),
                  ),
                  const Icon(Icons.location_on_rounded, color: Colors.red, size: 36),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiderInfoOverlay(BuildContext context) {
    return Positioned(
      top: AppSpacing.s16,
      left: AppSpacing.s16,
      right: AppSpacing.s16,
      child: Card(
        color: Theme.of(context).cardColor.withOpacity(0.92),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.r16)),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s16),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=150'),
              ),
              const SizedBox(width: AppSpacing.s16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Mahesh Kumar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 2),
                        Text('4.9 Rider', style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.call_rounded, color: AppColors.primary),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.primary),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusTimelineSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.r24)),
        boxShadow: AppShadows.premiumShadow(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Estimated Arrival Time', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 2),
                  Text(
                    _minutesRemaining > 0 ? '$_minutesRemaining Mins' : 'Delivered!',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                ),
                child: const Text('OTP: 5892', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 13)),
              ),
            ],
          ),
          const Divider(height: 32),
          
          // Stepper Timeline
          ...List.generate(_steps.length, (index) {
            final step = _steps[index];
            final isDone = index <= _currentStep;
            final isCurrent = index == _currentStep;
            
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: isDone ? Theme.of(context).colorScheme.primary : Colors.grey[300],
                        shape: BoxShape.circle,
                        border: isCurrent
                            ? Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.3), width: 6)
                            : null,
                      ),
                      child: isDone && !isCurrent
                          ? const Icon(Icons.check, size: 12, color: Colors.white)
                          : null,
                    ),
                    if (index < _steps.length - 1)
                      Container(
                        width: 2,
                        height: 36,
                        color: index < _currentStep ? Theme.of(context).colorScheme.primary : Colors.grey[300],
                      ),
                  ],
                ),
                const SizedBox(width: AppSpacing.s16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.title,
                        style: TextStyle(
                          fontWeight: isCurrent ? FontWeight.w800 : (isDone ? FontWeight.bold : FontWeight.normal),
                          fontSize: 14,
                          color: isCurrent ? Theme.of(context).colorScheme.primary : null,
                        ),
                      ),
                      Text(step.subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                Text(step.time, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class TrackingStep {
  final String title;
  final String subtitle;
  final String time;

  TrackingStep({required this.title, required this.subtitle, required this.time});
}

class MapRoutePainter extends CustomPainter {
  final Color color;
  final bool isDark;
  MapRoutePainter({required this.color, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()
      ..color = isDark ? Colors.white24 : Colors.black12
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw background grid pattern
    for (double i = 0; i < size.width; i += 30) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), dotPaint);
    }
    for (double i = 0; i < size.height; i += 30) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), dotPaint);
    }

    final path = Path()
      ..moveTo(50, 220)
      ..quadraticBezierTo(100, 240, 150, 180)
      ..quadraticBezierTo(200, 120, 260, 110);

    canvas.drawPath(path, paint);

    // Draw active progress path
    final activePaint = Paint()
      ..color = color
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final activePath = Path()
      ..moveTo(50, 220)
      ..quadraticBezierTo(100, 240, 150, 180);

    canvas.drawPath(activePath, activePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
