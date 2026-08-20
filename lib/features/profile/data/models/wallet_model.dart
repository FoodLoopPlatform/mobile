class WalletModel {
  final double walletBalance;
  final List<WalletTransactionModel> transactions;

  WalletModel({
    required this.walletBalance,
    required this.transactions,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      walletBalance: (json['walletBalance'] as num?)?.toDouble() ?? 0.0,
      transactions: (json['transactions'] as List<dynamic>?)
              ?.map((e) => WalletTransactionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class WalletTransactionModel {
  final String id;
  final double amount;
  final String type;
  final String? referenceId;
  final String? description;
  final DateTime? createdAt;

  WalletTransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    this.referenceId,
    this.description,
    this.createdAt,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      id: json['id']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      type: json['type']?.toString() ?? '',
      referenceId: json['referenceId']?.toString(),
      description: json['description']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }
}
