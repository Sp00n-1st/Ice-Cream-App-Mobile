import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ice_mobile/controller/controller.dart';
import 'package:intl/intl.dart';
import '../model/product.dart';
import 'box_checkout.dart';
import 'desc_item.dart';

// ignore: must_be_immutable
class ProductPage extends StatelessWidget {
  Product product;
  String? imageProfile;
  String idProduct;
  ProductPage(
      {super.key,
      required this.product,
      required this.imageProfile,
      required this.idProduct});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(Controller());
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference user = firestore.collection('user');
    double getWidth(BuildContext context) =>
        MediaQuery.of(context).size.width * 1;
    double getHeight(BuildContext context) =>
        MediaQuery.of(context).size.height * 1;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
          toolbarHeight: 70,
          actions: [
            StreamBuilder<DocumentSnapshot>(
                stream: user.doc(auth).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    imageProfile = snapshot.data!['imageProfile'].toString();
                    return Container(
                      margin: EdgeInsets.only(top: 10),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: snapshot.data!['imageProfile'] == null
                            ? NetworkImage(
                                'https://www.its.ac.id/aktuaria/wp-content/uploads/sites/100/2018/03/user-320x320.png')
                            : NetworkImage(imageProfile!),
                      ),
                    );
                  }
                  return CircularProgressIndicator();
                })
          ],
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              CupertinoIcons.arrow_left,
              color: Colors.black,
            ),
          )),
      body: Stack(
        children: [
          Positioned(
            bottom: getHeight(context) / 8,
            left: getWidth(context) / 2.1,
            child: SizedBox(
              width: getWidth(context) / 2,
              height: getHeight(context) - 200,
              child: Image(
                image: NetworkImage(product.imageUrl.elementAt(1)),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10),
                width: MediaQuery.of(context).size.width / 2,
                height: getHeight(context) / 1.42,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    DescItem(55, product.protein.toDouble(), 'Proteins', 'g'),
                    const SizedBox(
                      height: 15,
                    ),
                    DescItem(702, product.fat.toDouble(), 'Fats', 'g'),
                    const SizedBox(
                      height: 15,
                    ),
                    DescItem(2500, product.calori.toDouble(), 'Caloric Content',
                        'kcal'),
                    const SizedBox(
                      height: 15,
                    ),
                    DescItem(
                        2000, product.carbo.toDouble(), 'Carbohydrate', 'g'),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: getHeight(context) / 60),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price',
                            style: GoogleFonts.roboto(
                                color: const Color(0xff4d4d4d), fontSize: 20),
                          ),
                          Row(
                            children: [
                              Text(
                                '£ ',
                                style: GoogleFonts.roboto(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                NumberFormat.currency(locale: 'en', symbol: '')
                                    .format(product.price),
                                style: GoogleFonts.roboto(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: getHeight(context) / 60),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Stock',
                            style: GoogleFonts.roboto(
                                color: const Color(0xff4d4d4d), fontSize: 20),
                          ),
                          Text(
                            product.stock.toString(),
                            style: GoogleFonts.roboto(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(5),
                          margin: EdgeInsets.only(
                              top: getHeight(context) / 45,
                              left: getWidth(context) / 40,
                              right: getWidth(context) / 40),
                          width: getWidth(context) / 3.9,
                          height: (controller.count >= 5)
                              ? getHeight(context) / 13
                              : getHeight(context) / 30,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 3,
                                    color: Colors.black.withOpacity(0.3))
                              ],
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10))),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              'Discount 10%',
                              style: GoogleFonts.roboto(
                                  fontSize: getWidth(context) / 30,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: getHeight(context) / 45),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: const LinearGradient(
                                  colors: [
                                    Colors.red,
                                    Colors.red,
                                    Colors.red,
                                    Colors.red,
                                    Colors.red,
                                    Colors.red,
                                    Colors.red,
                                    Colors.red,
                                    Colors.red,
                                    Colors.red,
                                    Colors.red,
                                    Colors.red,
                                    Colors.red,
                                    Colors.red,
                                    Colors.red,
                                    Colors.red,
                                    Colors.blue,
                                    Colors.blue,
                                    Colors.blue,
                                    Colors.blue,
                                    Colors.blue,
                                    Colors.blue,
                                    Colors.blue,
                                    Colors.blue,
                                    Colors.blue,
                                    Colors.blue,
                                    Colors.blue,
                                    Colors.blue,
                                    Colors.blue,
                                    Colors.blue,
                                    Colors.blue,
                                    Colors.blue,
                                  ],
                                  begin: FractionalOffset.centerLeft,
                                  end: FractionalOffset.centerRight)),
                          width: getWidth(context) / 3.29,
                          height: getHeight(context) / 25,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                  flex: 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.red),
                                    child: IconButton(
                                        padding:
                                            const EdgeInsets.only(bottom: 0),
                                        onPressed: () {
                                          if (controller.count <= 0) {
                                          } else {
                                            controller.decrement();
                                            // context
                                            //     .read<CounterBloc>()
                                            //     .add(DecrementPrice());
                                          }
                                        },
                                        icon: const Icon(
                                          CupertinoIcons.minus,
                                          size: 20,
                                          color: Colors.white,
                                        )),
                                  )),
                              Flexible(flex: 1, child: Container()),
                              Flexible(
                                  flex: 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.blue),
                                    child: IconButton(
                                        padding:
                                            const EdgeInsets.only(bottom: 0),
                                        onPressed: () {
                                          if (controller.count >=
                                              product.stock) {
                                          } else {
                                            controller.increment();
                                            // context
                                            //     .read<CounterBloc>()
                                            //     .add(IncrementPrice(
                                            //         number: 1));
                                          }
                                        },
                                        icon: const Icon(
                                          CupertinoIcons.add,
                                          size: 20,
                                          color: Colors.white,
                                        )),
                                  )),
                            ],
                          ),
                        ),
                        Center(
                            child: Container(
                                margin: EdgeInsets.only(
                                    right: getWidth(context) / 5.1),
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 5),
                                    color: const Color(0xffff5959),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Center(
                                  child: GetX<Controller>(
                                    builder: (_) => Text(
                                      (controller.count == 0)
                                          ? '-'
                                          : controller.count.toInt().toString(),
                                      style: GoogleFonts.roboto(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ))),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                width: double.infinity,
                height: getHeight(context) / 7.4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.nameProduct,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.roboto(
                          fontSize: getWidth(context) / 15,
                          fontWeight: FontWeight.w600),
                    ),
                    Obx(() {
                      return (controller.count != 0)
                          ? ZoomIn(
                              duration: const Duration(seconds: 1),
                              child: BoxCheckout(
                                product: product,
                                cart: controller.count.toInt(),
                                price: product.price,
                                idProduct: idProduct,
                              ))
                          : Roulette(
                              spins: 0,
                              child: ZoomIn(
                                duration: const Duration(seconds: 1),
                                child: TextField(
                                  style: GoogleFonts.roboto(
                                      fontSize: getWidth(context) / 25,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.justify,
                                  maxLines: 3, //or null
                                  decoration: InputDecoration.collapsed(
                                      hintText: product.descItem),
                                ),
                              ),
                            );
                    }),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
