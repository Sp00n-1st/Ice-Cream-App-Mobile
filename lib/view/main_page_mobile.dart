import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/product.dart';
import '../service/database.dart';
import '../view_model/list_product.dart';

class MainPageMobile extends StatefulWidget {
  @override
  State<MainPageMobile> createState() => _MainPageMobileState();
}

class _MainPageMobileState extends State<MainPageMobile> {
  @override
  void dispose() {
    searchText.dispose();
    super.dispose();
  }

  @override
  void initState() {
    searchText.clear();
    super.initState();
  }

  String? category;
  String? name;
  String? imageProfile;
  TextEditingController searchText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance.currentUser!.uid;
    Query<Product> products = firestore
        .collection('product')
        .where('category', isEqualTo: category)
        .withConverter<Product>(
            fromFirestore: (snapshot, _) => Product.fromJson(snapshot.data()),
            toFirestore: (product, _) => product.toJson());
    CollectionReference user = firestore.collection('user');
    double sizeWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xfffffffff),
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        toolbarHeight: 70,
        title: StreamBuilder<DocumentSnapshot>(
          stream: user.doc(auth).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(
                'Welcome ${snapshot.data!['firstName'].toString()}\nHow Are You Today ?',
                style: GoogleFonts.poppins(color: Colors.black),
              );
            } else if (snapshot.hasError) {
              DataBaseServices().logoutAuth(false);
            }
            return const Text('No Name');
          },
        ),
        actions: [
          StreamBuilder<DocumentSnapshot>(
              stream: user.doc(auth).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  imageProfile = snapshot.data!['imageProfile'].toString();
                  return Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: snapshot.data!['imageProfile'] == null
                          ? const NetworkImage(
                              'https://www.its.ac.id/aktuaria/wp-content/uploads/sites/100/2018/03/user-320x320.png')
                          : NetworkImage(imageProfile!),
                    ),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const SizedBox(
                      width: 70,
                      height: 70,
                      child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  DataBaseServices().logoutAuth(false);
                }
                return const SizedBox(
                    width: 70, height: 70, child: CircularProgressIndicator());
              })
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 100,
              child: Row(children: [
                Container(
                  width: 300,
                  height: 42,
                  margin: const EdgeInsets.fromLTRB(16, 16, 10, 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    border: Border.all(color: Colors.black26),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: const TextField(
                    controller: null,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.search_sharp,
                        color: Colors.black,
                        size: 35,
                      ),
                      hintText: 'Ice Cream Search',
                      hintStyle: TextStyle(),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ]),
            ),
            DefaultTabController(
              length: 5,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  width: sizeWidth * 1.02,
                  height: 70,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ButtonsTabBar(
                          onTap: (position) {
                            if (position == 0) {
                              setState(() {
                                category = null;
                              });
                            } else if (position == 1) {
                              setState(() {
                                category = 'Gelato';
                              });
                            } else if (position == 2) {
                              setState(() {
                                category = 'Ice Stick';
                              });
                            } else if (position == 3) {
                              setState(() {
                                category = 'Sundae';
                              });
                            } else if (position == 4) {
                              setState(() {
                                category = 'Ice Cone';
                              });
                            }
                          },
                          buttonMargin:
                              const EdgeInsets.only(right: 7.5, left: 7.5),
                          height: 70,
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                Color(0xFF0D47A1),
                                Color(0xFF1976D2),
                                Color(0xFF42A5F5),
                              ],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight)),
                          unselectedBackgroundColor: Colors.grey[300],
                          unselectedLabelStyle:
                              const TextStyle(color: Colors.black),
                          labelStyle: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          tabs: [
                            Tab(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SizedBox(
                                  width: 50,
                                  height: 60,
                                  child: Center(
                                    child: Text(
                                      'All',
                                      style: GoogleFonts.roboto(
                                          fontSize: 20, color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Tab(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  color: Colors.black.withOpacity(0.03),
                                  width: 50,
                                  height: 60,
                                  child: const Image(
                                      image: AssetImage('assets/tab1.png')),
                                ),
                              ),
                            ),
                            Tab(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                      color: Colors.black.withOpacity(0.03),
                                      width: 50,
                                      height: 60,
                                      child: const Image(
                                          image:
                                              AssetImage('assets/tab2.png')))),
                            ),
                            Tab(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                      color: Colors.black.withOpacity(0.03),
                                      width: 50,
                                      height: 60,
                                      child: const Image(
                                          image:
                                              AssetImage('assets/tab3.png')))),
                            ),
                            Tab(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                      color: Colors.black.withOpacity(0.03),
                                      width: 50,
                                      height: 60,
                                      child: const Image(
                                          image:
                                              AssetImage('assets/tab4.png')))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            StreamBuilder(
                stream: products
                    .orderBy('nameProduct', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.only(top: 130),
                        child: const CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) {
                    return const Text('kosong');
                  }

                  final data = snapshot.requireData;
                  return data.size != 0
                      ? Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.only(bottom: 50),
                          width: 370,
                          height: 420,
                          child: GridView.builder(
                            itemCount: data.size,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    //childAspectRatio: 3 / 2,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5),
                            itemBuilder: (context, index) => ListProduct(
                              product: data.docs[index].data(),
                              imageProfile: imageProfile,
                              idProduct: data.docs[index].id,
                            ),
                          ))
                      : const SizedBox(
                          width: 600,
                          height: 400,
                          child: Image(
                            image: AssetImage('assets/nodata6.gif'),
                            fit: BoxFit.fill,
                          ));
                }),
          ],
        ),
      ),
    );
  }
}
