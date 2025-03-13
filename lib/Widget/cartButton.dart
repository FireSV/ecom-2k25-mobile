import 'package:fire_com/Screens/cartPage.dart';
import 'package:flutter/material.dart';

import '../Colors/ColorsLocal.dart' show navigationIcon;

class CartButton extends StatefulWidget {
  const CartButton({super.key});

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CartPage()));
      },
      child: Container(
        decoration: BoxDecoration(
            color: navigationIcon, borderRadius: BorderRadius.circular(1000)),
        width: 50,
        height: 50,
        child: Icon(Icons.shopping_basket_rounded),
      ),
    );
  }
}
