import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_theme.dart';

/// Local avatar picker shown from the home header and Edit Profile.
///
/// Self-contained selector backed by 10 bundled, original SVG illustrations
/// (5 male + 5 female). No third-party avatar assets are used.
class AvatarSelectorSheet extends StatefulWidget {
  const AvatarSelectorSheet({super.key, this.selected});

  final String? selected;

  static const List<String> maleAvatars = [
    'male_1',
    'male_2',
    'male_3',
    'male_4',
    'male_5',
  ];
  static const List<String> femaleAvatars = [
    'female_1',
    'female_2',
    'female_3',
    'female_4',
    'female_5',
  ];
  static const List<String> allAvatars = [...maleAvatars, ...femaleAvatars];
  static const String fallbackAvatar = 'male_1';

  static Future<String?> show(BuildContext context, {String? selected}) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AvatarSelectorSheet(selected: selected),
    );
  }

  static bool isValidAvatarId(String id) => allAvatars.contains(id);

  static String assetFor(String id) {
    if (isValidAvatarId(id)) return 'assets/images/avatar_$id.svg';
    // Legacy male/female style values from earlier versions of the app.
    if (id == 'female') return 'assets/images/avatar_female_1.svg';
    return 'assets/images/avatar_$fallbackAvatar.svg';
  }

  @override
  State<AvatarSelectorSheet> createState() => _AvatarSelectorSheetState();
}

class _AvatarSelectorSheetState extends State<AvatarSelectorSheet> {
  late String _pending;

  @override
  void initState() {
    super.initState();
    final selected = widget.selected;
    if (selected != null && AvatarSelectorSheet.isValidAvatarId(selected)) {
      _pending = selected;
    } else if (selected == 'female') {
      _pending = 'female_1';
    } else {
      _pending = AvatarSelectorSheet.fallbackAvatar;
    }
  }

  void _save(BuildContext context) {
    Navigator.of(context).pop(_pending);
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final borderColor =
        isLight ? AppColors.borderLight : AppColors.borderDark;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.s24,
          AppSpacing.s12,
          AppSpacing.s24,
          AppSpacing.s24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: borderColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            const Text(
              'Choose your avatar',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: AppSpacing.s4),
            Text(
              'Pick a look that feels like you',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: AppSpacing.s20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Men',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),
            const SizedBox(height: AppSpacing.s12),
            Wrap(
              spacing: AppSpacing.s12,
              runSpacing: AppSpacing.s12,
              children: [
                for (final id in AvatarSelectorSheet.maleAvatars)
                  _AvatarOption(
                    id: id,
                    isSelected: _pending == id,
                    onTap: () => setState(() => _pending = id),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.s20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Women',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),
            const SizedBox(height: AppSpacing.s12),
            Wrap(
              spacing: AppSpacing.s12,
              runSpacing: AppSpacing.s12,
              children: [
                for (final id in AvatarSelectorSheet.femaleAvatars)
                  _AvatarOption(
                    id: id,
                    isSelected: _pending == id,
                    onTap: () => setState(() => _pending = id),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.s24),
            ElevatedButton(
              key: const Key('save_avatar_button'),
              onPressed: () => _save(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Save',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarOption extends StatelessWidget {
  const _AvatarOption({
    required this.id,
    required this.isSelected,
    required this.onTap,
  });

  final String id;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        child: Container(
          key: Key('avatar_$id'),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected
                ? primary.withValues(alpha: 0.10)
                : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(AppRadius.r16),
            border: Border.all(
              color: isSelected
                  ? primary
                  : (isLight ? AppColors.borderLight : AppColors.borderDark),
              width: isSelected ? 2.5 : 1,
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ClipOval(
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: SvgPicture.asset(
                    AvatarSelectorSheet.assetFor(id),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (isSelected)
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    padding: const EdgeInsets.all(1.5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check_circle, size: 18, color: primary),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
