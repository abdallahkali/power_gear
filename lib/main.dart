import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/brand.dart';
import 'core/theme.dart';
import 'data/store_repository.dart';
import 'providers/cart_provider.dart';
import 'providers/catalog_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/nav_provider.dart';
import 'providers/orders_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ar');
  await initializeDateFormatting('en');
  final prefs = await SharedPreferences.getInstance();
  runApp(StoreApp(prefs: prefs));
}

class StoreApp extends StatelessWidget {
  const StoreApp({super.key, required this.prefs});
  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 👇 لما الـ API يجهز بدّل MockStoreRepository بـ ApiStoreRepository
        Provider<StoreRepository>(create: (_) => MockStoreRepository()),
        ChangeNotifierProvider(create: (_) => SettingsProvider(prefs)),
        ChangeNotifierProvider(
            create: (c) => CatalogProvider(c.read<StoreRepository>())..load()),
        ChangeNotifierProvider(
            create: (c) => CartProvider(prefs, c.read<CatalogProvider>())),
        ChangeNotifierProvider(create: (_) => FavoritesProvider(prefs)),
        ChangeNotifierProvider(
            create: (c) => OrdersProvider(prefs, c.read<StoreRepository>())),
        ChangeNotifierProvider(create: (_) => NavProvider()),
      ],
      child: Builder(builder: (context) {
        final s = context.watch<SettingsProvider>();
        return MaterialApp(
          title: Brand.name.of(s.locale.languageCode),
          debugShowCheckedModeBanner: false,
          theme: buildTheme(Brightness.light),
          darkTheme: buildTheme(Brightness.dark),
          themeMode: s.themeMode,
          locale: s.locale,
          supportedLocales: const [Locale('ar'), Locale('en')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const SplashScreen(),
        );
      }),
    );
  }
}
