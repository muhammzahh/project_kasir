import 'package:flutter/material.dart';
import 'package:project_toko/models/produk_model.dart.dart';
import 'package:project_toko/models/response_data_list.dart';
import 'package:project_toko/services/produk_service.dart';
import 'package:project_toko/services/url.dart';
import 'package:project_toko/widget/battom_nav.dart';

class ProdukView extends StatefulWidget {
  const ProdukView({super.key});

  @override
  State<ProdukView> createState() => _ProdukViewState();
}

class _ProdukViewState extends State<ProdukView> {
  final ProdukServices produkServices = ProdukServices();

  List<ProdukModel> produk = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getProduk();
  }

  Future<void> getProduk() async {
    try {
      ResponseDataList response = await produkServices.getProduk();

      if (!mounted) return;

      if (response.status == true) {
        setState(() {
          produk = response.data as List<ProdukModel>;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? "Terjadi kesalahan"),
            backgroundColor: const Color(0xFFE50914),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }

  String rupiah(double value) {
    return "Rp ${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => "${m[1]}.")}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181A20), // Tema Dark
      appBar: AppBar(
        backgroundColor: const Color(0xFF181A20),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Daftar Produk",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFE50914)),
            )
          : produk.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 64, color: Colors.white24),
                      const SizedBox(height: 16),
                      const Text(
                        "Produk tidak tersedia",
                        style: TextStyle(color: Colors.white60, fontSize: 16),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: produk.length,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.68,
                  ),
                  itemBuilder: (context, index) {
                    return _productCard(produk[index]);
                  },
                ),
      bottomNavigationBar: BottomNav(1),
    );
  }

  Widget _productCard(ProdukModel item) {
    String imageUrl = "$BaseUrlTanpaAPI/${item.image ?? ''}";
    imageUrl = Uri.encodeFull(imageUrl);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F222A), // Card dark color
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= IMAGE =================
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: item.image != null && item.image!.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: const Color(0xFF2A2D35),
                            child: const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFFE50914),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFF2A2D35),
                            child: const Icon(Icons.broken_image, color: Colors.white24, size: 40),
                          );
                        },
                      )
                    : Container(
                        color: const Color(0xFF2A2D35),
                        child: const Center(child: Icon(Icons.image, color: Colors.white24, size: 40)),
                      ),
              ),
            ),

            // ================= INFO =================
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.namaBarang,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    rupiah(item.harga.toDouble()),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: Color(0xFFE50914),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.layers_outlined, size: 14, color: Colors.white38),
                      const SizedBox(width: 4),
                      Text(
                        "Stok: ${item.stok}",
                        style: const TextStyle(fontSize: 12, color: Colors.white38),
                      ),
                    ],
                  ),
                  if (item.deskripsi != null && item.deskripsi!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        item.deskripsi!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white24,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}