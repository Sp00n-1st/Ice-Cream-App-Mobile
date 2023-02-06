import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/order.dart';
import 'model_list_order.dart';
import 'order.dart';

// ignore: must_be_immutable
class OrderList extends StatelessWidget {
  OrderModel? cartModel;
  OrderList({super.key, required this.cartModel});
  List<Widget> listProduct = <Widget>[];
  List<Widget> listOrder = <Widget>[];

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    double sizeHeight = MediaQuery.of(context).size.height;
    final firebase = FirebaseFirestore.instance;
    num totalAll = 0;
    final product = firebase.collection('product');
    for (int i = 0; i < cartModel!.idProduct.length; i++) {
      listProduct.add(StreamBuilder(
          stream: product.doc(cartModel!.idProduct[i]).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasData) {
              return ModelListOrder(
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
      listOrder.add(StreamBuilder(
          stream: product.doc(cartModel?.idProduct[i]).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error'),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center();
            }
            return Order(
              box1: snapshot.data?['nameProduct'],
              box2: cartModel!.price[i].toString(),
              box3: cartModel!.qty[i].toString(),
              box4: cartModel!.subTotal[i].toString(),
              box5: cartModel!.discount[i].toString(),
              box6: cartModel!.total[i].toString(),
              totalAll: totalAll,
            );
          }));
    }

    return Scaffold(
        body: Center(
      child: Container(
        width: sizeWidth * 0.97,
        child: Column(
          children: [
            Container(
              height: sizeHeight * 0.03,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: sizeWidth * 0.25,
                    child: Center(
                      child: Text(
                        'Name Product',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                    ),
                  ),
                  Container(
                    width: sizeWidth * 0.15,
                    child: Center(
                      child: Text(
                        'Price',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                    ),
                  ),
                  Container(
                    width: sizeWidth * 0.1,
                    child: Center(
                      child: Text(
                        'Qty',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                    ),
                  ),
                  Container(
                    width: sizeWidth * 0.15,
                    child: Center(
                      child: Text(
                        'SubTotal',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                    ),
                  ),
                  Container(
                    width: sizeWidth * 0.15,
                    child: Center(
                      child: Text(
                        'Discount',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                    ),
                  ),
                  Container(
                    width: sizeWidth * 0.15,
                    child: Center(
                      child: Text(
                        'Total',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Column(
              children: listOrder,
            ),
          ],
        ),
      ),
    ));
  }
}
