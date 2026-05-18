import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'package:project_toko/models/cart.dart';

class DBHelper {
  static Database? _database;

  // ===== KONEKSI DATABASE =====
  Future<Database?> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database;
  }

  // ===== INISIALISASI DATABASE =====
  initDatabase() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'cart.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  // ===== BUAT TABEL CART =====
  _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE IF NOT EXISTS cart('
      'id INTEGER PRIMARY KEY, '
      'id_produk VARCHAR, '
      'title TEXT, '
      'harga DOUBLE, '
      'deskripsi TEXT, '
      'quantity INTEGER, '
      'image TEXT'
      ')',
    );
  }

  // ===== INSERT DATA =====
  Future<Cart> insert(Cart cart) async {
    var dbClient = await database;
    if (dbClient != null) {
      await dbClient.insert(
        'cart',
        cart.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return cart;
    } else {
      return cart;
    }
  }

  // ===== GET SEMUA CART =====
  Future<List<Cart>> getCartList() async {
    try {
      var dbClient = await database;
      final List<Map<String, Object?>> queryResult =
          await dbClient!.query('cart');
      return queryResult.map((result) => Cart.fromMap(result)).toList();
    } catch (e) {
      return [];
    }
  }

  // ===== GET DETAIL CART BERDASARKAN ID =====
  Future getCartListDetail(id) async {
    try {
      var dbClient = await database;
      final queryResult = await dbClient!.query(
        'cart',
        where: 'id = ?',
        whereArgs: [id],
      );
      return queryResult.map((result) => Cart.fromMap(result)).toList();
    } catch (e) {
      return null;
    }
  }

  // ===== UPDATE QUANTITY =====
  Future<int> updateQuantity(id, qty) async {
    var dbClient = await database;
    return await dbClient!.update(
      'cart',
      {"quantity": qty},
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // ===== HAPUS ITEM =====
  Future<int> deleteCartItem(int id) async {
    var dbClient = await database;
    return await dbClient!.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

  // ===== KOSONGKAN SEMUA CART =====
  Future<void> clearCart() async {
    var dbClient = await database;
    await dbClient!.delete('cart');
  }
}