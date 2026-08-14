import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/support/data/models/support_ticket_model.dart';
import 'package:foodloop/features/support/presentation/manager/support_cubit/support_cubit.dart';
import 'package:foodloop/features/support/presentation/manager/support_cubit/support_state.dart';

class TicketDetailsBody extends StatefulWidget {
  const TicketDetailsBody({super.key, required this.ticketId});
  final String ticketId;

  @override
  State<TicketDetailsBody> createState() => _TicketDetailsBodyState();
}

class _TicketDetailsBodyState extends State<TicketDetailsBody> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendReply(BuildContext context) {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    _messageController.clear();
    context.read<SupportCubit>().replyToTicket(
          ticketId: widget.ticketId,
          message: text,
        );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SupportCubit, SupportState>(
      listener: (context, state) {
        if (state is SupportTicketDetailLoaded || state is SupportReplySuccess) {
          _scrollToBottom();
        }
        if (state is SupportReplyFail) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppStrings.replyError,
                style: const TextStyle(fontFamily: 'DmSans'),
              ),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is SupportTicketDetailLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is SupportTicketDetailFail) {
          return Center(
            child: Text(
              state.message,
              style: TextStyle(
                fontFamily: 'DmSans',
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
            ),
          );
        }

        SupportTicketModel? ticket;
        bool isSendingReply = false;

        if (state is SupportTicketDetailLoaded) {
          ticket = state.ticket;
        } else if (state is SupportReplyLoading) {
          ticket = state.ticket;
          isSendingReply = true;
        } else if (state is SupportReplySuccess) {
          ticket = state.ticket;
        } else if (state is SupportReplyFail) {
          ticket = state.ticket;
        }

        if (ticket == null) return const SizedBox.shrink();

        return Column(
          children: [
            // Status header
            _TicketStatusHeader(ticket: ticket),
            // Chat messages
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.screenHorizontalPadding.w,
                  vertical: AppConstants.paddingM.h,
                ),
                itemCount: (ticket.messages?.length ?? 0) +
                    (isSendingReply ? 1 : 0),
                itemBuilder: (context, i) {
                  final messages = ticket!.messages ?? [];
                  if (i < messages.length) {
                    return _ChatBubble(
                      message: messages[i],
                      currentUserId: ticket.userId,
                    );
                  }
                  // Sending indicator
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: SizedBox(
                        width: 20.r,
                        height: 20.r,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Message input
            _MessageInput(
              controller: _messageController,
              onSend: () => _sendReply(context),
              isSending: isSendingReply,
            ),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Status Header
// ─────────────────────────────────────────────────────────────────────────────

class _TicketStatusHeader extends StatelessWidget {
  const _TicketStatusHeader({required this.ticket});
  final SupportTicketModel ticket;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: AppConstants.screenHorizontalPadding.w,
          vertical: AppConstants.paddingS.h),
      padding: EdgeInsets.all(AppConstants.paddingM.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _StatusChip(status: ticket.status),
              SizedBox(width: 8.w),
              _PriorityChip(priority: ticket.priority),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            ticket.category,
            style: TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 18.sp,
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
          ),
          SizedBox(height: 8.h),
          Divider(
              height: 1,
              color: AppColors.outlineVariant.withValues(alpha: 0.4)),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(Icons.access_time_rounded,
                  size: 13.r, color: AppColors.outline),
              SizedBox(width: 4.w),
              Text(
                _formatDateTime(ticket.createdAt),
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 11.sp,
                  color: AppColors.outline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}  ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.r,
            height: 6.r,
            decoration: BoxDecoration(color: textColor, shape: BoxShape.circle),
          ),
          SizedBox(width: 5.w),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'DmSans',
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriorityChip extends StatelessWidget {
  const _PriorityChip({required this.priority});
  final String priority;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppConstants.radiusFull.r),
      ),
      child: Text(
        priority,
        style: TextStyle(
          fontFamily: 'DmSans',
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Chat Bubble
// ─────────────────────────────────────────────────────────────────────────────

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message, required this.currentUserId});
  final SupportMessageModel message;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    final isMe = message.senderId == currentUserId;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Sender name
          Padding(
            padding: EdgeInsets.only(
              bottom: 4.h,
              left: isMe ? 0 : 4.w,
              right: isMe ? 4.w : 0,
            ),
            child: Text(
              isMe ? 'You' : message.senderName,
              style: TextStyle(
                fontFamily: 'DmSans',
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.outline,
              ),
            ),
          ),
          // Bubble
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe) ...[
                CircleAvatar(
                  radius: 16.r,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                  child: Text(
                    message.senderName.isNotEmpty
                        ? message.senderName[0].toUpperCase()
                        : 'S',
                    style: TextStyle(
                      fontFamily: 'DmSans',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
              ],
              Flexible(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 0.72.sw),
                  padding: EdgeInsets.symmetric(
                      horizontal: 14.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: isMe
                        ? AppColors.primary
                        : AppColors.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppConstants.radiusL.r),
                      topRight: Radius.circular(AppConstants.radiusL.r),
                      bottomLeft: Radius.circular(
                          isMe ? AppConstants.radiusL.r : AppConstants.radiusS.r),
                      bottomRight: Radius.circular(
                          isMe ? AppConstants.radiusS.r : AppConstants.radiusL.r),
                    ),
                    border: isMe
                        ? null
                        : Border.all(
                            color: AppColors.outlineVariant
                                .withValues(alpha: 0.5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.message,
                    style: TextStyle(
                      fontFamily: 'DmSans',
                      fontSize: 14.sp,
                      color: isMe
                          ? AppColors.textOnPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              if (isMe) SizedBox(width: 4.w),
            ],
          ),
          // Time
          Padding(
            padding: EdgeInsets.only(
              top: 4.h,
              right: isMe ? 4.w : 0,
              left: isMe ? 0 : 44.w,
            ),
            child: Text(
              '${message.createdAt.hour.toString().padLeft(2, '0')}:${message.createdAt.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 10.sp,
                color: AppColors.outline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Message Input Bar
// ─────────────────────────────────────────────────────────────────────────────

class _MessageInput extends StatelessWidget {
  const _MessageInput({
    required this.controller,
    required this.onSend,
    required this.isSending,
  });
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isSending;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppConstants.screenHorizontalPadding.w,
        AppConstants.paddingS.h,
        AppConstants.screenHorizontalPadding.w,
        AppConstants.paddingM.h + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(
              color: AppColors.outlineVariant.withValues(alpha: 0.4)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppConstants.radiusFull.r),
                border: Border.all(color: AppColors.outlineVariant),
              ),
              child: TextField(
                controller: controller,
                maxLines: 4,
                minLines: 1,
                style: TextStyle(
                  fontFamily: 'DmSans',
                  fontSize: 14.sp,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: AppStrings.typeMessageHint,
                  hintStyle: TextStyle(
                    fontFamily: 'DmSans',
                    fontSize: 14.sp,
                    color: AppColors.outline,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w, vertical: 10.h),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          GestureDetector(
            onTap: isSending ? null : onSend,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: isSending
                    ? AppColors.primary.withValues(alpha: 0.5)
                    : AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: isSending
                  ? Padding(
                      padding: EdgeInsets.all(12.r),
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 20.r,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
