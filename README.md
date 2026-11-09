# PowerGear — باور جير

متجر باور جير للأدوات والملابس الرياضية الرجالي. تطبيق Flutter بلغتين (العربية / English) وثيم فاتح وداكن.

## التشغيل (Flutter 3.27 أو أحدث)
```bash
cd power_gear
flutter create --org com.yourcompany --project-name power_gear .
flutter pub get
dart run flutter_launcher_icons     # أيقونة التطبيق
flutter run
```
> `flutter create .` بيولّد فولدرات android/ios ومش بيمسح كود `lib`.

### إعداد الاتصال وواتساب (url_launcher)
**Android** — في `android/app/src/main/AndroidManifest.xml` قبل `<application>`:
```xml
<queries>
  <intent><action android:name="android.intent.action.VIEW"/><data android:scheme="https"/></intent>
  <intent><action android:name="android.intent.action.DIAL"/><data android:scheme="tel"/></intent>
</queries>
```
**iOS** — في `ios/Runner/Info.plist`:
```xml
<key>LSApplicationQueriesSchemes</key>
<array><string>tel</string><string>https</string></array>
```

## الميزات
- شاشة بداية، رئيسية بعروض متحركة، أقسام، الأكثر مبيعًا، العروض، وصل حديثًا
- متجر بحث + فلتر (قسم / سعر / عروض) + ترتيب
- تفاصيل المنتج: مقاسات أو درجات ألوان، كمية، مميزات، منتجات مشابهة
- سلة (سحب للحذف + تراجع) + كود خصم **POWER10** (10%) + شحن مجاني فوق 1500 ج.م
- إتمام الشراء: بيانات توصيل + دفع عند الاستلام أو بطاقة (واجهة فقط) + صفحة نجاح
- طلباتي، المفضلة، الإعدادات (اللغة / المظهر)، تواصل
- الحفظ المحلي للسلة والمفضلة والطلبات واللغة والثيم (shared_preferences)

## المعمارية
```
lib/
 core/       brand.dart (الهوية)، theme، l10n (ar/en)، format
 models/     Product, Bi (نص ثنائي اللغة), CartItem, Order
 data/       StoreRepository (interface) + MockStoreRepository + products_data
 providers/  catalog, cart, favorites, orders, settings, nav
 screens/    splash, shell, home, shop, details, cart, checkout, success, orders, profile
 widgets/    product_card, product_image, promo_carousel, common
assets/images/  صور المنتجات (PNG شفافة)
```

## تخصيص
- الاسم والألوان والكود الترويجي والشحن: `lib/core/brand.dart`
- المنتجات والأقسام: `lib/data/products_data.dart` (والصورة في `assets/images/`)
- النصوص: `lib/core/l10n.dart`

## ربط API لاحقًا
1. اعمل `ApiStoreRepository` يـ implements `StoreRepository`.
2. بدّل `MockStoreRepository()` في `main.dart`.
3. الصور تقبل روابط `http` مباشرة في `Product.image`.
