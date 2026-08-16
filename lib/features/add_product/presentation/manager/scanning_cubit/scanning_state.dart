import 'package:equatable/equatable.dart';
import 'package:foodloop/features/add_product/data/models/expiration_batch.dart';

abstract class ScanningState extends Equatable {
  const ScanningState();
  @override
  List<Object?> get props => [];
}

class ScanningInitial extends ScanningState {
  const ScanningInitial();
}

class ScanningLoading extends ScanningState {
  const ScanningLoading();
}

/// OCR completed successfully. Carries the updated batches with OCR data applied.
class ScanningSuccess extends ScanningState {
  final List<ExpirationBatch> updatedBatches;

  const ScanningSuccess(this.updatedBatches);

  @override
  List<Object?> get props => [updatedBatches];
}

/// OCR failed but the user had manually entered a date — safe to proceed.
class ScanningErrorWithDate extends ScanningState {
  final List<ExpirationBatch> fallbackBatches;
  final String message;

  const ScanningErrorWithDate(this.fallbackBatches, this.message);

  @override
  List<Object?> get props => [fallbackBatches, message];
}

/// OCR failed AND no date was entered — user must pick a date manually before continuing.
class ScanningErrorNoDate extends ScanningState {
  final String message;

  const ScanningErrorNoDate(this.message);

  @override
  List<Object?> get props => [message];
}
