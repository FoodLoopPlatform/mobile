class CartItemModel {
  final String productId;
  final String name;
  final double price;
  final String imageUrl;
  int quantity;

  CartItemModel({
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.quantity,
  });

  Map<String, dynamic> toMap() => {
        'productId': productId,
        'name': name,
        'price': price,
        'imageUrl': imageUrl,
        'quantity': quantity,
      };

  factory CartItemModel.fromMap(Map<dynamic, dynamic> map) => CartItemModel(
        productId: map['productId'] as String,
        name: map['name'] as String,
        price: (map['price'] as num).toDouble(),
        imageUrl: map['imageUrl'] as String,
        quantity: map['quantity'] as int,
      );

  CartItemModel copyWith({int? quantity}) => CartItemModel(
        productId: productId,
        name: name,
        price: price,
        imageUrl: imageUrl,
        quantity: quantity ?? this.quantity,
      );
}
