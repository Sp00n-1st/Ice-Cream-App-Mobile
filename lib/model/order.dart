import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String uidUser;
  List<String> idProduct;
  List<int> qty;
  List<num> total, discount, subTotal, price;
  bool isTake, isReady;
  int time;
  Timestamp date;
  List<bool> available;
  OrderModel(
      {required this.uidUser,
      required this.idProduct,
      required this.price,
      required this.qty,
      required this.isTake,
      required this.isReady,
      required this.time,
      required this.total,
      required this.discount,
      required this.subTotal,
      required this.date,
      required this.available});

  OrderModel.fromJson(Map<String, dynamic>? json)
      : this(
          uidUser: json!['uid_user'] as String,
          idProduct: (json['id_product'] as List).cast<String>(),
          qty: (json['qty'] as List).cast<int>(),
          isTake: json['isTake'] as bool,
          isReady: json['isReady'] as bool,
          time: json['time'] as int,
          total: (json['total'] as List).cast<num>(),
          price: (json['price'] as List).cast<num>(),
          subTotal: (json['subTotal'] as List).cast<num>(),
          discount: (json['discount'] as List).cast<num>(),
          date: json['date'] as Timestamp,
          available: (json['available'] as List).cast<bool>(),
        );
  Map<String, Object?> toJson() {
    return {
      'uidUser': uidUser,
      'idProduct': idProduct,
      'qty': qty,
      'isTake': isTake,
      'isReady': isReady,
      'time': time,
      'total': total,
      'subTotal': subTotal,
      'discount': discount,
      'price': price,
      'date': date,
      'available': available,
    };
  }
}
