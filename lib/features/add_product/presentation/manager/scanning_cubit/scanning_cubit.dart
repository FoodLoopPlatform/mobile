import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodloop/core/api_helper/api_manager.dart';
import 'package:foodloop/features/add_product/data/data_sources/add_product_remote_data_source.dart';
import 'package:foodloop/features/add_product/data/models/expiration_batch.dart';
import 'package:foodloop/features/add_product/data/models/product_draft.dart';
import 'package:foodloop/features/add_product/presentation/manager/scanning_cubit/scanning_state.dart';

class ScanningCubit extends Cubit<ScanningState> {
  final AddProductRemoteDataSource _dataSource;

  ScanningCubit()
      : _dataSource = AddProductRemoteDataSource(ApiManager()),
        super(const ScanningInitial());

  /// Performs the OCR scan on [image] and applies the result to [batches].
  ///
  /// Business rules (per spec):
  /// 1. If OCR succeeds and extracted date is **today or later** → overwrite date,
  ///    use OCR confidence.
  /// 2. If OCR succeeds but extracted date is **in the past** → keep the OCR date
  ///    but set confidenceScore to 0.
  /// 3. If OCR fails and batches already have dates → fallback with confidence 0.
  /// 4. If OCR fails and batches have NO dates → emit [ScanningErrorNoDate] to
  ///    force manual date entry.
  Future<void> scanImage({
    required File image,
    required List<ExpirationBatch> batches,
    required ProductDraft draft,
  }) async {
    emit(const ScanningLoading());

    try {
      final result = await _dataSource.scanOCR(image);

      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);

      DateTime? ocrDate = result.extractedExpiryDate;
      double confidence = result.confidenceScore;

      if (ocrDate == null) {
        // No date extracted → confidence is meaningless, zero it out
        confidence = 0.0;
      } else {
        // Rule 2: past expiry date → zero confidence
        final ocrDay = DateTime(ocrDate.year, ocrDate.month, ocrDate.day);
        if (ocrDay.isBefore(todayDate)) {
          confidence = 0.0;
        }
      }

      // If the API returned no date AND the user never entered one either,
      // treat this the same as a failed scan so we force manual entry.
      if (ocrDate == null && batches.isEmpty) {
        emit(ScanningErrorNoDate('OCR returned no expiry date.'));
        return;
      }

      // Apply OCR data to each batch.
      // If ocrDate is null but the user had a manual date, keep that date (confidence = 0).
      List<ExpirationBatch> updated;
      if (batches.isEmpty) {
        updated = [
          ExpirationBatch(
            date: ocrDate!,
            quantity: draft.quantity,
            confidenceScore: confidence,
            extractedText: result.extractedText,
            photo: image,
          ),
        ];
      } else {
        updated = batches.map((batch) {
          final effectiveDate = ocrDate ?? batch.date;
          return batch.copyWith(
            date: effectiveDate,
            confidenceScore: confidence,
            extractedText: result.extractedText,
            photo: batch.photo ?? image,
          );
        }).toList();
      }

      emit(ScanningSuccess(updated));
    } catch (e) {
      final hasAnyDate = batches.isNotEmpty;

      if (hasAnyDate) {
        // Fallback: keep manual dates, confidence = 0
        final fallback = batches
            .map((b) => b.copyWith(confidenceScore: 0.0))
            .toList();
        emit(ScanningErrorWithDate(fallback, e.toString()));
      } else {
        // No date available — must force the user to enter one
        emit(ScanningErrorNoDate(e.toString()));
      }
    }
  }
}
