import 'package:fire_com/Colors/ColorsLocal.dart';
import 'package:fire_com/Model/cart.dart';
import 'package:fire_com/Screens/PaymentGatewayWebView.dart';
import 'package:fire_com/Screens/addressSelection.dart';
import 'package:fire_com/Widget/backButtonWidget.dart';
import 'package:flutter/material.dart';

class DeliveryMethod extends StatefulWidget {
  List<Cart> _cartList ;

  DeliveryMethod(this._cartList); // const DeliveryMethod({super.key});

  @override
  State<DeliveryMethod> createState() => _DeliveryMethodState();
}

class _DeliveryMethodState extends State<DeliveryMethod> {
  String? selectedMethod = "Square Payment";

  void selectMethod(String method) {
    setState(() {
      selectedMethod = method;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  BackButtonWidget(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Select Payment Method",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              _buildOption('Square Payment', Icons.credit_card),
              SizedBox(height: 12),
              _buildOption('Cash on Delivery', Icons.money),
              Spacer(),
              // ElevatedButton(
              //   onPressed: selectedMethod != null
              //       ? () {
              //           // Proceed with selected payment method
              //           print('Selected Method: $selectedMethod');
              //         }
              //       : null,
              //   style: ElevatedButton.styleFrom(
              //     minimumSize: Size(double.infinity, 50),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //   ),
              //   child: Text('Continue', style: TextStyle(fontSize: 18)),
              // ),

              InkWell(
                onTap: () {
                  // if (selectedMethod == "Square Payment") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddressSelection(selectedMethod!,widget._cartList)));
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => PaymentGatewayWebView()));
                  // }
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: navigationIcon,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white, width: 3)),
                  width: 300,
                  height: 45,
                  child: Center(
                      child: Text(
                    "Continue",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(String title, IconData icon) {
    bool isSelected = selectedMethod == title;
    return GestureDetector(
      onTap: () => selectMethod(title),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? navigationIcon : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 30, color: isSelected ? Colors.white : Colors.grey),
            SizedBox(width: 12),
            Text(title, style: TextStyle(fontSize: 18)),
            Spacer(),
            if (isSelected)
              Icon(Icons.check_circle, color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }
}
