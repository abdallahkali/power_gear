import 'package:flutter/material.dart';
import 'bi.dart';

enum VariantType { none, size, shade }

class Variant {
  final Bi label;
  final Color? color;
  const Variant(this.label, [this.color]);
}

class ProductCategory {
  final String id;
  final Bi name;
  final IconData icon;
  const ProductCategory(this.id, this.name, this.icon);
}

class Product {
  final String id;
  final Bi name;
  final Bi description;
  final String categoryId;
  final int price;
  final int? oldPrice;
  final double rating;
  final int reviews;
  final String image; // asset path أو رابط http
  final VariantType variantType;
  final List<Variant> variants;
  final List<Bi> features;
  final bool isNew;
  final bool bestSeller;
  final int stock;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.price,
    this.oldPrice,
    required this.rating,
    required this.reviews,
    required this.image,
    this.variantType = VariantType.none,
    this.variants = const [],
    this.features = const [],
    this.isNew = false,
    this.bestSeller = false,
    this.stock = 20,
  });

  bool get hasVariants => variantType != VariantType.none && variants.isNotEmpty;
  bool get onSale => oldPrice != null && oldPrice! > price;
  int get discountPercent => onSale ? (((oldPrice! - price) / oldPrice!) * 100).round() : 0;
}
