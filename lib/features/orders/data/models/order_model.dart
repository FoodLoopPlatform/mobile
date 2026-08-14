class OrderItemModel {
  final String productId;
  final String productTitle;
  final int quantity;
  final double unitPrice;

  const OrderItemModel({
    required this.productId,
    required this.productTitle,
    required this.quantity,
    required this.unitPrice,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['productId'] as String,
      productTitle: json['productTitle'] as String,
      quantity: json['quantity'] as int,
      unitPrice: (json['unitPrice'] as num).toDouble(),
    );
  }
}

class OrderModel {
  final String id;
  final String userFullName;
  final double totalAmount;
  final String paymentStatus;
  final String orderStatus;
  final DateTime createdAt;
  final List<OrderItemModel> items;

  const OrderModel({
    required this.id,
    required this.userFullName,
    required this.totalAmount,
    required this.paymentStatus,
    required this.orderStatus,
    required this.createdAt,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      userFullName: json['userFullName'] as String? ?? '',
      totalAmount: (json['totalAmount'] as num).toDouble(),
      paymentStatus: json['paymentStatus'] as String? ?? '',
      orderStatus: json['orderStatus'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Returns a short human-readable ID like "ORD-8AC6"
  String get shortId => 'ORD-${id.substring(0, 4).toUpperCase()}';
}
