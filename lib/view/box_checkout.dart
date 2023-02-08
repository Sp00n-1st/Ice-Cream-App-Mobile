import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'home.dart';
import '../model/cart.dart';
import '../model/product.dart';

// ignore: must_be_immutable
class BoxCheckout extends StatelessWidget {
  double getWidth(BuildContext context) =>
      MediaQuery.of(context).size.width * 1;
  double getHeight(BuildContext context) =>
      MediaQuery.of(context).size.height * 1;
  int cart;
  num price;
  Product product;
  String idProduct;
  BoxCheckout(
      {super.key,
      required this.price,
      required this.cart,
      required this.product,
      required this.idProduct});

  List<String> idProduct2 = <String>[];
  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance.currentUser!.uid;
    num subTotal2;
    num discount2;
    num total2;

    subTotal2 = cart * price;
    discount2 = (cart * price) * 0.10;
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      width: double.infinity,
      height: getHeight(context) / 14,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 3,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal',
                        style: GoogleFonts.roboto(
                            fontSize: getWidth(context) / 30,
                            color: Colors.black,
                            fontWeight: FontWeight.w500)),
                    Text(
                        NumberFormat.currency(locale: 'en', symbol: '£ ')
                            .format(subTotal2),
                        style: GoogleFonts.roboto(
                            fontSize: getWidth(context) / 30,
                            color: Colors.black,
                            fontWeight: FontWeight.w500))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Discount',
                        style: GoogleFonts.roboto(
                            fontSize: getWidth(context) / 30,
                            color: Colors.black,
                            fontWeight: FontWeight.w500)),
                    Text(
                        (cart < 5)
                            ? '0'
                            : NumberFormat.currency(locale: 'en', symbol: '£ ')
                                .format(discount2),
                        style: GoogleFonts.roboto(
                            fontSize: getWidth(context) / 30,
                            color: Colors.black,
                            fontWeight: FontWeight.w500))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total',
                        style: GoogleFonts.roboto(
                            fontSize: getWidth(context) / 30,
                            color: Colors.black,
                            fontWeight: FontWeight.w500)),
                    Text(
                        (cart < 5)
                            ? NumberFormat.currency(locale: 'en', symbol: '£ ')
                                .format(total2 = cart * price)
                            : NumberFormat.currency(locale: 'en', symbol: '£ ')
                                .format(total2 =
                                    (cart * price) - ((cart * price) * 0.10)),
                        style: GoogleFonts.roboto(
                            fontSize: getWidth(context) / 30,
                            color: Colors.black,
                            fontWeight: FontWeight.w500))
                  ],
                ),
              ],
            ),
          ),
          Flexible(
              flex: 1,
              child: Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: ElevatedButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('cart')
                          .doc(auth)
                          .withConverter<CartModel>(
                              fromFirestore: (snapshot, _) =>
                                  CartModel.fromJson(snapshot.data()),
                              toFirestore: (cartModel, _) => cartModel.toJson())
                          .get()
                          .then((DocumentSnapshot<CartModel> documentSnapshot) {
                        if (documentSnapshot.exists) {
                          return add(
                              documentSnapshot.data(),
                              subTotal2,
                              discount2,
                              total2,
                              price,
                              cart,
                              idProduct,
                              auth,
                              context);
                        } else {
                          return addFirst(subTotal2, discount2, total2, price,
                              cart, idProduct, auth, context);
                        }
                      });
                    },
                    child: SizedBox(
                        height: 60,
                        width: 50,
                        child: Icon(
                          CupertinoIcons.cart_fill_badge_plus,
                          size: 35,
                        )),
                  )))
        ],
      ),
    );
  }

  add(
      CartModel? cartModel,
      num subTotal2,
      num discount2,
      num total2,
      num price2,
      int cart,
      String idProduct,
      String auth,
      BuildContext context) async {
    String uidUser = cartModel!.uidUser;
    String timeStorage = cartModel.time;
    List<String> idProductStorage = cartModel.idProduct;
    List<int> qtyStorage = cartModel.qty;
    List<num> priceStorage = cartModel.price;
    List<num> totalStorage = cartModel.total;
    List<num> subTotalStorage = cartModel.subTotal;
    List<num> discountStorage = cartModel.discount;
    bool isDoneStorage = cartModel.isDone;
    bool isTakeStorage = cartModel.isTake;
    bool isReadyStorage = cartModel.isReady;
    if (idProductStorage.contains(idProduct)) {
      showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('Item Already In Cart!'),
            content: Column(
              children: [
                Icon(
                  CupertinoIcons.xmark_circle,
                  size: 70,
                  color: Colors.red,
                ),
                Text(
                    'You Cannot Add This Item To Cart Because Item Was Already In Cart'),
              ],
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              )
            ],
          );
        },
      );
    } else {
      final checkDisc = cart < 5 ? 0 : discount2;
      idProductStorage.add(idProduct);
      qtyStorage.add(cart);
      totalStorage.add(total2);
      subTotalStorage.add(subTotal2);
      discountStorage.add(checkDisc);
      priceStorage.add(price2);

      await addToStorage(
          uidUser,
          timeStorage,
          idProductStorage,
          qtyStorage,
          totalStorage,
          subTotalStorage,
          discountStorage,
          isDoneStorage,
          isTakeStorage,
          isReadyStorage,
          auth,
          priceStorage);
      showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('Item Has Been Added To Cart'),
            content: Icon(
              CupertinoIcons.cart_badge_plus,
              size: 70,
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  Get.offAll(MyHomePage());
                },
                child: Text('OK'),
              )
            ],
          );
        },
      );
    }
  }

  addFirst(num subTotal2, num discount2, num total2, num price, int cart,
      String idProduct, String auth, BuildContext context) async {
    final checkDisc = cart < 5 ? 0 : discount2;
    List<String> idProductStorage = <String>[idProduct];
    List<num> subTotalStorage = <num>[subTotal2];
    List<num> totalStorage = <num>[total2];
    List<num> discountStorage = <num>[checkDisc];
    List<num> qty = <num>[cart];
    List<num> priceStorage = <num>[price];
    final now = DateTime.now();
    final date = DateFormat('yyyyMMddHHmmss').format(now);

    await FirebaseFirestore.instance.collection('cart').doc(auth).set(({
          'uid_user': auth,
          'time': date,
          'id_product': idProductStorage,
          'qty': qty,
          'total': totalStorage,
          'subTotal': subTotalStorage,
          'discount': discountStorage,
          'price': priceStorage,
          'isDone': false,
          'isTake': false,
          'isReady': false
        }));
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Item Has Been Added To Cart'),
          content: Icon(
            CupertinoIcons.cart_badge_plus,
            size: 70,
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Get.offAll(MyHomePage());
              },
              child: Text('OK'),
            )
          ],
        );
      },
    );
  }

  addToStorage(
      String uidUser,
      String timeStorage,
      List<String> idProductStorage,
      List<int> qtyStorage,
      List<num> totalStorage,
      List<num> subTotalStorage,
      List<num> discountStorage,
      bool isDoneStorage,
      bool isTakeStorage,
      bool isReadyStorage,
      String auth,
      List<num> priceStorage) async {
    await FirebaseFirestore.instance.collection('cart').doc(auth).set(({
          'uid_user': uidUser,
          'time': timeStorage,
          'id_product': idProductStorage,
          'qty': qtyStorage,
          'total': totalStorage,
          'subTotal': subTotalStorage,
          'discount': discountStorage,
          'isDone': isDoneStorage,
          'isTake': isTakeStorage,
          'isReady': isReadyStorage,
          'price': priceStorage
        }));
  }
}
