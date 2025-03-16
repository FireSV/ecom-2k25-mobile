import 'dart:convert';

class Order {
  final int id;
  final int userId;
  final double total;
  final String? orderId;
  final String? url;
  final String? squareId;
  final String createdAt;
  String? status;
  final List<OrderLine> orderLines;

  Order({
    required this.id,
    required this.userId,
    required this.total,
    this.orderId,
    this.url,
    this.squareId,
    required this.createdAt,
    required this.status,
    required this.orderLines,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      total: json['total'] ?? 0.00,
      orderId: json['order_id']?.toString(),
      url: json['url']?.toString(),
      squareId: json['squareId']?.toString(),
      status: json['status']?.toString(),
      createdAt: formatDate(json['created_at']),
      orderLines: (json['orderLineList'] as List<dynamic>?)
              ?.map((item) => OrderLine.fromJson(item))
              .toList() ??
          [],
    );
  }

  static String formatDate(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return '';
    try {
      DateTime parsedDate = DateTime.parse(dateTimeStr);
      return "${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')} "
          "${parsedDate.hour.toString().padLeft(2, '0')}:${parsedDate.minute.toString().padLeft(2, '0')}:${parsedDate.second.toString().padLeft(2, '0')}";
    } catch (e) {
      print("Date parsing error: $e");
      return '';
    }
  }
}

class OrderLine {
  final int id;
  final String itemName;
  final int quantity;
  final double price;

  OrderLine({
    required this.id,
    required this.itemName,
    required this.quantity,
    required this.price,
  });

  factory OrderLine.fromJson(Map<String, dynamic> json) {
    return OrderLine(
      id: json['id'] ?? 0,
      itemName: json['name'] ?? 'Unknown Item',
      quantity: (json['qty'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
