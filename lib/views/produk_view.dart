import 'package:flutter/material.dart';
import 'package:project_toko/models/produk_model.dart.dart';
import 'package:project_toko/models/response_data_list.dart';
import 'package:project_toko/services/produk_service.dart';
import 'package:project_toko/services/url.dart';
import 'package:project_toko/widget/battom_nav.dart';
import 'package:project_toko/views/product_from_view.dart';

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

  Future<void> showDeleteDialog(ProdukModel item) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1F222A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Hapus Produk",
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          "Yakin ingin menghapus \"${item.namaBarang}\"?",
          style: const TextStyle(color: Colors.white60),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal",
                style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await deleteProduct(item.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE50914),
            ),
            child: const Text("Hapus",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> deleteProduct(int id) async {
    final result = await produkServices.hapusProduk(id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.message ?? ""),
        backgroundColor:
            result.status ? Colors.green : const Color(0xFFE50914),
      ),
    );
    if (result.status) {
      setState(() => isLoading = true);
      getProduk();
    }
  }

  Future<void> goToForm({ProdukModel? item}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProdukFormView(item: item)),
    );
    if (result == true) {
      setState(() => isLoading = true);
      getProduk();
    }
  }

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
      floatingActionButton: FloatingActionButton(
        onPressed: () => goToForm(),
        backgroundColor: const Color(0xFFE50914),
        child: const Icon(Icons.add, color: Colors.white),
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
                      Icon(Icons.inventory_2_outlined,
                          size: 64, color: Colors.white24),
                      const SizedBox(height: 16),
                      const Text(
                        "Produk tidak tersedia",
                        style: TextStyle(color: Colors.white60, fontSize: 16),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  itemCount: produk.length,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.58,
                  ),
                  itemBuilder: (context, index) {
                    return _productCard(produk[index]);
                  },
                ),

      // ===== BOTTOM NAV index 1 = Produk (hanya admin yg punya menu ini) =====
      bottomNavigationBar: BottomNav(1),
    );
  }

  Widget _productCard(ProdukModel item) {
    String imageUrl = Uri.encodeFull("$BaseUrlTanpaAPI/${item.image ?? ''}");

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F222A),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
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
                          child: const Icon(Icons.broken_image,
                              color: Colors.white24, size: 40),
                        );
                      },
                    )
                  : Container(
                      color: const Color(0xFF2A2D35),
                      child: const Center(
                        child: Icon(Icons.image,
                            color: Colors.white24, size: 40),
                      ),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.namaBarang,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  rupiah(item.harga.toDouble()),
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: Color(0xFFE50914),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.layers_outlined,
                        size: 12, color: Colors.white38),
                    const SizedBox(width: 4),
                    Text(
                      "Stok: ${item.stok}",
                      style: const TextStyle(
                          fontSize: 11, color: Colors.white38),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => goToForm(item: item),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE50914)),
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Edit",
                      style: TextStyle(fontSize: 11, color: Color(0xFFE50914)),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => showDeleteDialog(item),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE50914),
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Hapus",
                      style: TextStyle(fontSize: 11, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}