import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/brand.dart';
import '../core/format.dart';
import '../core/l10n.dart';
import '../core/theme.dart';
import '../models/product.dart';
import '../providers/favorites_provider.dart';
import '../screens/product_details_screen.dart';
import 'common.dart';
import 'product_image.dart';

class ProductCard extends StatelessWidget {
  const ProductCard(this.product, {super.key, this.scope = 'g', this.index = 0});
  final Product product;
  final String scope;
  final int index;

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    final p = product;
    final fav = context.select<FavoritesProvider, bool>((f) => f.isFav(p.id));
    final tag = 'p_${p.id}_$scope';

    void open() => Navigator.push(context,
        MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: p, heroTag: tag)));

    return AnimatedEntry(
      index: index,
      child: GestureDetector(
        onTap: open,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              color: pal.card,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: pal.border)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Stack(children: [
              Container(
                height: 148,
                width: double.infinity,
                color: pal.tint,
                child: Hero(
                    tag: tag,
                    child: ProductImage(p, padding: const EdgeInsets.all(14))),
              ),
              if (p.onSale)
                PositionedDirectional(
                    top: 10, start: 10, child: _Badge('-${p.discountPercent}%', Brand.primary))
              else if (p.isNew)
                PositionedDirectional(
                    top: 10, start: 10, child: _Badge(context.t('new'), const Color(0xFF16A34A))),
              PositionedDirectional(
                top: 6,
                end: 6,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => context.read<FavoritesProvider>().toggle(p.id),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(color: pal.card, shape: BoxShape.circle),
                      child: Icon(fav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          size: 19, color: fav ? Brand.primary : pal.muted),
                    ),
                  ),
                ),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(context.tr(p.name),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                RatingStars(p.rating, reviews: p.reviews, size: 12),
                const SizedBox(height: 6),
                Row(children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      SizedBox(
                        height: 14,
                        child: p.onSale
                            ? Text(money(context, p.oldPrice!),
                                style: TextStyle(
                                    fontSize: 11.5,
                                    color: pal.muted,
                                    decoration: TextDecoration.lineThrough))
                            : null,
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(money(context, p.price),
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Brand.primary)),
                      ),
                    ]),
                  ),
                  GestureDetector(
                    onTap: () => p.hasVariants ? open() : addToCartWithFeedback(context, p),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                          gradient: Brand.gradient, borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.add_shopping_cart_rounded,
                          size: 19, color: Colors.white),
                    ),
                  ),
                ]),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge(this.text, this.color);
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
        child: Text(text,
            style: const TextStyle(
                color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w800)),
      );
}
