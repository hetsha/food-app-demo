import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_storage.dart';
import '../../authentication/presentation/auth_provider.dart';
import 'avatar_selector_sheet.dart';

/// Default avatar shown when the user has not picked one yet.
const String kDefaultAvatarId = AvatarSelectorSheet.fallbackAvatar;

/// Single source of truth for the current user's avatar.
///
/// The selection is persisted per logged-in user id in [LocalStorage] so it
/// survives app restarts and re-logins, and is shared by the Home header,
/// Profile card, and Edit Profile screen (instant sync, no restart needed).
class AvatarNotifier extends StateNotifier<String> {
  AvatarNotifier() : super(kDefaultAvatarId);

  /// Loads the avatar stored for [userId].
  ///
  /// Falls back to the legacy male/female preference (earlier app versions),
  /// then to [kDefaultAvatarId].
  void loadForUser(String? userId) {
    final uid = userId ?? 'guest';
    final stored = LocalStorage.getAvatarForUser(uid);
    if (stored != null && AvatarSelectorSheet.isValidAvatarId(stored)) {
      state = stored;
      return;
    }
    final legacy = LocalStorage.avatarStyle;
    if (legacy == 'female') {
      state = 'female_1';
      return;
    }
    state = kDefaultAvatarId;
  }

  /// Selects [avatarId] for the current user and persists it.
  Future<void> setAvatar(String avatarId) async {
    if (!AvatarSelectorSheet.isValidAvatarId(avatarId)) return;
    state = avatarId;
    final uid = LocalStorage.getUserId() ?? 'guest';
    await LocalStorage.setAvatarForUser(uid, avatarId);
    await LocalStorage.setAvatarStyle(
      avatarId.startsWith('female') ? 'female' : 'male',
    );
  }
}

final avatarProvider = StateNotifierProvider<AvatarNotifier, String>((ref) {
  final notifier = AvatarNotifier();
  ref.listen(authProvider, (previous, next) {
    if (previous?.user?.id != next.user?.id) {
      notifier.loadForUser(next.user?.id);
    }
  });
  notifier.loadForUser(ref.read(authProvider).user?.id);
  return notifier;
});
