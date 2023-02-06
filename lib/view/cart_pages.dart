import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ice_mobile/model/cart.dart';
import 'package:ice_mobile/view_model/list_cart.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance.currentUser!;
    final firebase = FirebaseFirestore.instance;
    final cartRef2 = firebase
        .collection('cart')
        .doc(auth.uid)
        .withConverter<CartModel>(
            fromFirestore: (snapshot, _) => CartModel.fromJson(snapshot.data()),
            toFirestore: (cartModel, _) => cartModel.toJson());
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Cart Pages',
              style: GoogleFonts.poppins(color: Colors.black),
            )),
        backgroundColor: const Color(0xfffffffff),
        body: StreamBuilder<DocumentSnapshot<CartModel>>(
            stream: cartRef2.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error'),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (!snapshot.hasData) {
                return Center(
                  child: Image.asset('gifLoading.gif'),
                );
              } else if (!snapshot.data!.exists) {
                return Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                        width: 600,
                        height: 400,
                        child: Image(
                          image: AssetImage('assets/nodata6.gif'),
                          fit: BoxFit.fill,
                        )));
              }
              return CartList(
                cartModel: snapshot.data!.data(),
              );
            }));
  }
}
