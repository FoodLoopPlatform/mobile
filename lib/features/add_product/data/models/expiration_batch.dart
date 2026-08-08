import 'dart:io';

/// An immutable snapshot of one expiry batch, handed from step 2 to step 3.
class ExpirationBatch {
  final DateTime date;
  final int quantity;
  final File? photo;

  const ExpirationBatch({
    required this.date,
    required this.quantity,
    this.photo,
  });
}
