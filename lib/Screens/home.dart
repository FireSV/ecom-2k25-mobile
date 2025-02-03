import 'package:fire_com/Colors/ColorsLocal.dart';
import 'package:fire_com/Screens/shop.dart';
import 'package:fire_com/Screens/welcomePage.dart';
import 'package:fire_com/Widget/drawer.dart';
import 'package:fire_com/Widget/homeAds.dart';
import 'package:fire_com/Widget/topCategory.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  List<Widget> get content => [WelcomePage(openDrawer), Shop()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: grey,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: text4,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        showUnselectedLabels: true,
        unselectedItemColor: Colors.grey,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _selectedIndex == 0 ? navigationIcon : Colors.grey,
            ),
            label: 'Home',
            backgroundColor: headerNavigation,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopify,
                color: _selectedIndex == 1 ? navigationIcon : Colors.grey),
            label: 'Shop',
            backgroundColor: headerNavigation,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart,
                color: _selectedIndex == 2 ? navigationIcon : Colors.grey),
            label: 'Cart',
            backgroundColor: headerNavigation,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings,
                color: _selectedIndex == 3 ? navigationIcon : Colors.grey),
            label: 'Settings',
            backgroundColor: headerNavigation,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      drawer: drawerWidget(),
      body: SafeArea(
        child: content[_selectedIndex],
      ),
    );
  }
}
