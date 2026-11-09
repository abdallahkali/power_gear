import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/brand.dart';
import '../core/format.dart';
import '../core/l10n.dart';
import '../core/theme.dart';
import '../providers/cart_provider.dart';
import '../providers/catalog_provider.dart';
import '../providers/nav_provider.dart';
import '../widgets/common.dart';
import '../widgets/product_image.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _promo = TextEditingController();

  @override
  void dispose() {
    _promo.dispose();
    super.dispose();
  }

  void _apply(CartProvider cart) {
    final ok = cart.applyPromo(_promo.text);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(context.t(ok ? 'promo_applied' : 'invalid_code'))));
    if (ok) _promo.clear();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    context.watch<CatalogProvider>();
    final pal = context.pal;
    final lines = cart.lines;

    if (lines.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(context.t('cart'))),
        body: EmptyState(
          icon: Icons.shopping_bag_outlined,
          title: context.t('cart_empty'),
          subtitle: context.t('cart_empty_sub'),
          action: FilledButton(
              onPressed: () => context.read<NavProvider>().go(1),
              child: Text(context.t('start_shopping'))),
        ),
      );
    }

    Widget row(String k, String v, {bool bold = false, Color? color}) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(children: [
            Text(k,
                style: TextStyle(
                    color: bold ? null : pal.muted,
                    fontSize: bold ? 17 : 14,
                    fontWeight: bold ? FontWeight.w900 : FontWeight.w600)),
            const Spacer(),
            Text(v,
                style: TextStyle(
                    fontSize: bold ? 19 : 14,
                    fontWeight: bold ? FontWeight.w900 : FontWeight.w700,
                    color: color ?? (bold ? Brand.primary : null))),
          ]),
        );

    return Scaffold(
      appBar: AppBar(title: Text('${context.t('cart')} (${cart.count})')),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 6, 20, 24), children: [
        for (final l in lines)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Dismissible(
              key: ValueKey(l.item.key),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: AlignmentDirectional.centerEnd,
                padding: const EdgeInsets.symmetric(horizontal: 22),
                decoration: BoxDecoration(
                    color: Colors.redAccent, borderRadius: BorderRadius.circular(20)),
                child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
              ),
              onDismissed: (_) {
                final item = l.item;
                cart.remove(item);
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                      content: Text(context.t('removed')),
                      action: SnackBarAction(
                          label: context.t('undo'),
                          textColor: Colors.white,
                          onPressed: () => cart.restore(item))));
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: pal.card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: pal.border)),
                child: Row(children: [
                  Container(
                    width: 92,
                    height: 92,
                    decoration:
                        BoxDecoration(color: pal.tint, borderRadius: BorderRadius.circular(16)),
                    child: ProductImage(l.product, padding: const EdgeInsets.all(8)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(context.tr(l.product.name),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800)),
                      if (l.variant != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Row(children: [
                            if (l.variant!.color != null)
                              Container(
                                  width: 12,
                                  height: 12,
                                  margin: const EdgeInsetsDirectional.only(end: 6),
                                  decoration: BoxDecoration(
                                      color: l.variant!.color, shape: BoxShape.circle)),
                            Flexible(
                              child: Text(context.tr(l.variant!.label),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 12.5, color: pal.muted)),
                            ),
                          ]),
                        ),
                      const SizedBox(height: 8),
                      Row(children: [
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(money(context, l.total),
                                style: const TextStyle(
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w900,
                                    color: Brand.primary)),
                          ),
                        ),
                        QtyStepper(
                            qty: l.item.qty,
                            max: l.product.stock,
                            onChanged: (v) => cart.setQty(l.item, v)),
                      ]),
                    ]),
                  ),
                ]),
              ),
            ),
          ),
        const SizedBox(height: 8),
        if (cart.promo == null)
          Row(children: [
            Expanded(
              child: TextField(
                controller: _promo,
                textCapitalization: TextCapitalization.characters,
                onSubmitted: (_) => _apply(cart),
                decoration: InputDecoration(
                    hintText: '${context.t('promo_code')} (${Brand.promoCode})',
                    prefixIcon: const Icon(Icons.local_offer_outlined)),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 96,
              height: 54,
              child: FilledButton(
                  style: FilledButton.styleFrom(minimumSize: const Size(96, 54)),
                  onPressed: () => _apply(cart),
                  child: Text(context.t('apply'))),
            ),
          ])
        else
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: const Color(0xFF16A34A).withOpacity(0.12),
                borderRadius: BorderRadius.circular(16)),
            child: Row(children: [
              const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A)),
              const SizedBox(width: 10),
              Expanded(
                  child: Text('${cart.promo}  •  -${Brand.promoPercent}%',
                      style: const TextStyle(fontWeight: FontWeight.w800))),
              GestureDetector(
                  onTap: cart.removePromo, child: const Icon(Icons.close_rounded, size: 20)),
            ]),
          ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
              color: pal.card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: pal.border)),
          child: Column(children: [
            row(context.t('subtotal'), money(context, cart.subtotal)),
            if (cart.discount > 0)
              row(context.t('discount'), '-${money(context, cart.discount)}',
                  color: const Color(0xFF16A34A)),
            row(context.t('shipping'),
                cart.shipping == 0 ? context.t('free') : money(context, cart.shipping)),
            Divider(height: 22, color: pal.border),
            row(context.t('total'), money(context, cart.total), bold: true),
          ]),
        ),
      ]),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        decoration: BoxDecoration(
            color: pal.card, border: Border(top: BorderSide(color: pal.border))),
        child: GradientButton(
          label: '${context.t('checkout')}  •  ${money(context, cart.total)}',
          icon: Icons.lock_rounded,
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => const CheckoutScreen())),
        ),
      ),
    );
  }
}
