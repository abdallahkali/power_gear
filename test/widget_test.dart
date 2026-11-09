import 'package:flutter_test/flutter_test.dart';
import 'package:power_gear/data/products_data.dart';

void main() {
  test('products data is consistent', () {
    final ids = kProducts.map((p) => p.id).toSet();
    expect(ids.length, kProducts.length); // ids فريدة
    final cats = kCategories.map((c) => c.id).toSet();
    for (final p in kProducts) {
      expect(cats.contains(p.categoryId), isTrue, reason: p.id);
      if (p.onSale) expect(p.discountPercent, greaterThan(0));
    }
  });
}
