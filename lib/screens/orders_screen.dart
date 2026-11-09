import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/brand.dart';
import '../core/format.dart';
import '../core/l10n.dart';
import '../core/theme.dart';
import '../providers/orders_provider.dart';
import '../widgets/common.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrdersProvider>().orders;
    final pal = context.pal;
    return Scaffold(
      appBar: AppBar(title: Text(context.t('my_orders'))),
      body: orders.isEmpty
          ? EmptyState(
              icon: Icons.receipt_long_outlined,
              title: context.t('no_orders'),
              subtitle: context.t('no_orders_sub'))
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final o = orders[i];
                return Container(
                  decoration: BoxDecoration(
                      color: pal.card,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: pal.border)),
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      title: Row(children: [
                        Text(o.id, style: const TextStyle(fontWeight: FontWeight.w900)),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                          decoration: BoxDecoration(
                              color: Brand.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(context.t('status_processing'),
                              style: const TextStyle(
                                  color: Brand.primary,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w800)),
                        ),
                      ]),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                            '${fmtDate(context, o.date)}  •  ${o.itemCount} ${context.t('items')}',
                            style: TextStyle(color: pal.muted, fontSize: 12.5)),
                      ),
                      trailing: Text(money(context, o.total),
                          style: const TextStyle(
                              fontWeight: FontWeight.w900, color: Brand.primary)),
                      children: [
                        for (final l in o.lines)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(children: [
                              Container(
                                width: 52,
                                height: 52,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: pal.tint, borderRadius: BorderRadius.circular(12)),
                                child: Image.asset(l.image, fit: BoxFit.contain),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(context.tr(l.name),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontWeight: FontWeight.w700)),
                                      Text(
                                          '${l.qty} × ${money(context, l.price)}'
                                          '${l.variant != null ? '  •  ${context.tr(l.variant!)}' : ''}',
                                          style: TextStyle(color: pal.muted, fontSize: 12.5)),
                                    ]),
                              ),
                            ]),
                          ),
                        Divider(color: pal.border),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text('${o.name} • ${o.phone}\n${o.city} - ${o.address}',
                              style: TextStyle(color: pal.muted, fontSize: 12.5, height: 1.6)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
