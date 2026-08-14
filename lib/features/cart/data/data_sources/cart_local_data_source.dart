import 'package:hive/hive.dart';
import '../models/cart_item_model.dart';

class CartLocalDataSource {
  static const String _boxName = 'cart';

  Box<dynamic> get _box => Hive.box<dynamic>(_boxName);

  List<CartItemModel> loadCart() {
    final rawList = _box.get('items');
    if (rawList == null || rawList is! List) return [];
    return rawList
        .map((e) => CartItemModel.fromMap(e as Map<dynamic, dynamic>))
        .toList();
  }

  Future<void> saveCart(List<CartItemModel> items) async {
    await _box.put('items', items.map((e) => e.toMap()).toList());
  }

  Future<void> clearCart() async {
    await _box.delete('items');
  }
}
