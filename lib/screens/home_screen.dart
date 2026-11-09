import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/brand.dart';
import '../core/l10n.dart';
import '../core/theme.dart';
import '../models/product.dart';
import '../providers/catalog_provider.dart';
import '../providers/nav_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/common.dart';
import '../widgets/product_card.dart';
import '../widgets/promo_carousel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.watch<CatalogProvider>();
    final s = context.read<SettingsProvider>();
    final nav = context.read<NavProvider>();
    final pal = context.pal;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    void toShop() => nav.go(1);

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: c.load,
        child: ListView(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            child: Row(children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                    gradient: Brand.gradient, borderRadius: BorderRadius.circular(14)),
                child: Icon(Brand.logo, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(context.t('hello'), style: TextStyle(color: pal.muted, fontSize: 12.5)),
                  Text(context.tr(Brand.name),
                      style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
                ]),
              ),
              AppIconButton(icon: Icons.translate_rounded, onTap: s.toggleLang),
              const SizedBox(width: 8),
              AppIconButton(
                  icon: isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  onTap: () => s.setTheme(isDark ? ThemeMode.light : ThemeMode.dark)),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
            child: GestureDetector(
              onTap: toShop,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: pal.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: pal.border)),
                child: Row(children: [
                  Icon(Icons.search_rounded, color: pal.muted),
                  const SizedBox(width: 10),
                  Text(context.t('search_hint'), style: TextStyle(color: pal.muted)),
                  const Spacer(),
                  const Icon(Icons.tune_rounded, color: Brand.primary),
                ]),
              ),
            ),
          ),
          PromoCarousel(onTap: toShop),
          if (c.loading && c.products.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                for (var i = 0; i < 2; i++)
                  Container(
                      height: 200,
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                          color: pal.card, borderRadius: BorderRadius.circular(22))),
              ]),
            )
          else if (c.error != null && c.products.isEmpty)
            SizedBox(
              height: 360,
              child: EmptyState(
                icon: Icons.wifi_off_rounded,
                title: context.t('error_load'),
                action: FilledButton(onPressed: c.load, child: Text(context.t('retry'))),
              ),
            )
          else ...[
            SectionHeader(context.t('categories')),
            SizedBox(
              height: 96,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: c.categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (_, i) {
                  final cat = c.categories[i];
                  return GestureDetector(
                    onTap: () {
                      c.resetAll();
                      c.setCategory(cat.id);
                      toShop();
                    },
                    child: SizedBox(
                      width: 72,
                      child: Column(children: [
                        Container(
                          width: 62,
                          height: 62,
                          decoration: BoxDecoration(
                              color: pal.tint,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: pal.border)),
                          child: Icon(cat.icon, color: Brand.primary, size: 28),
                        ),
                        const SizedBox(height: 6),
                        Text(context.tr(cat.name),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                      ]),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(children: [
                _Perk(Icons.local_shipping_rounded, context.t('free_shipping')),
                const SizedBox(width: 10),
                _Perk(Icons.published_with_changes_rounded, context.t('easy_returns')),
                const SizedBox(width: 10),
                _Perk(Icons.verified_user_rounded, context.t('secure_pay')),
              ]),
            ),
            SectionHeader(context.t('best_sellers'), onSeeAll: toShop),
            _HList(c.bestSellers, 'bs'),
            SectionHeader(context.t('on_sale'), onSeeAll: () {
              c.resetAll();
              c.setOnlyOffers(true);
              toShop();
            }),
            _HList(c.deals, 'dl'),
            SectionHeader(context.t('new_arrivals'), onSeeAll: toShop),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    mainAxisExtent: 268),
                itemCount: c.newArrivals.length.clamp(0, 6),
                itemBuilder: (_, i) => ProductCard(c.newArrivals[i], scope: 'na', index: i),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ]),
      ),
    );
  }
}

class _HList extends StatelessWidget {
  const _HList(this.items, this.scope);
  final List<Product> items;
  final String scope;
  @override
  Widget build(BuildContext context) => SizedBox(
        height: 268,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (_, i) =>
              SizedBox(width: 176, child: ProductCard(items[i], scope: scope, index: i)),
        ),
      );
}

class _Perk extends StatelessWidget {
  const _Perk(this.icon, this.label);
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          decoration: BoxDecoration(
              color: context.pal.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.pal.border)),
          child: Column(children: [
            Icon(icon, color: Brand.primary, size: 22),
            const SizedBox(height: 6),
            Text(label,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
          ]),
        ),
      );
}
