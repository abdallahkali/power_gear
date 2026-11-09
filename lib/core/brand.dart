import 'package:flutter/material.dart';
import '../models/bi.dart';
import '../models/promo.dart';

/// ⚙️ كل ما يخص هوية التطبيق (الاسم، الألوان، الكود الترويجي، الشحن...) في الملف ده.
class Brand {
  static const name = Bi('باور جير', 'PowerGear');
  static const tagline = Bi('جهّز نفسك للتحدي', 'Gear up for the challenge');
  static const IconData logo = Icons.fitness_center_rounded;

  static const primary = Color(0xFFE11D2E);
  static const gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFF4B4B), Color(0xFFC1121F)]);
  static const splashGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFE11D2E), Color(0xFF7A0E17)]);

  // الوضع الفاتح
  static const lightBg = Color(0xFFFFFFFF);
  static const lightCard = Color(0xFFFFFFFF);
  static const lightTint = Color(0xFFFDECEE); // خلفية صور المنتجات
  // الوضع الداكن
  static const darkBg = Color(0xFF0C0C0E);
  static const darkCard = Color(0xFF18181B);
  static const darkTint = Color(0xFF2A1518);

  static const promoCode = 'POWER10';
  static const promoPercent = 10;
  static const shippingFee = 60;
  static const freeShippingFrom = 1500;
  static const phone = '+201000000000';
  static const whatsapp = '201000000000';
  static const orderPrefix = 'PG';

  static const banners = <PromoBanner>[
    PromoBanner(Bi('خصم 30%', '30% OFF'), Bi('ملابس التدريب\nبأسعار قوية', 'Training wear\nat power prices'), Bi('تشكيلة رجالي كاملة', 'Full men\'s collection'), 'assets/images/hoodie.png', [Color(0xFFE11D2E), Color(0xFF8B0F19)]),
    PromoBanner(Bi('جديد', 'NEW'), Bi('تشكيلة الجري\nالجديدة', 'New running\ncollection'), Bi('أحذية خفيفة ومريحة', 'Light & comfortable shoes'), 'assets/images/sneaker.png', [Color(0xFF2E333B), Color(0xFF0B0C0E)]),
    PromoBanner(Bi('جيم منزلي', 'HOME GYM'), Bi('ابنِ جيمك\nفي بيتك', 'Build your\nhome gym'), Bi('أوزان ومعدات احترافية', 'Pro weights & equipment'), 'assets/images/dumbbell.png', [Color(0xFFFF5A5F), Color(0xFFD1121F)]),
  ];
}
