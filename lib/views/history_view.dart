import 'package:flutter/material.dart';
import 'package:project_toko/services/pesan.dart';
import 'package:project_toko/widget/battom_nav.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  List? historyList;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    var result = await Pesan().getHistory();
    if (!mounted) return;
    setState(() {
      // Struktur response: [{id_transaksi, nama_user, tgl_transaksi, detail:[{...}]}]
      historyList = result.status == true ? (result.data as List?) : [];
      isLoading = false;
    });
  }

  // ===== FORMAT RUPIAH =====
  String rupiah(dynamic value) {
    double val = double.parse(value.toString());
    return "Rp ${val.toStringAsFixed(0).replaceAllMapped(
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
        foregroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "History Transaksi",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFE50914)),
            )
          : historyList == null || historyList!.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, size: 64, color: Colors.white24),
                      SizedBox(height: 16),
                      Text(
                        "Belum ada transaksi",
                        style:
                            TextStyle(color: Colors.white60, fontSize: 16),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  color: const Color(0xFFE50914),
                  onRefresh: loadHistory,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: historyList!.length,
                    itemBuilder: (context, index) {
                      final trx = historyList![index];

                      // ===== STRUKTUR RESPONSE DARI SERVER =====
                      // {
                      //   "id_transaksi": 521,
                      //   "nama_user": "sugeng",
                      //   "tgl_transaksi": "2026-05-08",
                      //   "detail": [
                      //     {
                      //       "id_detail_transaksi": 387,
                      //       "barang_id": 155,
                      //       "nama_barang": "vgbfdcjmcmdcmi",
                      //       "quantity": 2,
                      //       "harga_beli": 4000
                      //     }
                      //   ]
                      // }
                      final detailList = trx['detail'] as List? ?? [];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1F222A),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ===== HEADER =====
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom:
                                      BorderSide(color: Colors.white10),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        trx['nama_user'] ?? '-',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        trx['tgl_transaksi'] ?? '-',
                                        style: const TextStyle(
                                          color: Colors.white38,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2A1518),
                                      borderRadius:
                                          BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      "Selesai",
                                      style: TextStyle(
                                        color: Color(0xFFE50914),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // ===== DETAIL ITEM =====
                            detailList.isEmpty
                                ? const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Text(
                                      "Tidak ada detail transaksi",
                                      style: TextStyle(
                                          color: Colors.white38,
                                          fontSize: 12),
                                    ),
                                  )
                                : Column(
                                    children: detailList.map((item) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                children: [
                                                  Text(
                                                    item['nama_barang'] ??
                                                        '-',
                                                    style: const TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    "Qty: ${item['quantity'] ?? 0}",
                                                    style: const TextStyle(
                                                      color: Colors.white38,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              rupiah(item['harga_beli'] ??
                                                  0),
                                              style: const TextStyle(
                                                color: Color(0xFFE50914),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),

                            const SizedBox(height: 8),
                          ],
                        ),
                      );
                    },
                  ),
                ),

      bottomNavigationBar: BottomNav(2),
    );
  }
}