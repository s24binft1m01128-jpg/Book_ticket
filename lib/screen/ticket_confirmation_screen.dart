import 'package:bookticket/models/payment_model.dart';
import 'package:bookticket/models/ticket_model.dart';
import 'package:bookticket/utils/app_layout.dart';
import 'package:bookticket/utils/app_styles.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class TicketConfirmationScreen extends StatelessWidget {
  final TicketModel ticket;
  final Booking booking;

  const TicketConfirmationScreen({
    super.key,
    required this.ticket,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = AppLayout.horizontalPadding(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.go('/');
      },
      child: Scaffold(
        backgroundColor: Styles.bgcolor,
        appBar: AppBar(
          backgroundColor: Styles.bgcolor,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            'Booking Confirmed',
            style: Styles.headlineStyle2,
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: AppLayout.contentWidth(context),
              ),
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 16,
                ),
                children: [
                  // Success Badge
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        FluentSystemIcons.ic_fluent_checkmark_circle_regular,
                        color: Colors.green,
                        size: 40,
                      ),
                    ),
                  ),
                  const Gap(16),
                  Center(
                    child: Text(
                      'Payment Successful',
                      style: Styles.headlineStyle2.copyWith(
                        color: Colors.green,
                      ),
                    ),
                  ),
                  const Gap(8),
                  Center(
                    child: Text(
                      'Your booking has been confirmed',
                      style: Styles.textStyle.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const Gap(32),

                  // Booking Code Section
                  _buildBookingCodeSection(),
                  const Gap(24),

                  // Ticket Details Card
                  _buildTicketDetailsCard(context),
                  const Gap(24),

                  // Barcode Section
                  _buildBarcodeSection(),
                  const Gap(24),

                  // QR Code Section
                  _buildQRCodeSection(),
                  const Gap(24),

                  // Passenger Info
                  _buildPassengerSection(),
                  const Gap(24),

                  // Payment Method Used
                  _buildPaymentMethodSection(),
                  const Gap(32),

                  // Action Buttons
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _shareBooking(context),
                      icon: const Icon(
                        FluentSystemIcons.ic_fluent_share_regular,
                      ),
                      label: const Text('Share Booking'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Styles.primarycolor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const Gap(12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => context.go('/'),
                      icon: const Icon(
                        FluentSystemIcons.ic_fluent_home_regular,
                      ),
                      label: const Text('Back to Home'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Styles.primarycolor,
                          width: 2,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const Gap(16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookingCodeSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Styles.primarycolor,
            Styles.primarycolor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Styles.primarycolor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Booking Code',
            style: Styles.textStyle.copyWith(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
          const Gap(8),
          Text(
            ticket.bookingCode,
            style: Styles.headlineStyle1.copyWith(
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
          const Gap(16),
          Text(
            'Keep this code for check-in',
            style: Styles.textStyle.copyWith(
              color: Colors.white.withOpacity(0.8),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketDetailsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Route
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'From',
                    style: Styles.textStyle.copyWith(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    ticket.fromCode,
                    style: Styles.headlineStyle2,
                  ),
                  const Gap(2),
                  Text(
                    ticket.fromName,
                    style: Styles.textStyle.copyWith(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Icon(
                    FluentSystemIcons.ic_fluent_airplane_regular,
                    color: Styles.primarycolor,
                    size: 24,
                  ),
                  const Gap(4),
                  Text(
                    ticket.flyingTime,
                    style: Styles.headlineStyle4.copyWith(fontSize: 10),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'To',
                    style: Styles.textStyle.copyWith(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    ticket.toCode,
                    style: Styles.headlineStyle2,
                  ),
                  const Gap(2),
                  Text(
                    ticket.toName,
                    style: Styles.textStyle.copyWith(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 24),

          // Flight Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailColumn('Terminal', ticket.terminal),
              _buildDetailColumn('Gate', ticket.gate),
              _buildDetailColumn('Seat', ticket.seat),
              _buildDetailColumn('Date', ticket.date),
            ],
          ),
          const Gap(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailColumn('Departure', ticket.departureTime),
              _buildDetailColumn('Arrival', ticket.arrivalTime),
              _buildDetailColumn('Class', ticket.ticketClass),
              _buildDetailColumn('Price', '\$${ticket.price}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Styles.textStyle.copyWith(
            color: Colors.grey,
            fontSize: 9,
          ),
        ),
        const Gap(4),
        Text(
          value,
          style: Styles.headlineStyle4.copyWith(fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildBarcodeSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Barcode',
            style: Styles.headlineStyle4,
          ),
          const Gap(16),
          Center(
            child: BarcodeWidget(
              barcode: Barcode.code128(),
              data: ticket.number,
              drawText: true,
              height: 60,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRCodeSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'E-Ticket QR Code',
            style: Styles.headlineStyle4,
          ),
          const Gap(16),
          Center(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              ),
              child: BarcodeWidget(
                barcode: Barcode.qrCode(),
                data:
                    '${ticket.number}|${ticket.bookingCode}|${booking.bookingId}',
                width: 150,
                height: 150,
              ),
            ),
          ),
          const Gap(12),
          Center(
            child: Text(
              'Scan this code at the airport for check-in',
              style: Styles.textStyle.copyWith(
                color: Colors.grey,
                fontSize: 10,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Styles.primarycolor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              FluentSystemIcons.ic_fluent_person_regular,
              color: Styles.primarycolor,
            ),
          ),
          const Gap(12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Passenger',
                style: Styles.textStyle.copyWith(
                  color: Colors.grey,
                  fontSize: 10,
                ),
              ),
              const Gap(4),
              Text(
                booking.passengername,
                style: Styles.headlineStyle4,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment Method',
                style: Styles.textStyle.copyWith(
                  color: Colors.grey,
                  fontSize: 10,
                ),
              ),
              const Gap(4),
              Text(
                'Visa ending in ${ticket.paymentLast4}',
                style: Styles.headlineStyle4,
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF1434CB).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Visa',
              style: Styles.textStyle.copyWith(
                color: const Color(0xFF1434CB),
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _shareBooking(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Share Booking',
          style: Styles.headlineStyle3,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Booking Code: ${ticket.bookingCode}',
              style: Styles.headlineStyle4,
              textAlign: TextAlign.center,
            ),
            const Gap(12),
            Text(
              'Share this code with others so they can track your flight',
              style: Styles.textStyle.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Add share functionality
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Styles.primarycolor,
            ),
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }
}
