import 'package:flutter/material.dart';
import 'package:project_toko/widget/battom_nav.dart';

class TransaksiView extends StatefulWidget {
  const TransaksiView({super.key});

  @override
  State<TransaksiView> createState() => _TransaksiViewState();
}

class _TransaksiViewState extends State<TransaksiView> {
  // ===== DUMMY DATA PESANAN SELESAI =====
  final List<Map<String, dynamic>> orders = [
    {
      "store": "Samsara OneStop",
      "status": "Selesai",
      "product": "Kartu Printable Inkjet ID Card Blueprint",
      "variant": "Isi 50",
      "qty": 2,
      "price": 53998,
      "image": "https://picsum.photos/200",
    },
    {
      "store": "Global Kartu",
      "status": "Selesai",
      "product": "Lanyard Printing Custom",
      "variant": "2 cm, 2 sisi",
      "qty": 65,
      "price": 9100,
      "image": "https://picsum.photos/201",
    },
  ];

  // ===== FORMAT RUPIAH =====
  String rupiah(int value) {
    return "Rp ${value.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => "${m[1]}.",
        )}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181A20), // Tema Dark

      // ===== APP BAR =====
      appBar: AppBar(
        backgroundColor: const Color(0xFF181A20),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Pesanan Saya",
          style: TextStyle(
            color: Color(0xFFE50914),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // ===== BODY =====
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final item = orders[index];
          final total = item['price'] * item['qty'];

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1F222A), // Card Dark
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10, width: 1),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== HEADER TOKO =====
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item['store'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      item['status'],
                      style: const TextStyle(
                        color: Color(0xFFE50914),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const Divider(color: Colors.white12, height: 20),

                // ===== PRODUK =====
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item['image'],
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['product'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['variant'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white54,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "${item['qty']} x ${rupiah(item['price'])}",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white60,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ===== TOTAL =====
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Total ${item['qty']} produk: ${rupiah(total)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ===== ACTION BUTTON =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFE50914)),
                      ),
                      child: const Text(
                        "Lihat Penilaian",
                        style: TextStyle(color: Color(0xFFE50914)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE50914),
                      ),
                      child: const Text(
                        "Beli Lagi",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),

      // ===== BOTTOM NAV =====
      bottomNavigationBar: BottomNav(1),
    );
  }
}