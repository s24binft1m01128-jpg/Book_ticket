import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookticket/models/ticket_model.dart';
import 'package:bookticket/utils/app_info_list.dart';

class TicketNotifier extends StateNotifier<List<TicketModel>> {
  TicketNotifier()
      : super(ticketList.map((ticket) => TicketModel.fromMap(ticket)).toList());

  void addTicket(TicketModel ticket) {
    state = [...state, ticket];
  }

  void removeTicket(String bookingCode) {
    state = state.where((ticket) => ticket.bookingCode != bookingCode).toList();
  }

  void updateTicket(TicketModel updatedTicket) {
    state = state.map((ticket) {
      if (ticket.bookingCode == updatedTicket.bookingCode) {
        return updatedTicket;
      }
      return ticket;
    }).toList();
  }
}

final ticketListProvider =
    StateNotifierProvider<TicketNotifier, List<TicketModel>>((ref) {
  return TicketNotifier();
});

final ticketByIdProvider = FutureProvider.family<TicketModel?, String>((ref, id) {
  final tickets = ref.watch(ticketListProvider);
  return tickets.firstWhere(
    (t) => t.number == id,
    orElse: () => const TicketModel(
      number: '',
      airline: '',
      fromCode: '',
      fromName: '',
      toCode: '',
      toName: '',
      flyingTime: '',
      date: '',
      departureTime: '',
      arrivalTime: '',
      gate: '',
      seat: '',
      ticketClass: '',
      price: 0,
      bookingCode: '',
      eTicket: '',
      passport: '',
      passenger: '',
      paymentLast4: '',
      terminal: '',
      status: '',
    ),
  );
});
