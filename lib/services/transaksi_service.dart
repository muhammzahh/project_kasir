import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/response_data_map.dart';
import 'url.dart';

class TransaksiService {
  // ===== CHECKOUT =====
  // Kirim list cart ke server sebagai JSON
  Future<ResponseDataMap> checkout(List<Map<String, dynamic>> cartItems) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      int? userId = prefs.getInt("id");

      var uri = Uri.parse("$BaseUrl/kasir/transaksi");

      var response = await http.post(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "id_user": userId,
          "items": cartItems,
        }),
      ).timeout(const Duration(seconds: 30));

      print("CHECKOUT STATUS : ${response.statusCode}");
      print("CHECKOUT BODY   : ${response.body}");

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

  // ===== GET HISTORY TRANSAKSI =====
  Future<ResponseDataMap> getHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      var uri = Uri.parse("$BaseUrl/kasir/history");

      var response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ).timeout(const Duration(seconds: 15));

      print("HISTORY STATUS : ${response.statusCode}");
      print("HISTORY BODY   : ${response.body}");

      var jsonData = jsonDecode(response.body);

      return ResponseDataMap(
        status: jsonData["status"] ?? false,
        message: jsonData["message"] ?? "",
        data: jsonData["data"],
      );
    } catch (e) {
      return ResponseDataMap(status: false, message: "Error: $e");
    }
  }
}