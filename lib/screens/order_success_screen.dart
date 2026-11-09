import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/brand.dart';
import '../core/format.dart';
import '../core/l10n.dart';
import '../core/theme.dart';
import '../models/order.dart';
import '../providers/nav_provider.dart';
import '../widgets/common.dart';
import 'orders_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key, required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    final pal = context.pal;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            const Spacer(),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.4, end: 1),
              duration: const Duration(milliseconds: 700),
              curve: Curves.elasticOut,
              builder: (_, v, c) => Transform.scale(scale: v, child: c),
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                    gradient: Brand.gradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Brand.primary.withOpacity(0.4),
                          blurRadius: 36,
                          offset: const Offset(0, 16))
                    ]),
                child: const Icon(Icons.check_rounded, size: 76, color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),
            Text(context.t('order_success'),
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text(context.t('order_success_sub'),
                textAlign: TextAlign.center, style: TextStyle(color: pal.muted)),
            const SizedBox(height: 26),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                  color: pal.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: pal.border)),
              child: Column(children: [
                Row(children: [
                  Text(context.t('order_no'), style: TextStyle(color: pal.muted)),
                  const Spacer(),
                  Text(order.id, style: const TextStyle(fontWeight: FontWeight.w900)),
                ]),
                Divider(height: 24, color: pal.border),
                Row(children: [
                  Text(context.t('total'), style: TextStyle(color: pal.muted)),
                  const Spacer(),
                  Text(money(context, order.total),
                      style: const TextStyle(
                          fontWeight: FontWeight.w900, fontSize: 18, color: Brand.primary)),
                ]),
              ]),
            ),
            const Spacer(),
            OutlinedButton(
                onPressed: () {
                  Navigator.popUntil(context, (r) => r.isFirst);
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => const OrdersScreen()));
                },
                child: Text(context.t('my_orders'))),
            const SizedBox(height: 12),
            GradientButton(
                label: context.t('continue_shopping'),
                onPressed: () {
                  final nav = context.read<NavProvider>();
                  Navigator.popUntil(context, (r) => r.isFirst);
                  nav.go(0);
                }),
          ]),
        ),
      ),
    );
  }
}
