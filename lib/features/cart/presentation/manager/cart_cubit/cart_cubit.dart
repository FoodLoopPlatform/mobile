import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodloop/features/cart/data/models/cart_item_model.dart';
import 'package:foodloop/features/cart/data/repositories/cart_repository.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository _cartRepository;

  CartCubit(this._cartRepository) : super(const CartInitial());

  List<CartItemModel> _items = [];

  // ── Public helpers ──────────────────────────────────────────────────────

  void loadCart() {
    _items = _cartRepository.getLocalCart();
    _emitLoaded();
  }

  Future<void> addItem(CartItemModel newItem) async {
    // ── Single-store rule ──────────────────────────────────────────────────
    // If the cart already has items from a different store, we cannot simply
    // add the new item — emit a conflict state so the UI can ask the user.
    if (_items.isNotEmpty &&
        _items.first.organizationId.isNotEmpty &&
        _items.first.organizationId != newItem.organizationId) {
      emit(CartStoreConflict(pendingItem: newItem));
      return;
    }
    // ── Normal add / quantity increment ───────────────────────────────────
    final idx = _items.indexWhere((i) => i.productId == newItem.productId);
    if (idx >= 0) {
      _items[idx] = _items[idx].copyWith(quantity: _items[idx].quantity + newItem.quantity);
    } else {
      _items.add(newItem);
    }
    await _persist();
    _emitLoaded();
  }

  /// Called after the user confirms they want to clear the old cart and start
  /// a new one from a different store.
  Future<void> clearCartAndAdd(CartItemModel newItem) async {
    _items = [newItem];
    await _persist();
    _emitLoaded();
  }

  Future<void> removeItem(String productId) async {
    _items.removeWhere((i) => i.productId == productId);
    await _persist();
    _emitLoaded();
  }

  Future<void> updateQuantity(String productId, int qty) async {
    if (qty <= 0) {
      await removeItem(productId);
      return;
    }
    final idx = _items.indexWhere((i) => i.productId == productId);
    if (idx >= 0) {
      _items[idx] = _items[idx].copyWith(quantity: qty);
      await _persist();
      _emitLoaded();
    }
  }

  Future<void> clearCart() async {
    _items = [];
    await _cartRepository.clearLocalCart();
    _emitLoaded();
  }

  Future<void> placeOrder() async {
    if (_items.isEmpty) return;
    emit(const CartLoading());
    try {
      final response = await _cartRepository.placeOrder(_items);
      _items = [];
      emit(CartOrderSuccess(response: response));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  // ── Private helpers ─────────────────────────────────────────────────────

  Future<void> _persist() => _cartRepository.saveLocalCart(_items);

  void _emitLoaded() {
    final subtotal = _items.fold<double>(
      0,
      (sum, item) => sum + item.price * item.quantity,
    );
    emit(CartLoaded(items: List.unmodifiable(_items), subtotal: subtotal));
  }
}
