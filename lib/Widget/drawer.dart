import 'package:fire_com/Colors/ColorsLocal.dart';
import 'package:fire_com/Screens/login.dart';
import 'package:fire_com/Screens/userAddress.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget drawerWidget(BuildContext context) {
  return Drawer(
      child: ListView(
    padding: EdgeInsets.zero,
    children: <Widget>[
      DrawerHeader(
        decoration: BoxDecoration(
          color: headerNavigation, // Turquoise
        ),
        child: Center(
          child: Text(
            'FIRESTORE',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
      // ListTile(
      //   leading: Icon(Icons.person),
      //   title: Text('Profile'),
      //   onTap: () {
      //     // Handle Profile tap
      //   },
      // ),
      // ListTile(
      //   leading: Icon(Icons.language),
      //   title: Text('Language'),
      //   onTap: () {
      //     // Handle Language tap
      //   },
      // ),
      // ListTile(
      //   leading: Icon(Icons.notifications),
      //   title: Text('Notifications'),
      //   onTap: () {
      //     // Handle Notifications tap
      //   },
      // ),
      ListTile(
        leading: Icon(Icons.location_on),
        title: Text('Address'),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => UserAddress()));
        },
      ),
      ListTile(
        leading: Icon(Icons.logout),
        title: Text('Logout'),
        onTap: () async {
          SharedPreferences _prefs = await SharedPreferences.getInstance();
          _prefs.clear();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Login()),
            (route) => false, // Removes all previous routes
          );
        },
      ),
    ],
  ));
}
