import 'package:fire_com/Model/top_service_model.dart';
import 'package:fire_com/Screens/productList.dart';
import 'package:flutter/material.dart';

class TopCategoryWidget extends StatefulWidget {
  String image;
  String name;
  TopServiceModel topServiceModel;

  TopCategoryWidget(this.image, this.name, this.topServiceModel, {super.key});

  @override
  State<TopCategoryWidget> createState() => _TopCategoryWidgetState();
}

class _TopCategoryWidgetState extends State<TopCategoryWidget> {
  @override
  void initState() {
    print("widget.image");
    print(widget.topServiceModel.image);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductList(widget.topServiceModel)));
      },
      child: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(360),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 3,
                          spreadRadius: 1)
                    ]),
                width: 50,
                height: 50,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(1000),
                    child: Image.network(
                      widget.image,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/common/no_image.jpg', // Fallback image
                          fit: BoxFit.cover,
                        );
                      },
                    )),
              ),
            ),
            Container(
              width: 60,
              child: Text(
                softWrap: true, // Allow wrapping
                maxLines: 2, // Max two lines
                widget.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
