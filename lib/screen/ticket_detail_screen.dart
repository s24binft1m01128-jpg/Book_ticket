import 'package:bookticket/models/ticket_model.dart';
import 'package:bookticket/providers/ticket_provider.dart';
import 'package:bookticket/screen/checkout_screen.dart';
import 'package:bookticket/utils/app_layout.dart';
import 'package:bookticket/utils/app_styles.dart';
import 'package:bookticket/utils/notification_service.dart';
import 'package:bookticket/widgets/layout_builder_widget.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class TicketDetailScreen extends ConsumerWidget {
  final String ticketId;

  const TicketDetailScreen({super.key, required this.ticketId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketAsync = ref.watch(ticketByIdProvider(ticketId));
    final horizontalPadding = AppLayout.horizontalPadding(context);

    return ticketAsync.when(
      data: (ticket) {
        if (ticket == null || ticket.number.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Ticket Details')),
            body: const Center(child: Text('Ticket not found')),
          );
        }

        return Scaffold(
          backgroundColor: Styles.bgcolor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: AppLayout.contentWidth(context),
                ),
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    0,
                    horizontalPadding,
                    28,
                  ),
                  children: [
                    const Gap(16),
                    _TicketHero(ticket: ticket),
                    const Gap(24),
                    _BoardingDetails(ticket: ticket),
                    const Gap(24),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () {
                              NotificationService().showSuccess(
                                context,
                                'Ticket ${ticket.bookingCode} shared!',
                              );
                            },
                            icon: const Icon(
                                FluentSystemIcons.ic_fluent_share_regular),
                            label: const Text('Share'),
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () {
                              NotificationService().showSuccess(
                                context,
                                'Pass ${ticket.bookingCode} saved to Photos',
                              );
                            },
                            icon: const Icon(FluentSystemIcons
                                .ic_fluent_arrow_download_regular),
                            label: const Text('Download'),
                          ),
                        ),
                      ],
                    ),
                    const Gap(24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(24),
                              ),
                            ),
                            builder: (context) => _PassengerSelectionSheet(
                              ticket: ticket,
                            ),
                          );
                        },
                        icon: const Icon(
                            FluentSystemIcons.ic_fluent_ticket_regular),
                        label: const Text('Book Now'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Styles.primarycolor,
                        ),
                      ),
                    ),
                    const Gap(24),
                    Center(
                      child: BarcodeWidget(
                        barcode: Barcode.qrCode(),
                        data: ticket.bookingCode,
                        width: 160,
                        height: 160,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Loading')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _TicketHero extends StatelessWidget {
  final TicketModel ticket;

  const _TicketHero({required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF3B3B3B), Color(0xFF2F6FED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: Styles.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ticket.airline,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                '${ticket.fromCode} → ${ticket.toCode}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const Gap(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ticket.fromCode,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    ticket.departureTime,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    ticket.flyingTime,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                  const Icon(Icons.arrow_right, color: Colors.white),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    ticket.toCode,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    ticket.arrivalTime,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BoardingDetails extends StatelessWidget {
  final TicketModel ticket;

  const _BoardingDetails({required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
        color: Colors.white,
        boxShadow: Styles.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DetailRow(label: 'Passenger', value: ticket.passenger),
          const Gap(12),
          _DetailRow(label: 'Passport', value: ticket.passport),
          const Gap(12),
          LayoutBuilderWidget(sections: 12, isColor: true),
          const Gap(12),
          _DetailRow(label: 'E-Ticket', value: ticket.eTicket),
          const Gap(12),
          _DetailRow(label: 'Booking Code', value: ticket.bookingCode),
          const Gap(12),
          LayoutBuilderWidget(sections: 12, isColor: true),
          const Gap(12),
          _DetailRow(label: 'Terminal', value: ticket.terminal),
          const Gap(12),
          _DetailRow(
              label: 'Seat', value: '${ticket.seat} (${ticket.ticketClass})'),
          const Gap(12),
          LayoutBuilderWidget(sections: 12, isColor: true),
          const Gap(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment method',
                    style: Styles.headlineStyle4,
                  ),
                  const Gap(6),
                  Row(
                    children: [
                      Text(
                        '••••',
                        style: Styles.textStyle,
                      ),
                      const Gap(8),
                      Text(
                        ticket.paymentLast4,
                        style: Styles.textStyle.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                '\$${ticket.price.toStringAsFixed(2)}',
                style: Styles.headlineStyle1,
              ),
            ],
          ),
          const Gap(16),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              color: Styles.bgcolor,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: BarcodeWidget(
                barcode: Barcode.code128(),
                data: ticket.bookingCode,
                drawText: false,
                height: 70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Styles.headlineStyle4),
        Text(value,
            style: Styles.textStyle.copyWith(fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _PassengerSelectionSheet extends StatefulWidget {
  final TicketModel ticket;

  const _PassengerSelectionSheet({required this.ticket});

  @override
  State<_PassengerSelectionSheet> createState() =>
      _PassengerSelectionSheetState();
}

class _PassengerSelectionSheetState extends State<_PassengerSelectionSheet> {
  late TextEditingController passengerNameController;

  @override
  void initState() {
    super.initState();
    passengerNameController = TextEditingController(
      text: widget.ticket.passenger,
    );
  }

  @override
  void dispose() {
    passengerNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Gap(20),
            Text(
              'Passenger Details',
              style: Styles.headlineStyle2,
            ),
            const Gap(12),
            Text(
              'Enter the name of the person traveling',
              style: Styles.textStyle.copyWith(color: Colors.grey),
            ),
            const Gap(24),
            TextField(
              controller: passengerNameController,
              decoration: InputDecoration(
                labelText: 'Passenger Name',
                hintText: 'Full Name',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Styles.primarycolor,
                    width: 2,
                  ),
                ),
              ),
            ),
            const Gap(32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _proceedToCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Styles.primarycolor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Continue to Checkout',
                  style: Styles.headlineStyle3.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _proceedToCheckout() {
    if (passengerNameController.text.isEmpty) {
      NotificationService().showError(
        context,
        'Please enter passenger name',
      );
      return;
    }

    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(
          ticket: widget.ticket,
          passengerName: passengerNameController.text,
        ),
      ),
    );
  }
}
