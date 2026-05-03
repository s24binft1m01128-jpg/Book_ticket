import 'package:bookticket/models/ticket_model.dart';
import 'package:bookticket/providers/ticket_provider.dart';
import 'package:bookticket/utils/app_layout.dart';
import 'package:bookticket/utils/app_styles.dart';
import 'package:bookticket/widgets/ticket_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class TicketsScreen extends ConsumerWidget {
  const TicketsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<TicketModel> tickets = ref.watch(ticketListProvider);
    final horizontalPadding = AppLayout.horizontalPadding(context);

    return Scaffold(
      backgroundColor: Styles.bgcolor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: AppLayout.contentWidth(context),
            ),
            child: tickets.isEmpty
                ? const Center(child: Text('No tickets found.'))
                : ListView(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      20,
                      horizontalPadding,
                      28,
                    ),
                    children: [
                      const Text(
                        'My Tickets',
                        style: Styles.headlineStyle1,
                      ),
                      const Gap(20),
                      ...tickets.map(
                        (ticket) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: TicketView(
                            ticket: ticket,
                            wholeScreen: true,
                            onTap: () =>
                                context.push('/tickets/${ticket.number}'),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
