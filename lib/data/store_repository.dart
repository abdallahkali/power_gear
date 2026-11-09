import '../models/order.dart';
import '../models/product.dart';
import 'products_data.dart';

/// الواجهة اللي التطبيق بيتعامل معاها.
/// لما الـ API يجهز: اعمل ApiStoreRepository يـ implements الكلاس ده وبدّله في main.dart.
abstract class StoreRepository {
  Future<List<ProductCategory>> getCategories();
  Future<List<Product>> getProducts();
  Future<Order> placeOrder(Order order);
}

class MockStoreRepository implements StoreRepository {
  @override
  Future<List<ProductCategory>> getCategories() async => kCategories;

  @override
  Future<List<Product>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 350));
    return kProducts;
  }

  @override
  Future<Order> placeOrder(Order order) async {
    await Future.delayed(const Duration(milliseconds: 900));
    return order;
  }
}
