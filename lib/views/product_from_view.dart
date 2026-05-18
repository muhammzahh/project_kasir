import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_toko/models/produk_model.dart.dart';
import 'package:project_toko/services/produk_service.dart';
import 'package:project_toko/services/url.dart';
import 'package:project_toko/widget/alert.dart';

class ProdukFormView extends StatefulWidget {
  // item != null → mode Update, item == null → mode Insert
  final ProdukModel? item;

  const ProdukFormView({super.key, this.item});

  @override
  State<ProdukFormView> createState() => _ProdukFormViewState();
}

class _ProdukFormViewState extends State<ProdukFormView> {
  final ProdukServices produkServices = ProdukServices();
  final formKey = GlobalKey<FormState>(); // Bukti keamanan: FormKey

  final TextEditingController namaCtrl = TextEditingController();
  final TextEditingController hargaCtrl = TextEditingController();
  final TextEditingController stokCtrl = TextEditingController();
  final TextEditingController deskripsiCtrl = TextEditingController();

  File? selectedImage; // gambar baru dari galeri
  bool isLoading = false;

  // Cek apakah mode update
  bool get isUpdate => widget.item != null;

  @override
  void initState() {
    super.initState();
    // Jika mode update, isi form dengan data lama
    if (isUpdate) {
      namaCtrl.text = widget.item!.namaBarang;
      hargaCtrl.text = widget.item!.harga.toStringAsFixed(0);
      stokCtrl.text = widget.item!.stok.toString();
      deskripsiCtrl.text = widget.item!.deskripsi ?? "";
    }
  }

  @override
  void dispose() {
    namaCtrl.dispose();
    hargaCtrl.dispose();
    stokCtrl.dispose();
    deskripsiCtrl.dispose();
    super.dispose();
  }

  // ===== PILIH GAMBAR DARI GALERI =====
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() => selectedImage = File(pickedFile.path));
    }
  }

  // ===== SIMPAN (INSERT / UPDATE) =====
  Future<void> handleSave() async {
    // FormKey: validasi dulu sebelum simpan
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final result = await produkServices.simpanProduk(
      id: isUpdate ? widget.item!.id : null,
      nama: namaCtrl.text,
      harga: hargaCtrl.text,
      stok: stokCtrl.text,
      deskripsi: deskripsiCtrl.text,
      foto: selectedImage,
    );

    if (!mounted) return;
    setState(() => isLoading = false);

    AlertMessage().showAlert(
      context,
      result.message ?? (isUpdate ? "Produk diperbarui" : "Produk ditambahkan"),
      result.status,
    );

    if (result.status) {
      await Future.delayed(const Duration(milliseconds: 900));
      if (mounted) Navigator.pop(context, true); // kirim true → trigger refresh
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181A20),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181A20),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          isUpdate ? "Edit Produk" : "Tambah Produk",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              // ===== PREVIEW GAMBAR =====
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F222A),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: _buildImagePreview(),
                ),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: pickImage,
                icon: const Icon(Icons.photo_library, color: Color(0xFFE50914)),
                label: const Text(
                  "Pilih Foto dari Galeri",
                  style: TextStyle(color: Color(0xFFE50914)),
                ),
              ),

              const SizedBox(height: 16),

              // ===== FORM FIELDS =====
              _buildField(
                controller: namaCtrl,
                hint: "Nama Barang",
                icon: Icons.inventory_2_outlined,
                validator: (v) => v!.isEmpty ? "Nama barang wajib diisi" : null,
              ),
              const SizedBox(height: 14),
              _buildField(
                controller: hargaCtrl,
                hint: "Harga",
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Harga wajib diisi" : null,
              ),
              const SizedBox(height: 14),
              _buildField(
                controller: stokCtrl,
                hint: "Stok",
                icon: Icons.layers_outlined,
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Stok wajib diisi" : null,
              ),
              const SizedBox(height: 14),
              _buildField(
                controller: deskripsiCtrl,
                hint: "Deskripsi (opsional)",
                icon: Icons.description_outlined,
                maxLines: 3,
              ),

              const SizedBox(height: 28),

              // ===== TOMBOL SIMPAN =====
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading ? null : handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE50914),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          isUpdate ? "SIMPAN PERUBAHAN" : "TAMBAH PRODUK",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== PREVIEW GAMBAR (galeri baru / url lama / placeholder) =====
  Widget _buildImagePreview() {
    if (selectedImage != null) {
      // Gambar baru dari galeri
      return Image.file(selectedImage!, fit: BoxFit.cover, width: double.infinity);
    } else if (isUpdate && widget.item!.image != null && widget.item!.image!.isNotEmpty) {
      // Gambar lama dari server
      String imageUrl = Uri.encodeFull("$BaseUrlTanpaAPI/${widget.item!.image}");
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, __, ___) => _imagePlaceholder(),
      );
    } else {
      return _imagePlaceholder();
    }
  }

  Widget _imagePlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.add_photo_alternate_outlined, size: 48, color: Colors.white24),
        SizedBox(height: 8),
        Text("Tap untuk pilih foto", style: TextStyle(color: Colors.white38)),
      ],
    );
  }

  // ===== INPUT FIELD =====
  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        prefixIcon: Icon(icon, color: Colors.white38, size: 20),
        filled: true,
        fillColor: const Color(0xFF1F222A),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE50914), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
      ),
    );
  }
}