class Cart {
  late final int? id;
  final String? id_produk;
  final String? title;
  final double? harga;
  final String? deskripsi;
  int? quantity = 0;
  final String? image;

  Cart({
    required this.id,
    required this.id_produk,
    required this.title,
    required this.harga,
    required this.deskripsi,
    required this.quantity,
    required this.image,
  });

  factory Cart.fromMap(Map<dynamic, dynamic> data) {
    return Cart(
      id: data['id'],
      id_produk: data['id_produk'].toString(),
      title: data['title'],
      harga: double.parse(data['harga'].toString()),
      deskripsi: data['deskripsi'],
      quantity: data['quantity'],
      image: data['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_produk': id_produk,
      'title': title,
      'harga': harga,
      'deskripsi': deskripsi,
      'quantity': quantity,
      'image': image,
    };
  }
}