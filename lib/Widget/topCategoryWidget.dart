import 'package:flutter/material.dart';

class TopCategoryWidget extends StatefulWidget {
  String image;
  String name;

  TopCategoryWidget(this.image, this.name, {super.key});

  @override
  State<TopCategoryWidget> createState() => _TopCategoryWidgetState();
}

class _TopCategoryWidgetState extends State<TopCategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                  child: Image.asset(widget.image,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/common/no_image.jpg', // Fallback image
                        fit: BoxFit.cover,
                      );
                    },
                  )),
            ),
          ),
          Text(
            widget.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
