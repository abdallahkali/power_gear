import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/brand.dart';
import '../core/format.dart';
import '../core/l10n.dart';
import '../core/theme.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/catalog_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/nav_provider.dart';
import '../widgets/common.dart';
import '../widgets/product_card.dart';
import '../widgets/product_image.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.product, required this.heroTag});
  final Product product;
  final String heroTag;
  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late int _variant =
      widget.product.variantType == VariantType.shade && widget.product.variants.isNotEmpty ? 0 : -1;
  int _qty = 1;

  bool _validate() {
    if (widget.product.variantType == VariantType.size && _variant < 0) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(context.t('select_size'))));
      return false;
    }
    return true;
  }

  void _add() {
    if (!_validate()) return;
    addToCartWithFeedback(context, widget.product, variantIndex: _variant, qty: _qty);
  }

  void _buyNow() {
    if (!_validate()) return;
    context.read<CartProvider>().add(widget.product, variantIndex: _variant, qty: _qty);
    final nav = context.read<NavProvider>();
    Navigator.of(context).popUntil((r) => r.isFirst);
    nav.go(3);
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final pal = context.pal;
    final fav = context.select<FavoritesProvider, bool>((f) => f.isFav(p.id));
    final related = context.watch<CatalogProvider>().related(p);
    final lowStock = p.stock <= 5;

    Widget circle(Widget child) => Padding(
          padding: const EdgeInsets.all(6),
          child: Container(
              decoration: BoxDecoration(color: pal.card, shape: BoxShape.circle), child: child),
        );

    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 340,
          backgroundColor: pal.tint,
          leading: circle(const BackButton()),
          actions: [
            circle(IconButton(
              onPressed: () => context.read<FavoritesProvider>().toggle(p.id),
              icon: Icon(fav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: fav ? Brand.primary : pal.muted),
            )),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: pal.tint,
              padding: const EdgeInsets.fromLTRB(40, 70, 40, 24),
              child: Hero(tag: widget.heroTag, child: ProductImage(p)),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            transform: Matrix4.translationValues(0, -22, 0),
            decoration: BoxDecoration(
                color: pal.bg,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28))),
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: Brand.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                      context.tr(Provider.of<CatalogProvider>(context, listen: false)
                          .categories
                          .firstWhere((c) => c.id == p.categoryId,
                              orElse: () => ProductCategory(
                                  p.categoryId, Brand.name, Icons.category_rounded))
                          .name),
                      style: const TextStyle(
                          color: Brand.primary, fontSize: 12, fontWeight: FontWeight.w800)),
                ),
                const Spacer(),
                Icon(Icons.circle, size: 9, color: lowStock ? Colors.orange : const Color(0xFF16A34A)),
                const SizedBox(width: 6),
                Text(context.t(lowStock ? 'low_stock' : 'in_stock'),
                    style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: lowStock ? Colors.orange : const Color(0xFF16A34A))),
              ]),
              const SizedBox(height: 14),
              Text(context.tr(p.name),
                  style: const TextStyle(fontSize: 24, height: 1.25, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              RatingStars(p.rating, reviews: p.reviews, size: 14),
              const SizedBox(height: 14),
              Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(money(context, p.price),
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.w900, color: Brand.primary)),
                if (p.onSale) ...[
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(money(context, p.oldPrice!),
                        style: TextStyle(
                            color: pal.muted, decoration: TextDecoration.lineThrough)),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    margin: const EdgeInsets.only(bottom: 3),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                        color: Brand.primary, borderRadius: BorderRadius.circular(8)),
                    child: Text('-${p.discountPercent}%',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800)),
                  ),
                ],
              ]),
              if (p.hasVariants) ...[
                const SizedBox(height: 22),
                Text(context.t(p.variantType == VariantType.size ? 'size' : 'shade'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                if (p.variantType == VariantType.size)
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    for (var i = 0; i < p.variants.length; i++)
                      ChoiceChip(
                          label: Text(context.tr(p.variants[i].label)),
                          selected: _variant == i,
                          onSelected: (_) => setState(() => _variant = i)),
                  ])
                else ...[
                  Wrap(spacing: 12, runSpacing: 12, children: [
                    for (var i = 0; i < p.variants.length; i++)
                      GestureDetector(
                        onTap: () => setState(() => _variant = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 44,
                          height: 44,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: _variant == i ? Brand.primary : Colors.transparent,
                                  width: 2.5)),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: p.variants[i].color,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: pal.border))),
                        ),
                      ),
                  ]),
                  if (_variant >= 0) ...[
                    const SizedBox(height: 8),
                    Text(context.tr(p.variants[_variant].label),
                        style: TextStyle(color: pal.muted, fontWeight: FontWeight.w600)),
                  ],
                ],
              ],
              const SizedBox(height: 22),
              Row(children: [
                Text(context.t('quantity'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                const Spacer(),
                QtyStepper(qty: _qty, max: p.stock, onChanged: (v) => setState(() => _qty = v)),
              ]),
              const SizedBox(height: 22),
              Text(context.t('description'),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(context.tr(p.description),
                  style: TextStyle(height: 1.8, color: pal.muted)),
              if (p.features.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(context.t('features'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                for (final f in p.features)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(children: [
                      const Icon(Icons.check_circle_rounded, size: 19, color: Brand.primary),
                      const SizedBox(width: 10),
                      Expanded(child: Text(context.tr(f))),
                    ]),
                  ),
              ],
              const SizedBox(height: 14),
              Row(children: [
                _Info(Icons.local_shipping_rounded, context.t('delivery')),
                const SizedBox(width: 10),
                _Info(Icons.published_with_changes_rounded, context.t('returns14')),
              ]),
              if (related.isNotEmpty) ...[
                const SizedBox(height: 10),
                Transform.translate(
                    offset: const Offset(0, 0),
                    child: Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 12),
                        child: Text(context.t('related'),
                            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900)))),
                SizedBox(
                  height: 268,
                  child: ListView.separated(
                    clipBehavior: Clip.none,
                    scrollDirection: Axis.horizontal,
                    itemCount: related.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (_, i) =>
                        SizedBox(width: 176, child: ProductCard(related[i], scope: 'rl${p.id}')),
                  ),
                ),
              ],
              const SizedBox(height: 120),
            ]),
          ),
        ),
      ]),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + MediaQuery.of(context).padding.bottom),
        decoration: BoxDecoration(
            color: pal.card, border: Border(top: BorderSide(color: pal.border))),
        child: Row(children: [
          Expanded(
            child: OutlinedButton(
                onPressed: _add,
                child: Text(context.t('add_to_cart'), overflow: TextOverflow.ellipsis)),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: GradientButton(
                  label: context.t('buy_now'),
                  icon: Icons.flash_on_rounded,
                  onPressed: _buyNow)),
        ]),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info(this.icon, this.text);
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: context.pal.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.pal.border)),
          child: Row(children: [
            Icon(icon, color: Brand.primary, size: 22),
            const SizedBox(width: 8),
            Expanded(
                child: Text(text,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
          ]),
        ),
      );
}
