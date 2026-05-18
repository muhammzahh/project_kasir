import 'package:flutter/material.dart';
import 'package:project_toko/models/cart.dart';
import 'package:project_toko/services/DBHelper.dart';

class CartProvider extends ChangeNotifier {
  int counter = 0;
  DBHelper dBHelper = DBHelper();
  List<Cart> cart = [];

  // ===== AMBIL DATA DARI SQLITE =====
  Future<List<Cart>> getData() async {
    cart = await dBHelper.getCartList();
    notifyListeners();
    return cart;
  }

  // ===== TAMBAH COUNTER =====
  void addCounter() {
    getData();
    counter = cart.length;
    notifyListeners();
  }

  // ===== KURANGI COUNTER =====
  void removeCounter() {
    counter--;
    counter = cart.length;
    notifyListeners();
  }

  // ===== GET COUNTER =====
  void getCounter() {
    getData();
    counter = cart.length;
    notifyListeners();
  }

  // ===== TAMBAH QUANTITY =====
  void addQuantity(int id) async {
    final index = cart.indexWhere((element) => element.id == id);
    cart[index].quantity = cart[index].quantity! + 1;
    await dBHelper.updateQuantity(
      cart[index].id.toString(),
      cart[index].quantity,
    );
    notifyListeners();
  }

  // ===== KURANGI QUANTITY =====
  void deleteQuantity(int id) async {
    final index = cart.indexWhere((element) => element.id == id);
    final currentQuantity = cart[index].quantity!;
    if (currentQuantity > 1) {
      cart[index].quantity = currentQuantity - 1;
    }
    await dBHelper.updateQuantity(
      cart[index].id.toString(),
      cart[index].quantity,
    );
    notifyListeners();
  }

  // ===== HAPUS ITEM DARI LIST =====
  void removeItem(int id) {
    final index = cart.indexWhere((element) => element.id == id);
    cart.removeAt(index);
    notifyListeners();
  }
}