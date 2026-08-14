class OrderResponseModel {
  final String? orderReference;
  final int? estimatedReadyMinutes;
  final String? pickupName;
  final String? pickupAddress;

  const OrderResponseModel({
    this.orderReference,
    this.estimatedReadyMinutes,
    this.pickupName,
    this.pickupAddress,
  });

  factory OrderResponseModel.fromMap(Map<String, dynamic> map) {
    dynamic dataRaw = map['data'];
    Map<String, dynamic> data = {};
    if (dataRaw is Map<String, dynamic>) {
      data = dataRaw;
    } else if (dataRaw is List && dataRaw.isNotEmpty && dataRaw.first is Map) {
      data = dataRaw.first as Map<String, dynamic>;
    } else {
      data = map;
    }

    return OrderResponseModel(
      orderReference: data['orderReference']?.toString() ?? data['id']?.toString(),
      estimatedReadyMinutes: (data['estimatedReadyMinutes'] as num?)?.toInt() ?? 15,
      pickupName: data['pickupName']?.toString() ?? 
                  data['storeName']?.toString() ?? 
                  data['organizationName']?.toString(),
      pickupAddress: data['pickupAddress']?.toString() ?? data['storeAddress']?.toString(),
    );
  }
}
