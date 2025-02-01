import 'package:fire_com/Colors/ColorsLocal.dart';
import 'package:flutter/material.dart';

Widget drawerWidget() {
  return Drawer(
      child: ListView(
    padding: EdgeInsets.zero,
    children: <Widget>[
      DrawerHeader(
        decoration: BoxDecoration(
          color: headerNavigation, // Turquoise
        ),
        child: Text(
          'FIRESTORE',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      ListTile(
        leading: Icon(Icons.person),
        title: Text('Profile'),
        onTap: () {
          // Handle Profile tap
        },
      ),
      ListTile(
        leading: Icon(Icons.language),
        title: Text('Language'),
        onTap: () {
          // Handle Language tap
        },
      ),
      ListTile(
        leading: Icon(Icons.notifications),
        title: Text('Notifications'),
        onTap: () {
          // Handle Notifications tap
        },
      ),
      ListTile(
        leading: Icon(Icons.logout),
        title: Text('Logout'),
        onTap: () {
          // Handle Logout tap
        },
      ),
    ],
  ));
}
