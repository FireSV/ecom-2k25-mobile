import 'package:fire_com/Colors/ColorsLocal.dart';
import 'package:flutter/material.dart';

class BackButtonWidget extends StatefulWidget {
  const BackButtonWidget({super.key});

  @override
  State<BackButtonWidget> createState() => _BackButtonWidgetState();
}

class _BackButtonWidgetState extends State<BackButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        decoration: BoxDecoration(
            color: navigationIcon, borderRadius: BorderRadius.circular(1000)),
        width: 40,
        height: 40,
        child: Icon(Icons.arrow_back_ios_new),
      ),
    );
  }
}
