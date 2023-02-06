import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../model/cart.dart';
import 'model_list_view.dart';

// ignore: must_be_immutable
class CartList extends StatelessWidget {
  CartModel? cartModel;
  CartList({required this.cartModel});
  List<Widget> listProduct = <Widget>[];
  List<bool?> available = <bool?>[];
  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    double sizeHeight = MediaQuery.of(context).size.height;
    final firebase = FirebaseFirestore.instance;
    final order = firebase.collection('order');
    final cart = firebase.collection('cart');
    num totalAll = 0;

    for (int i = 0; i < cartModel!.idProduct.length; i++) {
      final product =
          firebase.collection('product').doc(cartModel!.idProduct[i]);
      listProduct.add(StreamBuilder(
          stream: product.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasData) {
              return ModelListCart(
                nameProduct: snapshot.data!['nameProduct'],
                imageUrl: snapshot.data!['imageUrl'],
                qty: cartModel!.qty[i],
                subTotal: cartModel!.subTotal[i],
                price: cartModel!.price[i],
                total: cartModel!.total[i],
                discount: cartModel!.discount[i],
                cartModel: cartModel,
                index: i,
              );
            }
            return CircularProgressIndicator();
          }));
    }

    for (int i = 0; i < cartModel!.total.length; i++) {
      totalAll += cartModel!.total[i];
    }

    for (int i = 0; i < cartModel!.idProduct.length; i++) {
      available.add(null);
    }

    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            SizedBox(
              width: sizeWidth,
              height: sizeHeight * 0.7,
              child: SingleChildScrollView(
                child: Column(
                  children: listProduct,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.all(10),
                width: sizeWidth,
                height: sizeHeight * 0.099,
                color: Colors.grey[400],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Amount : £ ${NumberFormat.currency(locale: 'en', symbol: '').format(totalAll)}',
                      style: GoogleFonts.poppins(),
                    ),
                    FloatingActionButton.large(
                      backgroundColor: Colors.green,
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text('Are You Sure To Checkout ?'),
                              actions: [
                                MaterialButton(
                                  onPressed: () async {
                                    print(available);
                                    final now = DateTime.now();
                                    final date = DateFormat('yyyyMMddHHmmss')
                                        .format(now);
                                    await order.add(({
                                      'uid_user': cartModel!.uidUser,
                                      'time': int.tryParse(date),
                                      'id_product': cartModel!.idProduct,
                                      'qty': cartModel!.qty,
                                      'total': cartModel!.total,
                                      'subTotal': cartModel!.subTotal,
                                      'discount': cartModel!.discount,
                                      'price': cartModel!.price,
                                      'isTake': false,
                                      'isReady': false,
                                      'date': DateTime.now(),
                                      'available': available
                                    }));
                                    minusStock(
                                        cartModel!.idProduct, cartModel!.qty);
                                    cart.doc(cartModel!.uidUser).delete();
                                    Navigator.pop(context);
                                  },
                                  child: Text('Yes'),
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('No'),
                                )
                              ],
                            );
                          },
                        );
                      },
                      child: Icon(
                        Icons.shopping_basket_outlined,
                        size: 35,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

minusStock(List<String> listProduct, List<int> listStock) async {
  final firebase = FirebaseFirestore.instance;
  final product = firebase.collection('product');
  for (int i = 0; i < listProduct.length; i++) {
    var querySnapshot = await product.doc(listProduct[i]).get();
    Map<String, dynamic>? data = querySnapshot.data();
    var currentStock = data!['stock'];
    var stockNew = currentStock - listStock[i];
    listStock[i] = stockNew;
    product.doc(listProduct[i]).update(({'stock': stockNew}));
  }
}
