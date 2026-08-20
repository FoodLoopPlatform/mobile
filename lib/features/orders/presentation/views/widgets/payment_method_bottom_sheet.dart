import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/core/api_helper/api_manager.dart';
import 'package:foodloop/features/profile/data/data_sources/profile_remote_data_source.dart';
import 'package:foodloop/features/profile/data/repositories/profile_repository.dart';

class PaymentMethodBottomSheet extends StatefulWidget {
  final double totalAmount;

  const PaymentMethodBottomSheet({super.key, required this.totalAmount});

  @override
  State<PaymentMethodBottomSheet> createState() => _PaymentMethodBottomSheetState();
}

class _PaymentMethodBottomSheetState extends State<PaymentMethodBottomSheet> {
  bool _isLoadingWallet = true;
  double _walletBalance = 0.0;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchWalletBalance();
  }

  Future<void> _fetchWalletBalance() async {
    try {
      final apiManager = context.read<ApiManager>();
      final repo = ProfileRepository(ProfileRemoteDataSource(apiManager));
      final wallet = await repo.getWalletBalance();
      if (mounted) {
        setState(() {
          _walletBalance = wallet.walletBalance;
          _isLoadingWallet = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load wallet';
          _isLoadingWallet = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppConstants.paddingL.r),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.radiusL.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Payment Method',
            style: TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Order Total: EGP ${widget.totalAmount.toStringAsFixed(2)}',
            style: TextStyle(
              fontFamily: 'DmSans',
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 24.h),
          if (_isLoadingWallet)
            Center(child: CircularProgressIndicator(color: AppColors.primary))
          else if (_error != null)
            Text(_error!, style: TextStyle(color: AppColors.error))
          else ...[
            _buildOption(
              icon: Icons.account_balance_wallet_outlined,
              title: 'Pay with Wallet',
              subtitle: 'Balance: EGP ${_walletBalance.toStringAsFixed(2)}',
              enabled: _walletBalance >= widget.totalAmount,
              onTap: () => Navigator.of(context).pop('wallet'),
            ),
            SizedBox(height: 12.h),
          ],
          _buildOption(
            icon: Icons.credit_card,
            title: 'Credit / Debit Card',
            subtitle: 'Powered by Paymob',
            enabled: true,
            onTap: () => Navigator.of(context).pop('card'),
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
      child: Container(
        padding: EdgeInsets.all(AppConstants.paddingM.r),
        decoration: BoxDecoration(
          border: Border.all(color: enabled ? AppColors.primary : AppColors.outlineVariant),
          borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
          color: enabled ? AppColors.primary.withValues(alpha: 0.05) : AppColors.surface,
        ),
        child: Row(
          children: [
            Icon(icon, color: enabled ? AppColors.primary : AppColors.neutral),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'DmSans',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: enabled ? AppColors.textPrimary : AppColors.neutral,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'DmSans',
                      fontSize: 14.sp,
                      color: enabled ? AppColors.textSecondary : AppColors.neutralLight,
                    ),
                  ),
                  if (!enabled && title.contains('Wallet')) ...[
                    SizedBox(height: 4.h),
                    Text(
                      'Insufficient balance',
                      style: TextStyle(
                        fontFamily: 'DmSans',
                        fontSize: 12.sp,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (enabled) Icon(Icons.arrow_forward_ios, size: 16.r, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
