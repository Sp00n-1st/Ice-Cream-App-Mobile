class CartModel {
  String uidUser, time;
  List<String> idProduct;
  List<int> qty;
  List<num> total, discount, subTotal, price;
  bool isDone, isTake, isReady;
  CartModel(
      {required this.uidUser,
      required this.idProduct,
      required this.price,
      required this.qty,
      required this.isDone,
      required this.isTake,
      required this.isReady,
      required this.time,
      required this.total,
      required this.discount,
      required this.subTotal});

  CartModel.fromJson(Map<String, dynamic>? json)
      : this(
            uidUser: json!['uid_user'] as String,
            idProduct: (json['id_product'] as List).cast<String>(),
            qty: (json['qty'] as List).cast<int>(),
            isDone: json['isDone'] as bool,
            isTake: json['isTake'] as bool,
            isReady: json['isReady'] as bool,
            time: json['time'] as String,
            total: (json['total'] as List).cast<num>(),
            price: (json['price'] as List).cast<num>(),
            subTotal: (json['subTotal'] as List).cast<num>(),
            discount: (json['discount'] as List).cast<num>());
  Map<String, Object?> toJson() {
    return {
      'uidUser': uidUser,
      'idProduct': idProduct,
      'qty': qty,
      'isDone': isDone,
      'isTake': isTake,
      'isReady': isReady,
      'time': time,
      'total': total,
      'subTotal': subTotal,
      'discount': discount,
      'price': price
    };
  }
}
