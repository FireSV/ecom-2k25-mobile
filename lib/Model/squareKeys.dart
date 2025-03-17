class SquareKeys {
  int? id;
  int userId;
  String locationId;
  String accessToken;
  String currency;

  SquareKeys({
    this.id,
    required this.userId,
    required this.locationId,
    required this.accessToken,
    required this.currency,
  });

  factory SquareKeys.fromJson(Map<String, dynamic> json) {
    return SquareKeys(
      id: json['id'],
      userId: json['userId'],
      locationId: json['locationId'],
      accessToken: json['accessToken'],
      currency: json['currency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'locationId': locationId,
      'accessToken': accessToken,
      'currency': currency,
    };
  }
}
