import 'product.dart';

class CartItem {
  final String productId;
  final int variantIndex; // -1 = بدون
  int qty;
  CartItem(this.productId, this.variantIndex, this.qty);

  String get key => '$productId|$variantIndex';

  Map<String, dynamic> toJson() => {'p': productId, 'v': variantIndex, 'q': qty};
  factory CartItem.fromJson(Map<String, dynamic> j) =>
      CartItem(j['p'] as String, j['v'] as int, j['q'] as int);
}

class CartLine {
  final CartItem item;
  final Product product;
  const CartLine(this.item, this.product);
  Variant? get variant => (item.variantIndex >= 0 && item.variantIndex < product.variants.length)
      ? product.variants[item.variantIndex]
      : null;
  int get total => product.price * item.qty;
}
