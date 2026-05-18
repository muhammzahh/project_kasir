import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:project_toko/controllers/cartProvider.dart';
import 'package:project_toko/models/cart.dart';
import 'package:project_toko/services/DBHelper.dart';
import 'package:project_toko/services/produk_service.dart';
import 'package:project_toko/services/url.dart';
import 'package:project_toko/widget/battom_nav.dart';

class TransaksiView extends StatefulWidget {
  const TransaksiView({super.key});

  @override
  State<TransaksiView> createState() => _TransaksiViewState();
}

class _TransaksiViewState extends State<TransaksiView> {
  DBHelper dBHelper = DBHelper();
  CartProvider cartProvider = CartProvider();

  List? produk;

  // ===== AMBIL DATA PRODUK DARI API =====
  Future<void> getProduk() async {
    var result = await ProdukServices().getProduk();
    if (!mounted) return;
    setState(() {
      produk = result.data;
    });
  }

  // ===== UPDATE COUNTER BADGE =====
  Future<void> updateCount() async {
    await cartProvider.getData();
    if (!mounted) return;
    setState(() {
      cartProvider.counter = cartProvider.cart.length;
    });
  }

  // ===== SIMPAN KE SQLITE =====
  Future<void> saveData(int index) async {
    var detail = await dBHelper.getCartListDetail(produk![index].id);
    var qty = 0;
    if (detail != null && detail.length > 0) {
      qty = detail[0].quantity;
    }

    await dBHelper.insert(
      Cart(
        id: produk![index].id,
        id_produk: produk![index].id.toString(),
        title: produk![index].namaBarang,
        harga: produk![index].harga,
        deskripsi: produk![index].deskripsi ?? '',
        quantity: qty + 1,
        image: produk![index].image,
      ),
    );

    updateCount();
    print('Produk ditambahkan ke cart');
  }

  @override
  void initState() {
    super.initState();
    getProduk();
    updateCount();
  }

  // ===== FORMAT RUPIAH =====
  String rupiah(double value) {
    return "Rp ${value.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => "${m[1]}.",
        )}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181A20),
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: const Color(0xFF181A20),
        foregroundColor: Colors.white,
        title: const Text(
          'Pesan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // ===== BADGE KERANJANG =====
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
              onPressed: () async {
                await Navigator.pushNamed(context, '/cartScreen');
                updateCount();
              },
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
            ),
          ),
          const SizedBox(width: 20.0),
        ],
      ),

      // ===== BODY: DAFTAR PRODUK =====
      body: produk != null
          ? ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: produk!.length,
              itemBuilder: (context, index) {
                String imageUrl = Uri.encodeFull(
                    "$BaseUrlTanpaAPI/${produk![index].image ?? ''}");

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
                        borderRadius: BorderRadius.circular(10),
                        child: produk![index].image != null &&
                                produk![index].image!.isNotEmpty
                            ? Image.network(
                                imageUrl,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 70,
                                  height: 70,
                                  color: const Color(0xFF2A2D35),
                                  child: const Icon(Icons.image,
                                      color: Colors.white24, size: 30),
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

                      // ===== INFO PRODUK =====
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              produk![index].namaBarang,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              rupiah(produk![index].harga),
                              style: const TextStyle(
                                color: Color(0xFFE50914),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Stok: ${produk![index].stok}",
                              style: const TextStyle(
                                  color: Colors.white38, fontSize: 11),
                            ),
                          ],
                        ),
                      ),

                      // ===== TOMBOL ADD TO CART =====
                      GestureDetector(
                        onTap: () => saveData(index),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE50914),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.add_shopping_cart,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(color: Color(0xFFE50914)),
            ),

      // ===== BOTTOM NAV index 1 = Pesan =====
      bottomNavigationBar: BottomNav(1),
    );
  }
}