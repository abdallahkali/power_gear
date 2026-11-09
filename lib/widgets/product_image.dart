import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductImage extends StatelessWidget {
  const ProductImage(this.product,
      {super.key, this.fit = BoxFit.contain, this.padding = EdgeInsets.zero});
  final Product product;
  final BoxFit fit;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final src = product.image;
    final img = src.startsWith('http')
        ? Image.network(src,
            fit: fit,
            errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported_outlined))
        : Image.asset(src, fit: fit);
    return Padding(padding: padding, child: img);
  }
}
