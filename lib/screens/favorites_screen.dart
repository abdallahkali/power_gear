import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/l10n.dart';
import '../providers/catalog_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/nav_provider.dart';
import '../widgets/common.dart';
import '../widgets/product_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ids = context.watch<FavoritesProvider>().ids;
    final items = context.watch<CatalogProvider>().products.where((p) => ids.contains(p.id)).toList();
    return Scaffold(
      appBar: AppBar(title: Text(context.t('favorites'))),
      body: items.isEmpty
          ? EmptyState(
              icon: Icons.favorite_border_rounded,
              title: context.t('favorites_empty'),
              subtitle: context.t('favorites_empty_sub'),
              action: FilledButton(
                  onPressed: () => context.read<NavProvider>().go(1),
                  child: Text(context.t('start_shopping'))))
          : GridView.builder(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, mainAxisExtent: 268),
              itemCount: items.length,
              itemBuilder: (_, i) => ProductCard(items[i], scope: 'fv', index: i),
            ),
    );
  }
}
