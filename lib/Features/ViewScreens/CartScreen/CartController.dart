
// ==================== CONTROLLER ====================
import 'package:flutter/foundation.dart';

import 'CartModal.dart';

class CartController extends ChangeNotifier {
  List<CartItem> _cartItems = [];
  bool _isLoading = false;
  String _promoCode = '';
  double _discount = 0;

  List<CartItem> get cartItems => _cartItems;
  bool get isLoading => _isLoading;
  String get promoCode => _promoCode;
  double get discount => _discount;

  CartController() {
    loadCart();
  }

  Future<void> loadCart() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    _cartItems = [
      CartItem(
        id: '1',
        productName: 'Full Cream Milk',
        productImage: 'assets/milk_pack.png',
        price: 35,
        quantity: 2,
        unit: '500ml',
        category: 'Milk',
      ),
      CartItem(
        id: '2',
        productName: 'Fresh Curd',
        productImage: 'assets/curd.png',
        price: 40,
        quantity: 1,
        unit: '400g',
        category: 'Dairy',
      ),
      CartItem(
        id: '3',
        productName: 'Pure Ghee',
        productImage: 'assets/ghee.png',
        price: 550,
        quantity: 1,
        unit: '500g',
        category: 'Dairy',
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }

  void increaseQuantity(String itemId) {
    final index = _cartItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      _cartItems[index].quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(String itemId) {
    final index = _cartItems.indexWhere((item) => item.id == itemId);
    if (index != -1 && _cartItems[index].quantity > 1) {
      _cartItems[index].quantity--;
      notifyListeners();
    }
  }

  void removeItem(String itemId) {
    _cartItems.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }

  void applyPromoCode(String code) {
    _promoCode = code;
    // Simulate promo code validation
    if (code.toUpperCase() == 'MILK10') {
      _discount = subtotal * 0.1; // 10% discount
    } else if (code.toUpperCase() == 'SAVE20') {
      _discount = 20;
    } else {
      _discount = 0;
    }
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  double get subtotal {
    return _cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  }

  double get deliveryFee => subtotal > 200 ? 0 : 20;

  double get total => subtotal + deliveryFee - discount;

  int get itemCount => _cartItems.length;

  int get totalQuantity {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }
}
