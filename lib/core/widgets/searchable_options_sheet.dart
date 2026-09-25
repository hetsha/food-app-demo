import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Searchable bottom-sheet selector used for pickers with long option lists
/// (e.g. State / City on the address form).
///
/// Returns the picked option, or null when dismissed.
class SearchableOptionsSheet extends StatefulWidget {
  const SearchableOptionsSheet({
    super.key,
    required this.title,
    required this.options,
    this.selected,
    this.searchHint = 'Search...',
  });

  final String title;
  final List<String> options;
  final String? selected;
  final String searchHint;

  static Future<String?> show(
    BuildContext context, {
    required String title,
    required List<String> options,
    String? selected,
    String searchHint = 'Search...',
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: SearchableOptionsSheet(
          title: title,
          options: options,
          selected: selected,
          searchHint: searchHint,
        ),
      ),
    );
  }

  @override
  State<SearchableOptionsSheet> createState() => _SearchableOptionsSheetState();
}

class _SearchableOptionsSheetState extends State<SearchableOptionsSheet> {
  late final TextEditingController _searchController;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get _visibleOptions {
    final selected = widget.selected?.trim();
    // Keep a currently-selected value visible even when it is not part of
    // the dataset (e.g. a reverse-geocoded city that could not be matched).
    final base = <String>[
      if (selected != null &&
          selected.isNotEmpty &&
          !widget.options.contains(selected))
        selected,
      ...widget.options,
    ];
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return base;
    return base.where((o) => o.toLowerCase().contains(query)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final options = _visibleOptions;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: AppSpacing.s12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.s24,
                AppSpacing.s16,
                AppSpacing.s24,
                AppSpacing.s8,
              ),
              child: Text(
                widget.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s24,
              ).copyWith(bottom: AppSpacing.s8),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: widget.searchHint,
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                        ),
                ),
              ),
            ),
            Flexible(
              child: options.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(AppSpacing.s24),
                      child: Text(
                        'No matches found.',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.s4,
                      ),
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final option = options[index];
                        final isSelected = option == widget.selected;
                        return ListTile(
                          title: Text(
                            option,
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              fontSize: 14,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                            ),
                          ),
                          trailing: isSelected
                              ? Icon(
                                  Icons.check_circle,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 20,
                                )
                              : null,
                          onTap: () => Navigator.of(context).pop(option),
                        );
                      },
                    ),
            ),
            const SizedBox(height: AppSpacing.s8),
          ],
        ),
      ),
    );
  }
}
