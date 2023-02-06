import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../model/product.dart';
import '../view/product_page.dart';

// ignore: must_be_immutable
class ListProduct extends StatelessWidget {
  Product product;
  String? imageProfile;
  String idProduct;

  ListProduct(
      {super.key,
      required this.product,
      required this.imageProfile,
      required this.idProduct});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 180,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border.all(color: Colors.black26),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: SizedBox(
                width: 180,
                child: Image(
                  image: NetworkImage(product.imageUrl.elementAt(0)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.only(left: 5),
                width: 180,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  border: Border.all(color: Colors.black26),
                ),
                child: Stack(
                  children: [
                    SizedBox(
                      width: 105,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 7,
                          ),
                          Text(
                            '${product.nameProduct}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: GoogleFonts.roboto(
                                fontSize: 13, color: const Color(0xff4d4d4d)),
                          ),
                          Text(
                            '£ ${NumberFormat.currency(locale: 'en', symbol: '').format(product.price)} ',
                            style: GoogleFonts.roboto(
                                color: const Color(0xff4d4d4d),
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 3,
                              backgroundColor: const Color(0xff000000),
                              shape: const CircleBorder()),
                          onPressed: () {
                            Get.to(
                                ProductPage(
                                  idProduct: idProduct,
                                  product: product,
                                  imageProfile: imageProfile,
                                ),
                                duration: Duration(milliseconds: 500),
                                transition: Transition.zoom);
                          },
                          child: const Icon(Icons.shopping_cart)),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 5,
              left: 5,
              child: Container(
                height: 20,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200]),
                child: Row(
                  children: [
                    const Icon(
                      CupertinoIcons.star_fill,
                      color: Color(0xffFFA931),
                      size: 15,
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
