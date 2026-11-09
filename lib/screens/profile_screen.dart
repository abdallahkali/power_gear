import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/brand.dart';
import '../core/l10n.dart';
import '../core/theme.dart';
import '../providers/orders_provider.dart';
import '../providers/settings_provider.dart';
import 'orders_screen.dart';

Future<void> _open(BuildContext context, String url) async {
  final ok = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  if (!ok && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('—')));
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<SettingsProvider>();
    final orders = context.watch<OrdersProvider>().orders.length;
    final pal = context.pal;

    Widget label(String t) => Padding(
          padding: const EdgeInsets.only(top: 22, bottom: 10),
          child: Text(t, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
        );

    Widget tile(IconData i, String t, {String? sub, VoidCallback? onTap, Widget? trailing}) =>
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Card(
            child: ListTile(
              onTap: onTap,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              leading: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                    color: Brand.primary.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                child: Icon(i, color: Brand.primary, size: 22),
              ),
              title: Text(t, style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: sub == null ? null : Text(sub, style: TextStyle(color: pal.muted)),
              trailing: trailing ??
                  (onTap == null
                      ? null
                      : Icon(context.isAr ? Icons.chevron_left_rounded : Icons.chevron_right_rounded)),
            ),
          ),
        );

    return Scaffold(
      appBar: AppBar(title: Text(context.t('profile'))),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 4, 20, 40), children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              gradient: Brand.gradient, borderRadius: BorderRadius.circular(26)),
          child: Row(children: [
            Container(
              width: 62,
              height: 62,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: Icon(Brand.logo, color: Brand.primary, size: 32),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(context.t('guest'),
                    style: const TextStyle(
                        color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                const SizedBox(height: 2),
                Text(context.tr(Brand.name), style: const TextStyle(color: Colors.white70)),
              ]),
            ),
          ]),
        ),
        const SizedBox(height: 16),
        tile(Icons.receipt_long_rounded, context.t('my_orders'),
            sub: orders == 0 ? null : '$orders',
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const OrdersScreen()))),
        label(context.t('language')),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<String>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(value: 'ar', label: Text(context.t('arabic'))),
              ButtonSegment(value: 'en', label: Text(context.t('english'))),
            ],
            selected: {s.locale.languageCode},
            onSelectionChanged: (v) => s.setLang(v.first),
          ),
        ),
        label(context.t('theme')),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<ThemeMode>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(
                  value: ThemeMode.system,
                  icon: const Icon(Icons.brightness_auto_rounded, size: 18),
                  label: Text(context.t('theme_system'))),
              ButtonSegment(
                  value: ThemeMode.light,
                  icon: const Icon(Icons.light_mode_rounded, size: 18),
                  label: Text(context.t('theme_light'))),
              ButtonSegment(
                  value: ThemeMode.dark,
                  icon: const Icon(Icons.dark_mode_rounded, size: 18),
                  label: Text(context.t('theme_dark'))),
            ],
            selected: {s.themeMode},
            onSelectionChanged: (v) => s.setTheme(v.first),
          ),
        ),
        label(context.t('contact_us')),
        tile(Icons.phone_rounded, context.t('call_us'),
            sub: Brand.phone, onTap: () => _open(context, 'tel:${Brand.phone}')),
        tile(Icons.chat_rounded, context.t('whatsapp'),
            sub: Brand.phone, onTap: () => _open(context, 'https://wa.me/${Brand.whatsapp}')),
        const SizedBox(height: 14),
        Center(
            child: Text('${context.tr(Brand.name)}  •  ${context.t('version')} 1.0.0',
                style: TextStyle(color: pal.muted, fontSize: 12))),
      ]),
    );
  }
}
