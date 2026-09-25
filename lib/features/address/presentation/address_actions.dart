import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/app_theme.dart';
import '../data/models/address.dart';
import '../data/services/device_location_service.dart';
import 'address_provider.dart';

IconData addressLabelIcon(String label) {
  switch (label.toLowerCase()) {
    case 'home':
      return Icons.home_rounded;
    case 'office':
    case 'work':
      return Icons.business_rounded;
    case 'parents home':
      return Icons.family_restroom_rounded;
    default:
      return Icons.location_on_rounded;
  }
}

String formatAddress(Address address) {
  final parts = [
    address.addressLine1,
    if (address.addressLine2 != null && address.addressLine2!.isNotEmpty)
      address.addressLine2!,
    if (address.city != null && address.city!.isNotEmpty) address.city!,
    if (address.state != null && address.state!.isNotEmpty) address.state!,
    if (address.postalCode.isNotEmpty) address.postalCode,
  ];
  return parts.join(', ');
}

Future<void> handleLocationException(
  BuildContext context,
  LocationException e,
) async {
  if (!context.mounted) return;
  if (e.issue == LocationIssue.serviceDisabled) {
    final openSettings = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Turn on location'),
        content: Text(e.message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Enable Location'),
          ),
        ],
      ),
    );
    if (openSettings == true) {
      await DeviceLocationService.openLocationSettings();
    }
    return;
  }
  if (e.issue == LocationIssue.permissionDeniedForever) {
    final openSettings = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Location permission blocked'),
        content: Text(e.message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
    if (openSettings == true) {
      await DeviceLocationService.openAppSettings();
    }
    return;
  }
  if (context.mounted) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

Future<void> confirmDeleteAddress(
  BuildContext context,
  WidgetRef ref,
  String id, {
  void Function()? onDeleted,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Delete Address'),
      content: const Text('Are you sure you want to delete this address?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) return;
  await ref.read(addressNotifierProvider.notifier).deleteAddress(id);
  onDeleted?.call();
}

Future<void> showAddressActionMenu(
  BuildContext context,
  WidgetRef ref,
  Address address, {
  required bool isSelected,
}) async {
  final action = await showModalBottomSheet<String>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) => SafeArea(
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
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Address actions',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: const Text('Edit'),
            onTap: () => Navigator.pop(sheetContext, 'edit'),
          ),
          if (!address.isDefault)
            ListTile(
              leading: const Icon(Icons.push_pin_outlined),
              title: const Text('Pin as default'),
              onTap: () => Navigator.pop(sheetContext, 'pin'),
            ),
          ListTile(
            leading: const Icon(Icons.share_outlined),
            title: const Text('Share'),
            onTap: () => Navigator.pop(sheetContext, 'share'),
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline_rounded, color: Colors.red),
            title: const Text('Delete', style: TextStyle(color: Colors.red)),
            onTap: () => Navigator.pop(sheetContext, 'delete'),
          ),
          const SizedBox(height: AppSpacing.s8),
        ],
      ),
    ),
  );

  if (action == null || !context.mounted) return;
  switch (action) {
    case 'edit':
      context.push('/addresses/edit/${address.id}');
    case 'pin':
      final ok =
          await ref.read(addressNotifierProvider.notifier).setDefaultAddress(address.id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ok ? 'Pinned ${address.label} as default' : 'Could not pin address'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    case 'share':
      final mapsUrl = 'https://www.google.com/maps?q=${address.latitude},${address.longitude}';
      final text = [
        address.label,
        formatAddress(address),
        if (address.phone.isNotEmpty) 'Phone: ${address.phone}',
        mapsUrl,
      ].join('\n');
      await SharePlus.instance.share(ShareParams(text: text));
    case 'delete':
      await confirmDeleteAddress(context, ref, address.id);
    default:
      break;
  }
}
