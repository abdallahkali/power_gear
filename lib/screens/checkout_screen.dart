import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/brand.dart';
import '../core/format.dart';
import '../core/l10n.dart';
import '../core/theme.dart';
import '../models/order.dart';
import '../providers/cart_provider.dart';
import '../providers/orders_provider.dart';
import '../widgets/common.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _city = TextEditingController();
  final _address = TextEditingController();
  final _notes = TextEditingController();
  final _card = TextEditingController();
  final _exp = TextEditingController();
  final _cvv = TextEditingController();
  String _pay = 'cod';
  bool _busy = false;

  @override
  void dispose() {
    for (final c in [_name, _phone, _city, _address, _notes, _card, _exp, _cvv]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _place() async {
    if (!_form.currentState!.validate()) return;
    final cart = context.read<CartProvider>();
    final orders = context.read<OrdersProvider>();
    final lines = cart.lines;
    if (lines.isEmpty) return;

    final order = Order(
      id: '${Brand.orderPrefix}-${DateTime.now().millisecondsSinceEpoch % 1000000}',
      date: DateTime.now(),
      lines: [
        for (final l in lines)
          OrderLine(l.product.name, l.product.image, l.item.qty, l.product.price, l.variant?.label)
      ],
      subtotal: cart.subtotal,
      shipping: cart.shipping,
      discount: cart.discount,
      total: cart.total,
      name: _name.text.trim(),
      phone: _phone.text.trim(),
      city: _city.text.trim(),
      address: _address.text.trim(),
      payment: _pay,
    );

    setState(() => _busy = true);
    try {
      final saved = await orders.place(order);
      cart.clear();
      if (!mounted) return;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => OrderSuccessScreen(order: saved)));
    } catch (_) {
      if (!mounted) return;
      setState(() => _busy = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.t('error_load'))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final pal = context.pal;
    String? req(String? v) => (v == null || v.trim().isEmpty) ? context.t('required') : null;

    Widget title(String t) => Padding(
          padding: const EdgeInsets.only(top: 22, bottom: 10),
          child: Text(t, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
        );

    Widget payTile(String id, IconData icon, String label) {
      final sel = _pay == id;
      return GestureDetector(
        onTap: () => setState(() => _pay = id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: sel ? Brand.primary.withOpacity(0.1) : pal.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: sel ? Brand.primary : pal.border, width: sel ? 1.8 : 1),
          ),
          child: Row(children: [
            Icon(icon, color: Brand.primary),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700))),
            Icon(sel ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                color: sel ? Brand.primary : pal.muted),
          ]),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.t('checkout'))),
      body: Form(
        key: _form,
        child: ListView(padding: const EdgeInsets.fromLTRB(20, 0, 20, 30), children: [
          title(context.t('delivery_info')),
          TextFormField(
            controller: _name,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                labelText: context.t('full_name'), prefixIcon: const Icon(Icons.person_outline)),
            validator: (v) => (v == null || v.trim().length < 3) ? context.t('required') : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _phone,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            textDirection: TextDirection.ltr,
            decoration: InputDecoration(
                labelText: context.t('phone'), prefixIcon: const Icon(Icons.phone_outlined)),
            validator: (v) => RegExp(r'^01[0125][0-9]{8}$').hasMatch(v?.trim() ?? '')
                ? null
                : context.t('invalid_phone'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _city,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                labelText: context.t('city'), prefixIcon: const Icon(Icons.location_city_outlined)),
            validator: req,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _address,
            maxLines: 2,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                labelText: context.t('address'), prefixIcon: const Icon(Icons.home_outlined)),
            validator: req,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _notes,
            maxLines: 2,
            decoration: InputDecoration(labelText: context.t('notes')),
          ),
          title(context.t('payment')),
          payTile('cod', Icons.payments_outlined, context.t('cod')),
          payTile('card', Icons.credit_card_rounded, context.t('card')),
          if (_pay == 'card') ...[
            const SizedBox(height: 4),
            TextFormField(
              controller: _card,
              keyboardType: TextInputType.number,
              textDirection: TextDirection.ltr,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(16)],
              decoration: InputDecoration(
                  labelText: context.t('card_number'), prefixIcon: const Icon(Icons.credit_card)),
              validator: (v) => (v ?? '').length == 16 ? null : context.t('invalid_card'),
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: TextFormField(
                  controller: _exp,
                  keyboardType: TextInputType.datetime,
                  textDirection: TextDirection.ltr,
                  decoration: InputDecoration(hintText: context.t('expiry')),
                  validator: (v) => RegExp(r'^(0[1-9]|1[0-2])/\d{2}$').hasMatch(v ?? '')
                      ? null
                      : context.t('invalid_card'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _cvv,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  textDirection: TextDirection.ltr,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                  decoration: InputDecoration(hintText: context.t('cvv')),
                  validator: (v) => (v ?? '').length >= 3 ? null : context.t('invalid_card'),
                ),
              ),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              Icon(Icons.lock_outline_rounded, size: 15, color: pal.muted),
              const SizedBox(width: 6),
              Text(context.t('pay_secure_note'), style: TextStyle(color: pal.muted, fontSize: 12)),
            ]),
          ],
          title(context.t('order_summary')),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: pal.card,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: pal.border)),
            child: Column(children: [
              _SumRow(context.t('subtotal'), money(context, cart.subtotal)),
              if (cart.discount > 0)
                _SumRow(context.t('discount'), '-${money(context, cart.discount)}'),
              _SumRow(context.t('shipping'),
                  cart.shipping == 0 ? context.t('free') : money(context, cart.shipping)),
              Divider(height: 20, color: pal.border),
              _SumRow(context.t('total'), money(context, cart.total), bold: true),
            ]),
          ),
          const SizedBox(height: 22),
          GradientButton(
              label: context.t('place_order'),
              icon: Icons.check_rounded,
              loading: _busy,
              onPressed: _place),
        ]),
      ),
    );
  }
}

class _SumRow extends StatelessWidget {
  const _SumRow(this.k, this.v, {this.bold = false});
  final String k, v;
  final bool bold;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(children: [
          Text(k,
              style: TextStyle(
                  color: bold ? null : context.pal.muted,
                  fontWeight: bold ? FontWeight.w900 : FontWeight.w600)),
          const Spacer(),
          Text(v,
              style: TextStyle(
                  fontSize: bold ? 18 : 14,
                  fontWeight: FontWeight.w900,
                  color: bold ? Brand.primary : null)),
        ]),
      );
}
