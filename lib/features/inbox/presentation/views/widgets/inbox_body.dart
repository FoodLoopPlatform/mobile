import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/routes_manager/routes_names.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/support/data/models/support_ticket_model.dart';
import 'package:foodloop/features/support/presentation/manager/support_cubit/support_cubit.dart';
import 'package:foodloop/features/support/presentation/manager/support_cubit/support_state.dart';

class InboxBody extends StatelessWidget {
  const InboxBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupportCubit, SupportState>(
      builder: (context, state) {
        if (state is SupportTicketsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is SupportTicketsFail) {
          return _InboxError(
            message: state.message,
            onRetry: () => context.read<SupportCubit>().loadTickets(),
          );
        }
        if (state is SupportTicketsLoaded) {
          if (state.tickets.isEmpty) return const _InboxEmpty();
          return RefreshIndicator(
            onRefresh: () => context.read<SupportCubit>().loadTickets(),
            child: ListView.separated(
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.screenHorizontalPadding.w,
                vertical: AppConstants.paddingM.h,
              ),
              itemCount: state.tickets.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, i) => _TicketCard(ticket: state.tickets[i]),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Ticket Card
// ─────────────────────────────────────────────────────────────────────────────

class _TicketCard extends StatelessWidget {
  const _TicketCard({required this.ticket});
  final SupportTicketModel ticket;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        RoutesNames.ticketDetailsView,
        arguments: ticket.id,
      ),
      child: Container(
        padding: EdgeInsets.all(AppConstants.paddingM.r),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
          border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _StatusBadge(status: ticket.status),
                const Spacer(),
                Text(
                  _formatDate(ticket.createdAt),
                  style: TextStyle(
                    fontFamily: 'DmSans',
                    fontSize: 11.sp,
                    color: AppColors.outline,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              ticket.category,
              style: TextStyle(
                fontFamily: 'PlayfairDisplay',
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              ticket.userEmail,
              style: TextStyle(
                fontFamily: 'DmSans',
                fontSize: 12.sp,
                color: AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Icon(Icons.access_time_rounded,
                    size: 13.r, color: AppColors.outline),
                SizedBox(width: 4.w),
                Text(
                  _formatTime(ticket.createdAt),
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 11.sp,
                    color: AppColors.outline,
                  ),
                ),
                const Spacer(),
                Icon(Icons.chevron_right_rounded,
                    size: 20.r, color: AppColors.outline),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';

  String _formatTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status.toLowerCase()) {
      case 'open':
        bgColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF2E7D32);
        label = AppStrings.ticketStatusOpen;
        break;
      case 'closed':
        bgColor = const Color(0xFFEEEEEE);
        textColor = const Color(0xFF616161);
        label = AppStrings.ticketStatusClosed;
        break;
      case 'in progress':
        bgColor = const Color(0xFFFFF3E0);
        textColor = const Color(0xFFE65100);
        label = AppStrings.ticketStatusInProgress;
        break;
      default:
        bgColor = const Color(0xFFE3F2FD);
        textColor = const Color(0xFF1565C0);
        label = status;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusFull.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'DmSans',
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty & Error states
// ─────────────────────────────────────────────────────────────────────────────

class _InboxEmpty extends StatelessWidget {
  const _InboxEmpty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppConstants.paddingL.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_rounded, size: 72.r, color: AppColors.neutral),
            SizedBox(height: 16.h),
            Text(
              AppStrings.inboxEmptyTitle,
              style: TextStyle(
                fontFamily: 'PlayfairDisplay',
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              AppStrings.inboxEmptySubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'DmSans',
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InboxError extends StatelessWidget {
  const _InboxError({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppConstants.paddingL.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 40.r, color: AppColors.error),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'DmSans',
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: onRetry,
              child: Text(
                AppStrings.retry,
                style: TextStyle(fontFamily: 'DmSans', color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
