class CartItemModel {
  final String productId;
  final String name;
  final double price;
  final String imageUrl;
  int quantity;

  /// The store that owns this product. Used to enforce single-store cart rule.
  final String organizationId;
  final String storeName;

  CartItemModel({
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    required this.organizationId,
    required this.storeName,
  });

  Map<String, dynamic> toMap() => {
        'productId': productId,
        'name': name,
        'price': price,
        'imageUrl': imageUrl,
        'quantity': quantity,
        'organizationId': organizationId,
        'storeName': storeName,
      };

  factory CartItemModel.fromMap(Map<dynamic, dynamic> map) => CartItemModel(
        productId: map['productId'] as String,
        name: map['name'] as String,
        price: (map['price'] as num).toDouble(),
        imageUrl: map['imageUrl'] as String,
        quantity: map['quantity'] as int,
        organizationId: (map['organizationId'] as String?) ?? '',
        storeName: (map['storeName'] as String?) ?? '',
      );

  CartItemModel copyWith({int? quantity}) => CartItemModel(
        productId: productId,
        name: name,
        price: price,
        imageUrl: imageUrl,
        quantity: quantity ?? this.quantity,
        organizationId: organizationId,
        storeName: storeName,
      );
}
