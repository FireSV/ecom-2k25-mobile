import 'package:fire_com/Colors/ColorsLocal.dart';
import 'package:fire_com/Model/top_service_model.dart';
import 'package:fire_com/Widget/backButtonWidget.dart';
import 'package:flutter/material.dart';

class CartView extends StatefulWidget {
  TopServiceModel service;

  CartView(this.service, {super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2,
                decoration: BoxDecoration(
                  color: grey,
                ),
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child:
                          Image.asset(widget.service.image, fit: BoxFit.cover),
                    ),
                    Positioned(left: 20, top: 20, child: BackButtonWidget())
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: (MediaQuery.of(context).size.height / 2) + 30,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            widget.service.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 45,
                      width: 200,
                      decoration: BoxDecoration(
                          color: navigationIcon,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text(
                        "Checkout",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
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
