import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
import '../model/user.dart';
import '../service/database.dart';
import 'cart_pages.dart';
import 'main_page_mobile.dart';
import 'order_page.dart';
import 'profile.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DataBaseServices dataBaseServices = DataBaseServices();
  final Color navigationBarColor = Colors.white;
  late PageController pageController;
  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// [AnnotatedRegion<SystemUiOverlayStyle>] only for android black navigation bar. 3 button navigation control (legacy)
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference user = firestore.collection('user');

    DocumentReference<UserAccount> users = firestore
        .collection('user')
        .doc(auth)
        .withConverter<UserAccount>(
            fromFirestore: (snapshot, _) =>
                UserAccount.fromJson(snapshot.data()),
            toFirestore: (users, _) => users.toJson());

    return StreamBuilder(
      stream: user.doc(auth).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          DataBaseServices().logoutAuth(false);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.data!['isDisable'] == true) {
          DataBaseServices().logoutAuth(false);
        }
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            systemNavigationBarColor: navigationBarColor,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
          child: Scaffold(
            body: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              children: <Widget>[
                MainPageMobile(),
                CartPage(),
                OrderPage(),
                StreamBuilder(
                    stream: users.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        DataBaseServices().logoutAuth(false);
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Profile(userAccount: snapshot.data!.data()!);
                    })
              ],
            ),
            bottomNavigationBar: WaterDropNavBar(
              waterDropColor: Color(0xff1E90FF),
              backgroundColor: navigationBarColor,
              onItemSelected: (int index) {
                setState(() {
                  selectedIndex = index;
                });
                pageController.animateToPage(selectedIndex,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutQuad);
              },
              selectedIndex: selectedIndex,
              barItems: <BarItem>[
                BarItem(
                  filledIcon: CupertinoIcons.house_alt_fill,
                  outlinedIcon: CupertinoIcons.home,
                ),
                BarItem(
                    filledIcon: Icons.shopping_cart_rounded,
                    outlinedIcon: Icons.shopping_cart_outlined),
                BarItem(
                    filledIcon: Icons.shopping_basket_rounded,
                    outlinedIcon: Icons.shopping_basket_outlined),
                BarItem(
                  filledIcon: CupertinoIcons.person_fill,
                  outlinedIcon: CupertinoIcons.person,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
