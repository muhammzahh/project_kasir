import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_toko/models/response_data_map.dart';
import 'package:project_toko/services/url.dart';

class Pesan {

  // ===== CHECKOUT: POST /user/transaksi =====
  Future<ResponseDataMap> saveToDB(dynamic dataRequest) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token == null || token.isEmpty) {
        return ResponseDataMap(
          status: false,
          message: 'Token tidak ditemukan, silakan login ulang',
        );
      }

      var uri = Uri.parse("$BaseUrl/user/transaksi");

      print("CHECKOUT URL  : $uri");
      print("CHECKOUT BODY : ${json.encode(dataRequest)}");

      var response = await http.post(
        uri,
        body: json.encode(dataRequest),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      ).timeout(const Duration(seconds: 30));

      print("CHECKOUT STATUS : ${response.statusCode}");
      print("CHECKOUT BODY   : ${response.body}");

      if (!response.body.trimLeft().startsWith("{") &&
          !response.body.trimLeft().startsWith("[")) {
        return ResponseDataMap(
          status: false,
          message: "Server error (${response.statusCode}): bukan JSON",
        );
      }

      var data = json.decode(response.body);

      if (response.statusCode == 200 && data["status"] == true) {
        return ResponseDataMap(
          status: true,
          message: data["message"] ?? "Pesanan berhasil diproses",
        );
      } else {
        return ResponseDataMap(
          status: false,
          message: data["message"] ?? "Gagal memproses pesanan",
        );
      }
    } catch (e) {
      print("ERROR CHECKOUT: $e");
      return ResponseDataMap(
        status: false,
        message: "Error: $e",
      );
    }
  }

  // ===== GET HISTORY: GET /user/history_trans =====
  Future<ResponseDataMap> getHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token == null || token.isEmpty) {
        return ResponseDataMap(
          status: false,
          message: 'Token tidak ditemukan, silakan login ulang',
        );
      }

      var uri = Uri.parse("$BaseUrl/user/history_trans");

      print("HISTORY URL : $uri");

      var response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      ).timeout(const Duration(seconds: 30));

      print("HISTORY STATUS : ${response.statusCode}");
      print("HISTORY BODY   : ${response.body}");

      if (!response.body.trimLeft().startsWith("{") &&
          !response.body.trimLeft().startsWith("[")) {
        return ResponseDataMap(
          status: false,
          message: "Server error: bukan JSON response",
        );
      }

      var data = json.decode(response.body);

      if (response.statusCode == 200 && data["status"] == true) {
        return ResponseDataMap(
          status: true,
          message: data["message"] ?? "success",
          data: data["data"],
        );
      } else {
        return ResponseDataMap(
          status: false,
          message: data["message"] ?? "Gagal memuat history",
        );
      }
    } catch (e) {
      print("ERROR HISTORY: $e");
      return ResponseDataMap(
        status: false,
        message: "Error: $e",
      );
    }
  }
}