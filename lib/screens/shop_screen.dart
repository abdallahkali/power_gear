import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/brand.dart';
import '../core/format.dart';
import '../core/l10n.dart';
import '../core/theme.dart';
import '../providers/catalog_provider.dart';
import '../widgets/common.dart';
import '../widgets/product_card.dart';

String sortLabel(BuildContext c, SortBy s) => c.t(switch (s) {
      SortBy.popular => 'sort_popular',
      SortBy.newest => 'sort_newest',
      SortBy.priceLow => 'sort_price_low',
      SortBy.priceHigh => 'sort_price_high',
      SortBy.rating => 'sort_rating',
    });

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});
  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _openFilters(BuildContext context) {
    final c = context.read<CatalogProvider>();
    var range = RangeValues(c.priceMin.toDouble(), (c.priceMax ?? c.maxPrice).toDouble());
    var offers = c.onlyOffers;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: const EdgeInsets.fromLTRB(22, 14, 22, 22),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(
                child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: ctx.pal.border, borderRadius: BorderRadius.circular(4)))),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(
                  child: Text(ctx.t('filters'),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900))),
              TextButton(
                  onPressed: () => setS(() {
                        range = RangeValues(0, c.maxPrice.toDouble());
                        offers = false;
                      }),
                  child: Text(ctx.t('reset'))),
            ]),
            const SizedBox(height: 10),
            Text(ctx.t('price_range'), style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text('${money(ctx, range.start.round())}  —  ${money(ctx, range.end.round())}',
                style: const TextStyle(color: Brand.primary, fontWeight: FontWeight.w800)),
            RangeSlider(
              min: 0,
              max: c.maxPrice.toDouble(),
              divisions: c.maxPrice ~/ 100,
              values: range,
              onChanged: (v) => setS(() => range = v),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: offers,
              onChanged: (v) => setS(() => offers = v),
              title: Text(ctx.t('only_offers'),
                  style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 10),
            GradientButton(
              label: ctx.t('apply_filters'),
              onPressed: () {
                final max = range.end.round() >= c.maxPrice ? null : range.end.round();
                c.setPrice(range.start.round(), max);
                c.setOnlyOffers(offers);
                Navigator.pop(ctx);
              },
            ),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<CatalogProvider>();
    final pal = context.pal;
    final results = c.results;
    if (_ctrl.text != c.query) _ctrl.text = c.query;

    return SafeArea(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
          child: Row(children: [
            Expanded(
              child: TextField(
                controller: _ctrl,
                onChanged: c.setQuery,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: context.t('search_hint'),
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: c.query.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close_rounded), onPressed: () => c.setQuery('')),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Badge(
              isLabelVisible: c.priceMin > 0 || c.priceMax != null || c.onlyOffers,
              smallSize: 10,
              child: GestureDetector(
                onTap: () => _openFilters(context),
                child: Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                      gradient: Brand.gradient, borderRadius: BorderRadius.circular(16)),
                  child: const Icon(Icons.tune_rounded, color: Colors.white),
                ),
              ),
            ),
          ]),
        ),
        SizedBox(
          height: 42,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 8),
                child: ChoiceChip(
                    label: Text(context.t('all')),
                    selected: c.categoryId == null,
                    onSelected: (_) => c.setCategory(null)),
              ),
              for (final cat in c.categories)
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8),
                  child: ChoiceChip(
                      avatar: Icon(cat.icon, size: 17, color: Brand.primary),
                      label: Text(context.tr(cat.name)),
                      selected: c.categoryId == cat.id,
                      onSelected: (_) => c.setCategory(c.categoryId == cat.id ? null : cat.id)),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
          child: Row(children: [
            Text('${results.length} ${context.t('results')}',
                style: const TextStyle(fontWeight: FontWeight.w800)),
            const Spacer(),
            PopupMenuButton<SortBy>(
              onSelected: c.setSort,
              itemBuilder: (_) => [
                for (final s in SortBy.values)
                  PopupMenuItem(value: s, child: Text(sortLabel(context, s)))
              ],
              child: Row(children: [
                Icon(Icons.swap_vert_rounded, size: 20, color: pal.muted),
                const SizedBox(width: 4),
                Text(sortLabel(context, c.sort), style: TextStyle(color: pal.muted)),
              ]),
            ),
          ]),
        ),
        Expanded(
          child: c.loading && c.products.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : results.isEmpty
                  ? EmptyState(
                      icon: Icons.search_off_rounded,
                      title: context.t('no_results'),
                      subtitle: context.t('no_results_sub'),
                      action: OutlinedButton(
                          onPressed: c.resetAll, child: Text(context.t('reset'))),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          mainAxisExtent: 268),
                      itemCount: results.length,
                      itemBuilder: (_, i) =>
                          ProductCard(results[i], scope: 'sh', index: i),
                    ),
        ),
      ]),
    );
  }
}
