import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:snacks_app/utils/modal.dart';
import 'package:snacks_app/views/home/home_widget.dart';
import 'package:snacks_app/views/home/orders_screen.dart';
import 'package:snacks_app/views/home/widgets/modals/card_modal.dart';
import 'package:snacks_app/views/home/widgets/profile_modal.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final auth = FirebaseAuth.instance;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreenWidget(),
    OrdersScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        extendBody: true,
        bottomNavigationBar: Container(
          // margin: const EdgeInsets.fromLTRB(20, 0, 15, 15),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 3,
                color: Colors.black.withOpacity(.1),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              backgroundColor: Colors.transparent,
              curve: Curves.easeInOut,
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              color: Colors.black,
              tabs: [
                const GButton(
                  icon: Icons.home_rounded,
                  text: 'Home',
                ),
                const GButton(
                  icon: Icons.receipt_rounded,
                  text: 'Pedidos',
                ),
                GButton(
                  icon: Icons.credit_card_rounded,
                  text: 'Cartão',
                  onPressed: () => AppModal().showModalBottomSheet(
                    withPadding: false,
                    context: context,
                    dimisible: false,
                    content: const CardDetailsModal(),
                  ),
                ),
                if (auth.currentUser != null &&
                    !(auth.currentUser?.isAnonymous ?? false))
                  GButton(
                    icon: Icons.account_circle_rounded,
                    text: 'Conta',
                    onPressed: () => AppModal().showModalBottomSheet(
                      withPadding: false,
                      context: context,
                      content: ProfileModal(),
                    ),
                  ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) async {
                setState(() {
                  if (index < _widgetOptions.length) _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
