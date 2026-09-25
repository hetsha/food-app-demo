import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription.freezed.dart';
part 'subscription.g.dart';

@JsonSerializable()
class SubscriptionPlan {
  final String id;
  final String name;
  final String? description;
  final int durationDays;
  final int mealsCount;
  final dynamic price;
  final dynamic pricePerMeal;
  final String? mealType;
  final bool isActive;

  const SubscriptionPlan({
    required this.id,
    required this.name,
    this.description,
    required this.durationDays,
    required this.mealsCount,
    required this.price,
    this.pricePerMeal,
    this.mealType,
    this.isActive = true,
  });

  double get priceAsDouble {
    if (price is num) return (price as num).toDouble();
    if (price is String) return double.tryParse(price) ?? 0;
    return 0;
  }

  double? get pricePerMealAsDouble {
    if (pricePerMeal == null) return null;
    if (pricePerMeal is num) return (pricePerMeal as num).toDouble();
    if (pricePerMeal is String) return double.tryParse(pricePerMeal);
    return null;
  }

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionPlanFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionPlanToJson(this);
}

@freezed
class UserSubscription with _$UserSubscription {
  const factory UserSubscription({
    required String id,
    required String subscriptionId,
    required DateTime startDate,
    required DateTime endDate,
    @Default(0) int mealsRemaining,
    required String status,
    @Default([]) List<String> skipDates,
    required DateTime createdAt,
    SubscriptionPlan? subscription,
  }) = _UserSubscription;

  factory UserSubscription.fromJson(Map<String, dynamic> json) =>
      _$UserSubscriptionFromJson(json);
}
