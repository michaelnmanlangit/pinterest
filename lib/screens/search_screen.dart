import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import '../providers/pinterest_provider.dart';
import '../widgets/pin_card.dart';
import '../utils/responsive_helper.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<PinterestProvider>(
        builder: (context, provider, child) {
          final pins = provider.pins;
          final categories = provider.getCategories();

          return CustomScrollView(
            slivers: [
              // Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      decoration: const InputDecoration(
                        hintText: 'Search for ideas',
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                      onChanged: (query) {
                        provider.searchPins(query);
                      },
                      onSubmitted: (query) {
                        provider.searchPins(query);
                      },
                    ),
                  ),
                ),
              ),

              // Search Results or Categories
              if (provider.searchQuery.isEmpty) ...[
                // Categories when not searching
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Popular categories',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: ResponsiveHelper.isMobile(context) ? 2 : 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.5,
                          ),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return GestureDetector(
                              onTap: () {
                                provider.filterByCategory(category);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: _getCategoryColors(category),
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Text(
                                    category,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                // Search Results Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Results for "${provider.searchQuery}"',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            _searchController.clear();
                            provider.clearFilters();
                          },
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // Search Results Grid
                if (pins.isNotEmpty)
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.getHorizontalPadding(context)),
                    sliver: SliverMasonryGrid.count(
                      crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(context),
                      mainAxisSpacing: ResponsiveHelper.getGridSpacing(context),
                      crossAxisSpacing: ResponsiveHelper.getGridSpacing(context),
                      childCount: pins.length,
                      itemBuilder: (context, index) {
                        final pin = pins[index];
                        return PinCard(pin: pin);
                      },
                    ),
                  )
                else
                  const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No results found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),
    );
  }

  List<Color> _getCategoryColors(String category) {
    switch (category.toLowerCase()) {
      case 'home decor':
        return [Colors.purple[300]!, Colors.purple[600]!];
      case 'food':
        return [Colors.orange[300]!, Colors.orange[600]!];
      case 'fashion':
        return [Colors.pink[300]!, Colors.pink[600]!];
      case 'travel':
        return [Colors.blue[300]!, Colors.blue[600]!];
      case 'art':
        return [Colors.teal[300]!, Colors.teal[600]!];
      case 'fitness':
        return [Colors.green[300]!, Colors.green[600]!];
      case 'garden':
        return [Colors.lightGreen[300]!, Colors.lightGreen[600]!];
      case 'diy':
        return [Colors.amber[300]!, Colors.amber[600]!];
      default:
        return [Colors.grey[300]!, Colors.grey[600]!];
    }
  }
}
