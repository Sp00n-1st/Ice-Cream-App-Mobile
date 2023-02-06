import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../model/order.dart';

// ignore: must_be_immutable
class ModelListOrder extends StatelessWidget {
  String nameProduct;
  List<dynamic> imageUrl;
  int qty, index;
  num price, subTotal, total, discount;
  OrderModel? cartModel;
  ModelListOrder(
      {required this.nameProduct,
      required this.imageUrl,
      required this.qty,
      required this.price,
      required this.subTotal,
      required this.total,
      required this.discount,
      required this.cartModel,
      required this.index});
  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    final firebase = FirebaseFirestore.instance;
    final cartRef = firebase.collection('cart').doc(cartModel!.uidUser);
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 20),
      width: sizeWidth * 0.9,
      height: 170,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(25)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              imageUrl.elementAt(0),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(nameProduct, style: GoogleFonts.poppins(fontSize: 12)),
              SizedBox(
                width: sizeWidth / 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Qty', style: GoogleFonts.poppins(fontSize: 12)),
                    Text('$qty Pcs', style: GoogleFonts.poppins(fontSize: 12))
                  ],
                ),
              ),
              SizedBox(
                width: sizeWidth / 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Price', style: GoogleFonts.poppins(fontSize: 12)),
                    Text(
                        '£ ${NumberFormat.currency(locale: 'en', symbol: '').format(price)} ',
                        style: GoogleFonts.poppins(fontSize: 12))
                  ],
                ),
              ),
              SizedBox(
                width: sizeWidth / 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('SubTotal', style: GoogleFonts.poppins(fontSize: 12)),
                    Text(
                      '£ ${NumberFormat.currency(locale: 'en', symbol: '').format(subTotal)}',
                      style: GoogleFonts.poppins(fontSize: 12),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: sizeWidth / 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Discount', style: GoogleFonts.poppins(fontSize: 12)),
                    Text(
                        '£ ${NumberFormat.currency(locale: 'en', symbol: '').format(discount)}',
                        style: GoogleFonts.poppins(fontSize: 12))
                  ],
                ),
              ),
              SizedBox(
                width: sizeWidth / 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total', style: GoogleFonts.poppins(fontSize: 12)),
                    Text(
                        '£ ${NumberFormat.currency(locale: 'en', symbol: '').format(total)}',
                        style: GoogleFonts.poppins(fontSize: 12))
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 2),
                height: 30,
                width: sizeWidth / 3,
                child: Center(
                    child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: Text('Delete Item ?'),
                                content: Column(
                                  children: [
                                    Icon(
                                      CupertinoIcons.delete,
                                      size: 70,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                        'Are You Sure To Delete Item From Cart ?')
                                  ],
                                ),
                                actions: [
                                  MaterialButton(
                                    onPressed: () {
                                      cartModel!.idProduct.removeAt(index);
                                      cartModel!.price.removeAt(index);
                                      cartModel!.discount.removeAt(index);
                                      cartModel!.subTotal.removeAt(index);
                                      cartModel!.total.removeAt(index);
                                      cartModel!.qty.removeAt(index);

                                      cartRef.update(({
                                        'discount': cartModel!.discount,
                                        'id_product': cartModel!.idProduct,
                                        'price': cartModel!.price,
                                        'qty': cartModel!.qty,
                                        'subTotal': cartModel!.subTotal,
                                        'total': cartModel!.total
                                      }));
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
                        child: Icon(Icons.delete))),
              )
            ],
          ),
        ],
      ),
    );
  }
}
