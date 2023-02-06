import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../model/order.dart';
import '../view_model/list_order.dart';

class OrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    double sizeHeight = MediaQuery.of(context).size.height;
    final firabase = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance.currentUser!.uid;
    final orderRef = firabase.collection('order');
    final order = firabase
        .collection('order')
        .where('uid_user', isEqualTo: auth)
        .orderBy('date', descending: true)
        .withConverter<OrderModel>(
            fromFirestore: (snapshot, _) =>
                OrderModel.fromJson(snapshot.data()),
            toFirestore: (orderModel, _) => orderModel.toJson());
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Order Pages',
              style: GoogleFonts.poppins(color: Colors.black),
            )),
        body: SizedBox(
          height: sizeHeight,
          child: StreamBuilder<QuerySnapshot<OrderModel>>(
              stream: order.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error'),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (!snapshot.hasData) {
                  return Center(
                    child: Image.asset('gifLoading.gif'),
                  );
                } else if (snapshot.data!.size == 0) {
                  return Center(
                      child: SizedBox(
                          width: 600,
                          height: 400,
                          child: Image(
                            image: AssetImage('assets/nodata6.gif'),
                            fit: BoxFit.fill,
                          )));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.size,
                  itemBuilder: (context, index) {
                    num totalAll = 0;
                    for (int i = 0;
                        i <
                            snapshot.data!.docs
                                .elementAt(index)
                                .data()
                                .total
                                .length;
                        i++) {
                      totalAll +=
                          snapshot.data!.docs.elementAt(index).data().total[i];
                    }

                    var dateTime = DateFormat('dd/MM/yyyy').format(snapshot
                        .data!.docs
                        .elementAt(index)
                        .data()
                        .date
                        .toDate());

                    return Container(
                      margin: EdgeInsets.only(right: 5, left: 5, bottom: 20),
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 1.1,
                                color: Colors.black,
                                offset: Offset(0.5, 0.5))
                          ]),
                      child: Column(
                        children: [
                          Container(
                              height: sizeHeight * 0.03,
                              padding: EdgeInsets.only(left: 20, right: 20),
                              width: sizeWidth * 0.97,
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: Colors.black))),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        dateTime,
                                        style: GoogleFonts.poppins(),
                                      ),
                                      snapshot.data!.docs
                                                  .elementAt(index)
                                                  .data()
                                                  .isTake ==
                                              true
                                          ? snapshot.data!.docs
                                                  .elementAt(index)
                                                  .data()
                                                  .isReady
                                              ? Text(
                                                  'Done',
                                                  style: GoogleFonts.poppins(),
                                                )
                                              : Text(
                                                  'Order Is Being Prepared',
                                                  style: GoogleFonts.poppins(),
                                                )
                                          : Text(
                                              'In Queue',
                                              style: GoogleFonts.poppins(),
                                            )
                                    ],
                                  ))),
                          SizedBox(
                            height: (snapshot.data!.docs
                                        .elementAt(index)
                                        .data()
                                        .idProduct
                                        .length *
                                    30) +
                                (sizeHeight * 0.03),
                            child: OrderList(
                              cartModel:
                                  snapshot.data?.docs.elementAt(index).data(),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 50, right: 50),
                            height: sizeHeight * 0.035,
                            width: sizeWidth * 0.97,
                            decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(color: Colors.black))),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Amount',
                                    style: GoogleFonts.poppins(),
                                  ),
                                  Text(
                                      '£ ${NumberFormat.currency(locale: 'en', symbol: ' ').format(totalAll)}',
                                      style: GoogleFonts.poppins())
                                ]),
                          ),
                          snapshot.data?.docs.elementAt(index).data().isTake ==
                                  false
                              ? FloatingActionButton.small(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return CupertinoAlertDialog(
                                          title: Text(
                                              'Are You Sure To Cancel Order ?'),
                                          actions: [
                                            MaterialButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  final data = snapshot
                                                      .data!.docs
                                                      .elementAt(index);
                                                  var id = data.id;
                                                  final listStock =
                                                      data.data().qty;
                                                  final listProduct =
                                                      data.data().idProduct;
                                                  plusStock(
                                                      listProduct, listStock);
                                                  orderRef.doc(id).delete();
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return CupertinoAlertDialog(
                                                        title: Text(
                                                          'Order Has Been Cancel',
                                                          style: GoogleFonts
                                                              .poppins(),
                                                        ),
                                                        content: Icon(
                                                          CupertinoIcons
                                                              .xmark_circle,
                                                          size: 70,
                                                        ),
                                                        actions: [
                                                          MaterialButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text('OK'),
                                                          )
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Text('Yes')),
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
                                    Icons.cancel_outlined,
                                    size: 40,
                                    color: Colors.red,
                                  ),
                                )
                              : SizedBox()
                        ],
                      ),
                    );
                  },
                );
              }),
        ));
  }
}

plusStock(List<String> listProduct, List<int> listStock) async {
  final firebase = FirebaseFirestore.instance;
  final product = firebase.collection('product');
  for (int i = 0; i < listProduct.length; i++) {
    var querySnapshot = await product.doc(listProduct[i]).get();
    Map<String, dynamic>? data = querySnapshot.data();
    var currentStock = data!['stock'];
    var stockNew = currentStock + listStock[i];
    listStock[i] = stockNew;
    product.doc(listProduct[i]).update(({'stock': stockNew}));
  }
}
