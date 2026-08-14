import 'package:foodloop/core/api_helper/api_constants.dart';
import 'package:foodloop/core/api_helper/api_manager.dart';
import 'package:foodloop/features/support/data/models/support_ticket_model.dart';

class SupportRemoteDataSource {
  final ApiManager _apiManager;

  SupportRemoteDataSource(this._apiManager);

  Future<List<SupportTicketModel>> getTickets() async {
    final response = await _apiManager.get(ApiConstants.supportTicketsEndpoint);
    final data = response.data as Map<String, dynamic>;
    final list = data['data'] as List<dynamic>? ?? [];
    return list
        .map((e) => SupportTicketModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<SupportTicketModel> getTicketById(String id) async {
    final response =
        await _apiManager.get(ApiConstants.supportTicketByIdEndpoint(id));
    final data = response.data as Map<String, dynamic>;
    return SupportTicketModel.fromJson(data['data'] as Map<String, dynamic>);
  }

  Future<void> createTicket({
    required String category,
    required String message,
  }) async {
    await _apiManager.post(ApiConstants.supportTicketsEndpoint, {
      'category': category,
      'message': message,
      'priority': 'Normal',
    });
  }

  Future<void> replyToTicket({
    required String ticketId,
    required String message,
  }) async {
    await _apiManager.post(
      ApiConstants.supportTicketReplyEndpoint(ticketId),
      {'message': message},
    );
  }
}
