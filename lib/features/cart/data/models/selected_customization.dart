import 'package:freezed_annotation/freezed_annotation.dart';

part 'selected_customization.freezed.dart';
part 'selected_customization.g.dart';

@freezed
class SelectedCustomization with _$SelectedCustomization {
  const factory SelectedCustomization({
    @JsonKey(name: 'customization_item_id') required String customizationItemId,
    required String name,
    @JsonKey(name: 'additional_price') @Default(0.0) double additionalPrice,
  }) = _SelectedCustomization;

  factory SelectedCustomization.fromJson(Map<String, dynamic> json) =>
      _$SelectedCustomizationFromJson(json);
}
