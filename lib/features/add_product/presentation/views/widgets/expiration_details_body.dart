import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/core/routes_manager/routes_names.dart';
import 'package:foodloop/core/widgets/custom_button.dart';
import 'package:foodloop/features/add_product/data/models/expiration_batch.dart';
import 'package:foodloop/features/add_product/data/models/product_draft.dart';
import 'package:foodloop/features/add_product/presentation/views/scanning_view.dart';
import 'package:foodloop/features/add_product/presentation/views/verification_results_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:foodloop/features/add_product/presentation/views/widgets/add_product_step_indicator.dart';
import 'package:foodloop/features/add_product/presentation/views/widgets/expiration_batch_tile.dart';
import 'package:foodloop/features/add_product/presentation/views/widgets/expiration_date_field.dart';
import 'package:foodloop/features/add_product/presentation/views/widgets/verification_status_card.dart';

/// Mutable row in the per-batch list.
class _DateBatch {
  DateTime? date;
  File? photo;
  final TextEditingController quantity;

  _DateBatch({String initialQuantity = '1'})
      : quantity = TextEditingController(text: initialQuantity);

  void dispose() => quantity.dispose();
}

class ExpirationDetailsBody extends StatefulWidget {
  const ExpirationDetailsBody({super.key, required this.draft});

  final ProductDraft draft;

  @override
  State<ExpirationDetailsBody> createState() => _ExpirationDetailsBodyState();
}

class _ExpirationDetailsBodyState extends State<ExpirationDetailsBody> {
  DateTime? _primaryDate;
  bool _sameDateForAll = true;
  final List<_DateBatch> _batches = [];

  @override
  void initState() {
    super.initState();
    // One row ready to fill the moment the user switches to per-batch dates.
    _batches.add(_DateBatch(initialQuantity: '${widget.draft.quantity}'));
  }

  @override
  void dispose() {
    for (final batch in _batches) {
      batch.dispose();
    }
    super.dispose();
  }

  /// Earliest date across whichever mode is active — drives the shelf-life
  /// indicator, since the soonest expiry is what actually limits the listing.
  DateTime? get _earliestDate {
    if (_sameDateForAll) return _primaryDate;
    final dates = _batches
        .map((batch) => batch.date)
        .whereType<DateTime>()
        .toList(growable: false);
    if (dates.isEmpty) return null;
    return dates.reduce((a, b) => a.isBefore(b) ? a : b);
  }

  bool get _canVerify {
    if (_sameDateForAll) return _primaryDate != null;
    return _batches.isNotEmpty &&
        _batches.every((batch) => batch.date != null);
  }

  Future<void> _pickDate({
    required DateTime? current,
    required ValueChanged<DateTime> onPicked,
  }) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? now.add(const Duration(days: 7)),
      // Expiry dates are forward-looking; yesterday is never a valid answer.
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) onPicked(picked);
  }

  Future<void> _pickBatchPhoto(_DateBatch batch) async {
    final result = await FilePicker.pickFiles(type: FileType.image);
    final path = result?.paths.firstOrNull;
    if (path != null) setState(() => batch.photo = File(path));
  }

  void _addBatch() {
    setState(() => _batches.add(_DateBatch()));
  }

  void _removeBatch(int index) {
    setState(() {
      _batches.removeAt(index).dispose();
    });
  }

  /// Snapshot of whatever dates are entered, in whichever mode is active.
  List<ExpirationBatch> _collectBatches() {
    if (_sameDateForAll) {
      final date = _primaryDate;
      if (date == null) return const [];
      return [ExpirationBatch(date: date, quantity: widget.draft.quantity)];
    }

    return [
      for (final batch in _batches)
        if (batch.date != null)
          ExpirationBatch(
            date: batch.date!,
            quantity: int.tryParse(batch.quantity.text.trim()) ?? 0,
            photo: batch.photo,
          ),
    ];
  }

  Future<void> _verifyViaCamera() async {
    final shot = await ImagePicker().pickImage(source: ImageSource.camera);
    if (shot == null || !mounted) return;

    Navigator.pushNamed(
      context,
      RoutesNames.scanningView,
      arguments: ScanningArgs(
        image: File(shot.path),
        draft: widget.draft,
        batches: _collectBatches(),
      ),
    );
  }

  void _onVerify() {
    Navigator.pushNamed(
      context,
      RoutesNames.verificationResultsView,
      arguments: VerificationResultsArgs(
        draft: widget.draft,
        batches: _collectBatches(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              AppConstants.screenHorizontalPadding.w,
              AppConstants.paddingM.h,
              AppConstants.screenHorizontalPadding.w,
              AppConstants.paddingL.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AddProductStepIndicator(
                  step: 2,
                  stepName: AppStrings.expirationStepName,
                ),
                SizedBox(height: AppConstants.paddingL.h),

                Text(
                  AppStrings.expirationTitle,
                  style: TextStyle(
                    fontFamily: 'PlayfairDisplay',
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  AppStrings.expirationSubtitle,
                  style: TextStyle(
                    fontFamily: 'DmSans',
                    fontSize: 13.sp,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: AppConstants.paddingL.h),

                // --- Primary date + camera verification ---
                _PrimaryDateCard(
                  date: _primaryDate,
                  onPickDate: () => _pickDate(
                    current: _primaryDate,
                    onPicked: (picked) =>
                        setState(() => _primaryDate = picked),
                  ),
                  onVerifyViaCamera: _verifyViaCamera,
                ),
                SizedBox(height: AppConstants.paddingM.h),

                // --- Same-date toggle ---
                _SameDateToggle(
                  value: _sameDateForAll,
                  quantity: widget.draft.quantity,
                  onChanged: (value) =>
                      setState(() => _sameDateForAll = value),
                ),

                // --- Per-batch list ---
                if (!_sameDateForAll) ...[
                  SizedBox(height: AppConstants.paddingM.h),
                  Text(
                    AppStrings.individualBatchesTitle,
                    style: TextStyle(
                      fontFamily: 'DmSans',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                      color: AppColors.outline,
                    ),
                  ),
                  SizedBox(height: AppConstants.paddingS.h),
                  for (var index = 0; index < _batches.length; index++) ...[
                    ExpirationBatchTile(
                      date: _batches[index].date,
                      quantityController: _batches[index].quantity,
                      photo: _batches[index].photo,
                      onPickDate: () => _pickDate(
                        current: _batches[index].date,
                        onPicked: (picked) =>
                            setState(() => _batches[index].date = picked),
                      ),
                      onPickPhoto: () => _pickBatchPhoto(_batches[index]),
                      onDelete: () => _removeBatch(index),
                    ),
                    SizedBox(height: AppConstants.paddingS.h),
                  ],
                  _AddBatchButton(onTap: _addBatch),
                ],

                SizedBox(height: AppConstants.paddingL.h),

                // --- Summary ---
                VerificationStatusCard(
                  productName: widget.draft.name,
                  quantity: widget.draft.quantity,
                  earliestDate: _earliestDate,
                ),
                SizedBox(height: AppConstants.paddingS.h),
                Text(
                  AppStrings.verifyDisclaimer,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'DmSans',
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),

        // --- Bottom action ---
        _VerifyBar(enabled: _canVerify, onVerify: _onVerify),
      ],
    );
  }
}

class _PrimaryDateCard extends StatelessWidget {
  const _PrimaryDateCard({
    required this.date,
    required this.onPickDate,
    required this.onVerifyViaCamera,
  });

  final DateTime? date;
  final VoidCallback onPickDate;
  final VoidCallback onVerifyViaCamera;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppConstants.paddingM.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExpirationDateField(
            label: AppStrings.manualExpiryLabel,
            date: date,
            onTap: onPickDate,
          ),
          SizedBox(height: AppConstants.paddingM.h),
          Divider(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
          SizedBox(height: AppConstants.paddingS.h),
          CustomButton(
            label: AppStrings.verifyViaCamera,
            suffixIcon: Icons.photo_camera_outlined,
            onTap: onVerifyViaCamera,
          ),
          SizedBox(height: 6.h),
          Text(
            AppStrings.verifyViaCameraHint,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'DmSans',
              fontSize: 11.sp,
              fontStyle: FontStyle.italic,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SameDateToggle extends StatelessWidget {
  const _SameDateToggle({
    required this.value,
    required this.quantity,
    required this.onChanged,
  });

  final bool value;
  final int quantity;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: EdgeInsets.all(AppConstants.paddingS.r),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
        ),
        child: Row(
          children: [
            Checkbox(
              value: value,
              onChanged: (checked) => onChanged(checked ?? false),
              activeColor: AppColors.primary,
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.sameDateForAll,
                    style: TextStyle(
                      fontFamily: 'DmSans',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '${AppStrings.appliesToAllUnits} $quantity',
                    style: TextStyle(
                      fontFamily: 'DmSans',
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddBatchButton extends StatelessWidget {
  const _AddBatchButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: AppConstants.paddingM.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
          border: Border.all(
            color: AppColors.outlineVariant,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded, size: 20.r, color: AppColors.primary),
            SizedBox(width: 8.w),
            Text(
              AppStrings.addAnotherBatch,
              style: TextStyle(
                fontFamily: 'DmSans',
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VerifyBar extends StatelessWidget {
  const _VerifyBar({required this.enabled, required this.onVerify});

  final bool enabled;
  final VoidCallback onVerify;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppConstants.screenHorizontalPadding.w,
            AppConstants.paddingM.h,
            AppConstants.screenHorizontalPadding.w,
            AppConstants.paddingM.h,
          ),
          child: Opacity(
            opacity: enabled ? 1 : 0.5,
            child: CustomButton(
              label: AppStrings.verifyDates,
              suffixIcon: Icons.check_rounded,
              onTap: enabled ? onVerify : () {},
            ),
          ),
        ),
      ),
    );
  }
}
