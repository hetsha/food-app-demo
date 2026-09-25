import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';
import '../data/models/menu_food.dart';
import '../data/models/menu_category.dart';
import 'menu_providers.dart';
import 'search_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load the complete menu for the initial empty query.
      final state = ref.read(searchProvider);
      if (state.results.isEmpty && !state.isLoading) {
        ref.read(searchProvider.notifier).submitQuery(state.query);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    ref.read(searchProvider.notifier).clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          focusNode: _focusNode,
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Search meals, categories...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey.shade400),
          ),
          onChanged: (v) =>
              ref.read(searchProvider.notifier).updateQuery(v),
          onSubmitted: (v) =>
              ref.read(searchProvider.notifier).submitQuery(v),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
        actions: [
          FilterChip(
            label: const Text('Veg Only',
                style: TextStyle(fontSize: 12)),
            selected: searchState.isVegOnly,
            onSelected: (_) =>
                ref.read(searchProvider.notifier).toggleVegOnly(),
            selectedColor: AppColors.success,
            labelStyle: TextStyle(
              color:
                  searchState.isVegOnly ? Colors.white : null,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _buildBody(searchState, categoriesAsync),
    );
  }

  Widget _buildBody(
      SearchState searchState, AsyncValue<List<MenuCategory>> categoriesAsync) {
    if (searchState.query.isEmpty) {
      if (searchState.error != null && searchState.results.isEmpty) {
        return _buildErrorState(searchState.error!);
      }
      if (searchState.isLoading && searchState.results.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      return _buildSuggestions(categoriesAsync, searchState);
    }

    if (searchState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (searchState.error != null) {
      return _buildErrorState(searchState.error!);
    }
    if (searchState.results.isEmpty) {
      return _buildEmpty();
    }
    return _buildResults(searchState.results);
  }

  Widget _buildSuggestions(
      AsyncValue<List<MenuCategory>> categoriesAsync, SearchState searchState) {
    final foods = searchState.results;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.s16),
      children: [
        const Text('Popular Searches',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: AppSpacing.s12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['Gujarati Thali', 'Paneer', 'Dal', 'Biryani', 'Roti']
              .map((term) {
            return ActionChip(
              label: Text(term),
              onPressed: () {
                _controller.text = term;
                ref
                    .read(searchProvider.notifier)
                    .submitQuery(term);
              },
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.s24),
        const Text('Browse Categories',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: AppSpacing.s12),
        categoriesAsync.when(
          data: (categories) => Column(
            children: categories
                .where((c) => c.id != 'all')
                .map((cat) {
              return ListTile(
                leading: cat.icon.isNotEmpty
                    ? Text(cat.icon, style: const TextStyle(fontSize: 24))
                    : const Icon(Icons.category, size: 24),
                title: Text(cat.name),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () {
                  _controller.text = cat.name;
                  ref
                      .read(searchProvider.notifier)
                      .submitQuery(cat.name);
                },
              );
            }).toList(),
          ),
          loading: () =>
              const Center(child: CircularProgressIndicator()),
          error: (_, __) => const SizedBox.shrink(),
        ),
        const SizedBox(height: AppSpacing.s24),
        const Text('All Meals',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: AppSpacing.s12),
        if (foods.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.s24),
            child: Center(
              child: Text('No foods found',
                  style: TextStyle(color: Colors.grey, fontSize: 15)),
            ),
          )
        else
          ...foods.map(_buildFoodCard),
      ],
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline,
              size: 80, color: Colors.redAccent),
          const SizedBox(height: AppSpacing.s16),
          Text(error,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: AppSpacing.s8),
          const Text('Try a different search term',
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded,
              size: 80, color: Colors.grey.shade300),
          const SizedBox(height: AppSpacing.s16),
          const Text('No foods found',
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: AppSpacing.s8),
          const Text('Try a different search term',
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildResults(List<MenuFood> results) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.s16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final food = results[index];
        return _buildFoodCard(food);
      },
    );
  }

  Widget _buildFoodCard(MenuFood food) {
    final imageUrl =
        food.imageUrls.isNotEmpty ? food.imageUrls.first : '';

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.s12),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.r16),
        onTap: () => context.push('/meal/${food.id}'),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(AppRadius.r12),
                child: imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Container(color: Colors.grey[200]),
                        errorWidget: (context, url, error) =>
                            Container(color: Colors.grey[200]),
                      )
                    : Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[200],
                        child: const Icon(Icons.fastfood,
                            color: Colors.grey),
                      ),
              ),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (food.isVeg)
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColors.success,
                                  width: 1.5),
                              borderRadius:
                                  BorderRadius.circular(3),
                            ),
                            child: const Icon(Icons.circle,
                                size: 8, color: AppColors.success),
                          ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(food.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '₹${food.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary),
                        ),
                        if (food.originalPrice != null &&
                            food.originalPrice! > food.price) ...[
                          const SizedBox(width: 6),
                          Text(
                            '₹${food.originalPrice!.toStringAsFixed(0)}',
                            style: const TextStyle(
                              decoration:
                                  TextDecoration.lineThrough,
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (food.rating != null) ...[
                          const Icon(Icons.star_rounded,
                              size: 14, color: Colors.amber),
                          const SizedBox(width: 2),
                          Text(food.rating!.toStringAsFixed(1),
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
