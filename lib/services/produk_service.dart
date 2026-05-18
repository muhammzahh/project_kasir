import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/produk_model.dart.dart';
import '../models/response_data_list.dart';
import '../models/response_data_map.dart';
import '../models/user_login.dart';
import 'url.dart';

class ProdukServices {

  // ================= GET PRODUK =================
  // Admin  → GET /admin/getbarang
  // Kasir  → GET /user/getbarang  (sesuai pola modul: /user/...)
  Future<ResponseDataList> getProduk() async {
    try {
      UserLogin userLoginModel = UserLogin();
      var user = await userLoginModel.getUserLogin();

      if (user.status == false) {
        return ResponseDataList(
          status: false,
          message: 'Anda belum login / token invalid',
        );
      }

      String endpoint;
      if (user.role == "admin") {
        endpoint = "$BaseUrl/admin/getbarang";
      } else {
        endpoint = "$BaseUrl/user/getbarang"; // kasir/user
      }

      print("GET PRODUK URL : $endpoint");
      print("ROLE           : ${user.role}");

      var uri = Uri.parse(endpoint);
      var response = await http.get(uri, headers: {
        "Authorization": "Bearer ${user.token}",
        "Accept": "application/json",
      }).timeout(const Duration(seconds: 30));

      print("GET STATUS : ${response.statusCode}");
      print("GET BODY   : ${response.body}");

      if (!response.body.trimLeft().startsWith("{")) {
        return ResponseDataList(
          status: false,
          message: "Server tidak mengirim JSON",
        );
      }

      var jsonData = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonData["status"] == true) {
        List<ProdukModel> produk = (jsonData["data"] as List)
            .map((e) => ProdukModel.fromJson(e))
            .toList();
        return ResponseDataList(
          status: true,
          message: jsonData["message"],
          data: produk,
        );
      }
      return ResponseDataList(
        status: false,
        message: jsonData["message"],
      );
    } catch (e) {
      return ResponseDataList(status: false, message: "Error: $e");
    }
  }

  // ================= CREATE & UPDATE (admin only) =================
  Future<ResponseDataMap> simpanProduk({
    required String nama,
    required String harga,
    required String stok,
    required String deskripsi,
    File? foto,
    int? id,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      Uri uri = id == null
          ? Uri.parse("$BaseUrl/admin/insertbarang")
          : Uri.parse("$BaseUrl/admin/updatebarang/$id");

      var request = http.MultipartRequest("POST", uri);
      request.headers.addAll({
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      });

      request.fields["nama_barang"] = nama;
      request.fields["harga"] = harga;
      request.fields["stok"] = stok;
      request.fields["deskripsi"] = deskripsi;

      if (foto != null) {
        request.files.add(
          await http.MultipartFile.fromPath("image", foto.path),
        );
      }

      var streamed = await request.send().timeout(const Duration(seconds: 30));
      var response = await http.Response.fromStream(streamed);

      if (!response.body.trimLeft().startsWith("{")) {
        return ResponseDataMap(
          status: false,
          message: "Server tidak mengirim JSON",
        );
      }

      var jsonData = jsonDecode(response.body);
      return ResponseDataMap(
        status: jsonData["status"] ?? false,
        message: jsonData["message"] ?? "",
        data: jsonData,
      );
    } catch (e) {
      return ResponseDataMap(status: false, message: "Error: $e");
    }
  }

  // ================= DELETE (admin only) =================
  Future<ResponseDataMap> hapusProduk(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      var uri = Uri.parse("$BaseUrl/admin/hapusbarang/$id");
      var response = await http.delete(uri, headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      }).timeout(const Duration(seconds: 15));

      if (!response.body.trimLeft().startsWith("{")) {
        return ResponseDataMap(
          status: false,
          message: "Server tidak mengirim JSON",
        );
      }

      var jsonData = jsonDecode(response.body);
      return ResponseDataMap(
        status: jsonData["status"] ?? false,
        message: jsonData["message"] ?? "",
      );
    } catch (e) {
      return ResponseDataMap(status: false, message: "Error: $e");
    }
  }
}