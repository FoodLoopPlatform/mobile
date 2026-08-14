import 'package:equatable/equatable.dart';
import 'package:foodloop/features/support/data/models/support_ticket_model.dart';

abstract class SupportState extends Equatable {
  const SupportState();

  @override
  List<Object?> get props => [];
}

// --- Inbox states ---
class SupportInitial extends SupportState {
  const SupportInitial();
}

class SupportTicketsLoading extends SupportState {
  const SupportTicketsLoading();
}

class SupportTicketsLoaded extends SupportState {
  final List<SupportTicketModel> tickets;

  const SupportTicketsLoaded(this.tickets);

  @override
  List<Object?> get props => [tickets];
}

class SupportTicketsFail extends SupportState {
  final String message;

  const SupportTicketsFail(this.message);

  @override
  List<Object?> get props => [message];
}

// --- Ticket detail states ---
class SupportTicketDetailLoading extends SupportState {
  const SupportTicketDetailLoading();
}

class SupportTicketDetailLoaded extends SupportState {
  final SupportTicketModel ticket;

  const SupportTicketDetailLoaded(this.ticket);

  @override
  List<Object?> get props => [ticket];
}

class SupportTicketDetailFail extends SupportState {
  final String message;

  const SupportTicketDetailFail(this.message);

  @override
  List<Object?> get props => [message];
}

// --- Create ticket states ---
class SupportCreateTicketLoading extends SupportState {
  const SupportCreateTicketLoading();
}

class SupportCreateTicketSuccess extends SupportState {
  const SupportCreateTicketSuccess();
}

class SupportCreateTicketFail extends SupportState {
  final String message;

  const SupportCreateTicketFail(this.message);

  @override
  List<Object?> get props => [message];
}

// --- Reply states (overlaid on detail) ---
class SupportReplyLoading extends SupportState {
  final SupportTicketModel ticket;

  const SupportReplyLoading(this.ticket);

  @override
  List<Object?> get props => [ticket];
}

class SupportReplySuccess extends SupportState {
  final SupportTicketModel ticket;

  const SupportReplySuccess(this.ticket);

  @override
  List<Object?> get props => [ticket];
}

class SupportReplyFail extends SupportState {
  final SupportTicketModel ticket;
  final String message;

  const SupportReplyFail(this.ticket, this.message);

  @override
  List<Object?> get props => [ticket, message];
}
