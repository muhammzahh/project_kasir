import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:project_toko/controllers/cartProvider.dart';
import 'package:project_toko/services/DBHelper.dart';
import 'package:project_toko/services/pesan.dart';
import 'package:project_toko/services/url.dart';
import 'package:project_toko/widget/alert.dart';
import 'package:project_toko/widget/tombol_plus_minus.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper dBHelper = DBHelper();
  CartProvider cartProvider = CartProvider();

  void updateCount() async {
    await cartProvider.getData();
    if (!mounted) return;
    setState(() {
      cartProvider.counter = cartProvider.cart.length;
    });
  }

  @override
  void initState() {
    super.initState();
    updateCount();
  }

  // ===== FORMAT RUPIAH =====
  String rupiah(double value) {
    return "Rp ${value.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => "${m[1]}.",
        )}";
  }

  // ===== PROSES CHECKOUT =====
  Future<void> handleCheckout() async {
    if (cartProvider.cart.isEmpty) {
      AlertMessage()
          .showAlert(context, "Keranjang masih kosong!", false);
      return;
    }

    // ===== FORMAT BODY SESUAI POSTMAN =====
    // {"pesan": [{"movie_id": x, "qty": x}]}
    // Disesuaikan ke produk:
    // {"pesan": [{"id_produk": x, "qty": x}]}
    List dataList = cartProvider.cart.map((i) {
      return {
        "barang_id": i.id_produk,
        "qty": i.quantity,
      };
    }).toList();

    var data = {"pesan": dataList};

    print("DATA CHECKOUT: $data");

    var result = await Pesan().saveToDB(data);

    if (!mounted) return;

    if (result.status == true) {
      AlertMessage().showAlert(context, result.message ?? "Checkout berhasil", true);
      // Kosongkan cart setelah checkout berhasil
      await dBHelper.clearCart();
      await cartProvider.getData();
      if (!mounted) return;
      // Navigasi ke history (Remove Until semua route)
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/history',
        (Route<dynamic> route) => false,
      );
    } else {
      AlertMessage().showAlert(context, result.message ?? "gagal", false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181A20),
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: const Color(0xFF181A20),
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Cart',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          badges.Badge(
            badgeContent: ListenableBuilder(
              listenable: cartProvider,
              builder: (context, child) {
                return Text(
                  cartProvider.cart.isEmpty
                      ? '0'
                      : '${cartProvider.counter}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                );
              },
            ),
            badgeStyle: const badges.BadgeStyle(
              badgeColor: Color(0xFFE50914),
            ),
            position: badges.BadgePosition.topEnd(top: 0, end: 2),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
            ),
          ),
          const SizedBox(width: 20.0),
        ],
      ),

      // ===== BODY =====
      body: Column(
        children: [
          Expanded(
            child: ListenableBuilder(
              listenable: cartProvider,
              builder: (context, child) {
                if (cartProvider.cart.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined,
                            size: 64, color: Colors.white24),
                        SizedBox(height: 16),
                        Text(
                          'Keranjang masih kosong',
                          style: TextStyle(
                            color: Colors.white60,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cartProvider.cart.length,
                  itemBuilder: (context, index) {
                    final item = cartProvider.cart[index];
                    String imageUrl = Uri.encodeFull(
                        "$BaseUrlTanpaAPI/${item.image ?? ''}");

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F222A),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Row(
                        children: [
                          // ===== GAMBAR =====
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: item.image != null &&
                                    item.image!.isNotEmpty
                                ? Image.network(
                                    imageUrl,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        Container(
                                      width: 70,
                                      height: 70,
                                      color: const Color(0xFF2A2D35),
                                      child: const Icon(Icons.image,
                                          color: Colors.white24,
                                          size: 30),
                                    ),
                                  )
                                : Container(
                                    width: 70,
                                    height: 70,
                                    color: const Color(0xFF2A2D35),
                                    child: const Icon(Icons.image,
                                        color: Colors.white24, size: 30),
                                  ),
                          ),
                          const SizedBox(width: 12),

                          // ===== NAMA & HARGA =====
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title ?? '-',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  rupiah(item.harga ?? 0),
                                  style: const TextStyle(
                                    color: Color(0xFFE50914),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // ===== TOMBOL +/- =====
                          PlusMinusButtons(
                            addQuantity: () {
                              cartProvider.addQuantity(item.id!);
                            },
                            deleteQuantity: () {
                              cartProvider.deleteQuantity(item.id!);
                            },
                            text: item.quantity.toString(),
                          ),

                          // ===== TOMBOL HAPUS =====
                          IconButton(
                            onPressed: () async {
                              await dBHelper
                                  .deleteCartItem(item.id!);
                              cartProvider.removeItem(item.id!);
                              cartProvider.removeCounter();
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red.shade600,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      // ===== TOMBOL CHECKOUT =====
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFE50914),
        foregroundColor: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18)),
        onPressed: handleCheckout,
        icon: const Icon(Icons.shopping_cart_checkout_rounded),
        label: const Text(
          "Checkout",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}