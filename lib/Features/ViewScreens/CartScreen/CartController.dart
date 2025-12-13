import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'CartAPi.dart';
import 'CartModal.dart';
import 'orrdermodal.dart';

class CartController extends ChangeNotifier {
  final CartApiService _api = CartApiService();

  bool isLoading = false;
  bool isUpdating = false; // ✅ Separate flag for quantity updates

  CartData? _cart;
  OrderSummary? summary;

  /// Checkout fields
  String deliveryAddress = "";
  int deliverySlot = 1;
  String paymentMethod = "COD";

  // ✅ Debounce timer to prevent multiple API calls
  Timer? _debounceTimer;
  final Map<int, int> _pendingUpdates = {}; // cartItemId -> newQuantity

  /// ================= GETTERS =================
  List<CartItem> get cartItems => _cart?.items ?? [];

  double get subtotal => summary?.subtotal ?? 0;
  double get deliveryFee => summary?.deliveryCharge ?? 0;
  double get discount => summary?.discount ?? 0;
  double get total => summary?.totalAmount ?? 0;

  int get itemCount => cartItems.length;
  int get totalQuantity =>
      cartItems.fold(0, (sum, item) => sum + item.quantity);

  /// ================= LOAD CART + SUMMARY =================
  Future<void> loadCartAndSummary() async {
    print("🟡 loadCartAndSummary CALLED");
    isLoading = true;
    notifyListeners();

    _cart = await _api.getCart();
    print("🟢 CART LOADED: ${_cart?.items.length} items");

    summary = await _api.getSummary();
    print("🟢 SUMMARY LOADED: Total = ${summary?.totalAmount}");

    isLoading = false;
    notifyListeners();
  }

  /// ================= OPTIMISTIC UPDATE (Local UI Update) =================
  void _updateLocalQuantity(int cartItemId, int newQuantity) {
    final index = cartItems.indexWhere((e) => e.id == cartItemId);
    if (index != -1) {
      // ✅ Update local state immediately (optimistic update)
      _cart!.items[index] = _cart!.items[index].copyWith(quantity: newQuantity);

      // ✅ Update local totals
      _updateLocalTotals();

      notifyListeners();
    }
  }

  void _updateLocalTotals() {
    if (_cart == null) return;

    // Calculate new subtotal
    double newSubtotal = 0;
    for (var item in cartItems) {
      newSubtotal += item.price * item.quantity;
    }

    // Update summary if exists
    if (summary != null) {
      summary = OrderSummary(
        items: summary!.items,
        subtotal: newSubtotal,
        deliveryCharge: summary!.deliveryCharge,
        discount: summary!.discount,
        totalAmount: newSubtotal + summary!.deliveryCharge - summary!.discount,
      );
    }
  }

  /// ================= INCREASE QUANTITY =================
  Future<void> increaseQuantity(int cartItemId) async {
    print("➕ Increase clicked for cart item: $cartItemId");

    final index = cartItems.indexWhere((e) => e.id == cartItemId);
    if (index == -1) return;

    final item = cartItems[index];
    final newQuantity = item.quantity + 1;

    print("📊 ${item.productName}: ${item.quantity} → $newQuantity");

    // ✅ Update UI immediately (optimistic update)
    _updateLocalQuantity(cartItemId, newQuantity);

    // ✅ Store pending update
    _pendingUpdates[cartItemId] = newQuantity;

    // ✅ Debounce API call
    _debounceApiUpdate(cartItemId, item.product.id, newQuantity);
  }

  /// ================= DECREASE QUANTITY =================
  Future<void> decreaseQuantity(int cartItemId) async {
    print("➖ Decrease clicked for cart item: $cartItemId");

    final index = cartItems.indexWhere((e) => e.id == cartItemId);
    if (index == -1) return;

    final item = cartItems[index];
    final currentQty = item.quantity;

    if (currentQty > 1) {
      final newQuantity = currentQty - 1;
      print("📊 ${item.productName}: $currentQty → $newQuantity");

      // ✅ Update UI immediately
      _updateLocalQuantity(cartItemId, newQuantity);

      // ✅ Store pending update
      _pendingUpdates[cartItemId] = newQuantity;

      // ✅ Debounce API call
      _debounceApiUpdate(cartItemId, item.product.id, newQuantity);
    } else {
      // ✅ Remove item if quantity is 1
      print("🗑️ Removing item (quantity = 1)");
      await removeItem(cartItemId);
    }
  }

  /// ================= DEBOUNCED API UPDATE =================
  void _debounceApiUpdate(int cartItemId, int productId, int newQuantity) {
    // Cancel previous timer
    _debounceTimer?.cancel();

    // Set new timer (500ms delay)
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      print("🔄 Syncing with backend: Product $productId, Qty $newQuantity");

      isUpdating = true;
      notifyListeners();

      final success = await _api.addToCart(productId, newQuantity);

      if (success) {
        print("✅ Backend synced successfully");

        // ✅ Reload summary only (not full cart to avoid flickering)
        summary = await _api.getSummary();

        // Remove from pending updates
        _pendingUpdates.remove(cartItemId);
      } else {
        print("❌ Backend sync failed, reverting UI");

        // ✅ Revert to previous state on failure
        await loadCartAndSummary();
      }

      isUpdating = false;
      notifyListeners();
    });
  }

  /// ================= REMOVE ITEM =================
  Future<void> removeItem(int cartItemId) async {
    print("🗑️ Removing cart item: $cartItemId");

    // ✅ Show loading for delete
    isUpdating = true;
    notifyListeners();

    final success = await _api.removeFromCart(cartItemId);

    if (success) {
      print("✅ Item removed successfully");
      await loadCartAndSummary();
    } else {
      print("❌ Failed to remove item");
    }

    isUpdating = false;
    notifyListeners();
  }

  /// ================= CLEAR CART =================
  Future<void> clearCart() async {
    print("🗑️ Clearing entire cart");

    isLoading = true;
    notifyListeners();

    for (var item in List.from(cartItems)) {
      await _api.removeFromCart(item.id);
    }

    _cart?.items.clear();
    summary = null;

    isLoading = false;
    notifyListeners();

    print("✅ Cart cleared");
  }

  /// ================= PLACE ORDER =================
  Future<bool> placeOrder() async {
    if (deliveryAddress.isEmpty) return false;

    final success = await _api.checkout(
      address: deliveryAddress,
      slot: deliverySlot,
      paymentMethod: paymentMethod,
      lat: 25.45345,
      lng: 80.46786,
    );

    if (success) {
      _cart?.items.clear();
      summary = null;
      notifyListeners();
    }

    return success;
  }

  /// ================= FETCH LOCATION =================
  Future<void> fetchCurrentAddress() async {
    try {
      isLoading = true;
      notifyListeners();

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        isLoading = false;
        notifyListeners();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        deliveryAddress =
            "${p.street}, ${p.subLocality}, ${p.locality}, ${p.postalCode}";
      }
    } catch (e) {
      debugPrint("❌ Location error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
