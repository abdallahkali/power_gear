import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/brand.dart';
import '../core/l10n.dart';
import '../core/theme.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/nav_provider.dart';

class GradientButton extends StatelessWidget {
  const GradientButton(
      {super.key, required this.label, this.icon, this.onPressed, this.loading = false});
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(16);
    return Opacity(
      opacity: onPressed == null && !loading ? 0.5 : 1,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            gradient: Brand.gradient,
            borderRadius: r,
            boxShadow: [
              BoxShadow(
                  color: Brand.primary.withOpacity(0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 8))
            ],
          ),
          child: InkWell(
            borderRadius: r,
            onTap: loading ? null : onPressed,
            child: SizedBox(
              height: 54,
              child: Center(
                child: loading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                    : Row(mainAxisSize: MainAxisSize.min, children: [
                        if (icon != null) ...[
                          Icon(icon, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                        ],
                        Flexible(
                          child: Text(label,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                        ),
                      ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.onSeeAll});
  final String title;
  final VoidCallback? onSeeAll;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 26, 20, 12),
        child: Row(children: [
          Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                  gradient: Brand.gradient, borderRadius: BorderRadius.circular(4))),
          const SizedBox(width: 10),
          Expanded(
              child: Text(title,
                  style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800))),
          if (onSeeAll != null)
            TextButton(onPressed: onSeeAll, child: Text(context.t('see_all'))),
        ]),
      );
}

class EmptyState extends StatelessWidget {
  const EmptyState(
      {super.key, required this.icon, required this.title, this.subtitle, this.action});
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Brand.primary.withOpacity(0.12)),
              child: Icon(icon, size: 46, color: Brand.primary),
            ),
            const SizedBox(height: 20),
            Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(subtitle!,
                  textAlign: TextAlign.center, style: TextStyle(color: context.pal.muted)),
            ],
            if (action != null) ...[const SizedBox(height: 22), action!],
          ]),
        ),
      );
}

class QtyStepper extends StatelessWidget {
  const QtyStepper({super.key, required this.qty, required this.onChanged, this.max = 20});
  final int qty;
  final int max;
  final ValueChanged<int> onChanged;
  @override
  Widget build(BuildContext context) {
    Widget btn(IconData i, VoidCallback? f) => GestureDetector(
          onTap: f,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
                color: f == null ? context.pal.border : Brand.primary.withOpacity(0.14),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(i, size: 18, color: f == null ? context.pal.muted : Brand.primary),
          ),
        );
    return Row(mainAxisSize: MainAxisSize.min, children: [
      btn(Icons.remove_rounded, qty > 1 ? () => onChanged(qty - 1) : null),
      SizedBox(
          width: 38,
          child: Center(
              child: Text('$qty',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)))),
      btn(Icons.add_rounded, qty < max ? () => onChanged(qty + 1) : null),
    ]);
  }
}

class RatingStars extends StatelessWidget {
  const RatingStars(this.rating, {super.key, this.reviews, this.size = 14});
  final double rating;
  final int? reviews;
  final double size;
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.star_rounded, size: size + 2, color: const Color(0xFFFFB020)),
        const SizedBox(width: 3),
        Text(rating.toStringAsFixed(1),
            style: TextStyle(fontSize: size, fontWeight: FontWeight.w700)),
        if (reviews != null)
          Text(' ($reviews)', style: TextStyle(fontSize: size - 1, color: context.pal.muted)),
      ]);
}

class AppIconButton extends StatelessWidget {
  const AppIconButton({super.key, required this.icon, required this.onTap, this.color});
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
              color: context.pal.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.pal.border)),
          child: Icon(icon, size: 22, color: color),
        ),
      );
}

class AnimatedEntry extends StatelessWidget {
  const AnimatedEntry({super.key, required this.child, this.index = 0});
  final Widget child;
  final int index;
  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: Duration(milliseconds: 350 + index.clamp(0, 6) * 70),
        curve: Curves.easeOutCubic,
        builder: (_, v, c) => Opacity(
            opacity: v, child: Transform.translate(offset: Offset(0, (1 - v) * 16), child: c)),
        child: child,
      );
}

/// إضافة سريعة للسلة مع Snackbar فيه زر "عرض السلة"
void addToCartWithFeedback(BuildContext context, Product p,
    {int variantIndex = -1, int qty = 1}) {
  context.read<CartProvider>().add(p, variantIndex: variantIndex, qty: qty);
  final messenger = ScaffoldMessenger.of(context);
  final nav = context.read<NavProvider>();
  final navigator = Navigator.of(context);
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(context.t('added')),
      action: SnackBarAction(
        label: context.t('view_cart'),
        textColor: Colors.white,
        onPressed: () {
          navigator.popUntil((r) => r.isFirst);
          nav.go(3);
        },
      ),
    ));
}
