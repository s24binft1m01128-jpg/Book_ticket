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
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              color: Styles.surfaceColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Styles.lineColor.withValues(alpha: 0.6),
                              ),
                              boxShadow: Styles.softShadow,
                            ),
                            child: Icon(
                              Icons.confirmation_number_outlined,
                              size: 44,
                              color: Styles.primarycolor.withValues(alpha: 0.85),
                            ),
                          ),
                          const Gap(24),
                          Text(
                            'No tickets yet',
                            style: Styles.headlineStyle2,
                            textAlign: TextAlign.center,
                          ),
                          const Gap(8),
                          Text(
                            'Book a flight from Home or Search — your boarding passes show up here.',
                            style: Styles.headlineStyle4,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      20,
                      horizontalPadding,
                      28,
                    ),
                    children: [
                      Text(
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
