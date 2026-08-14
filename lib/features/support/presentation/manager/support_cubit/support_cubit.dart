import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodloop/core/api_helper/api_manager.dart';
import 'package:foodloop/features/support/data/data_sources/support_remote_data_source.dart';
import 'package:foodloop/features/support/presentation/manager/support_cubit/support_state.dart';

class SupportCubit extends Cubit<SupportState> {
  final SupportRemoteDataSource _dataSource;

  SupportCubit()
      : _dataSource = SupportRemoteDataSource(ApiManager()),
        super(const SupportInitial());

  /// Loads all support tickets for the inbox.
  Future<void> loadTickets() async {
    emit(const SupportTicketsLoading());
    try {
      final tickets = await _dataSource.getTickets();
      emit(SupportTicketsLoaded(tickets));
    } catch (e) {
      emit(SupportTicketsFail(e.toString()));
    }
  }

  /// Loads a single ticket's details including messages.
  Future<void> loadTicketDetail(String ticketId) async {
    emit(const SupportTicketDetailLoading());
    try {
      final ticket = await _dataSource.getTicketById(ticketId);
      emit(SupportTicketDetailLoaded(ticket));
    } catch (e) {
      emit(SupportTicketDetailFail(e.toString()));
    }
  }

  /// Creates a new support ticket.
  Future<void> createTicket({
    required String category,
    required String message,
  }) async {
    emit(const SupportCreateTicketLoading());
    try {
      await _dataSource.createTicket(category: category, message: message);
      emit(const SupportCreateTicketSuccess());
    } catch (e) {
      emit(SupportCreateTicketFail(e.toString()));
    }
  }

  /// Sends a reply to a ticket, then refreshes the ticket detail.
  Future<void> replyToTicket({
    required String ticketId,
    required String message,
  }) async {
    // Keep the current ticket visible while posting the reply
    final currentState = state;
    if (currentState is! SupportTicketDetailLoaded) return;

    emit(SupportReplyLoading(currentState.ticket));
    try {
      await _dataSource.replyToTicket(ticketId: ticketId, message: message);
      // Refresh the ticket to get the new message
      final updated = await _dataSource.getTicketById(ticketId);
      emit(SupportReplySuccess(updated));
      emit(SupportTicketDetailLoaded(updated));
    } catch (e) {
      emit(SupportReplyFail(currentState.ticket, e.toString()));
      emit(SupportTicketDetailLoaded(currentState.ticket));
    }
  }
}
