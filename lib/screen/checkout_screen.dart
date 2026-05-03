import 'package:bookticket/models/payment_model.dart';
import 'package:bookticket/models/ticket_model.dart';
import 'package:bookticket/providers/payment_provider.dart';
import 'package:bookticket/screen/payment_methods_screen.dart';
import 'package:bookticket/screen/ticket_confirmation_screen.dart';
import 'package:bookticket/utils/app_layout.dart';
import 'package:bookticket/utils/app_styles.dart';
import 'package:bookticket/utils/notification_service.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  final TicketModel ticket;
  final String passengerName;

  const CheckoutScreen({
    super.key,
    required this.ticket,
    required this.passengerName,
  });

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  late String selectedPaymentMethodId;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    final defaultMethod = ref.read(defaultPaymentMethodProvider);
    selectedPaymentMethodId = defaultMethod?.id ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final paymentMethods = ref.watch(paymentMethodsProvider);

    ref.listen<List<PaymentMethod>>(paymentMethodsProvider, (previous, next) {
      if (!mounted) return;
      if (next.isEmpty) {
        setState(() => selectedPaymentMethodId = '');
        return;
      }
      final stillValid = next.any((m) => m.id == selectedPaymentMethodId);
      if (!stillValid) {
        final def = ref.read(defaultPaymentMethodProvider);
        setState(
          () => selectedPaymentMethodId = def?.id ?? next.first.id,
        );
      }
    });

    final horizontalPadding = AppLayout.horizontalPadding(context);

    return Scaffold(
      backgroundColor: Styles.bgcolor,
      appBar: AppBar(
        backgroundColor: Styles.bgcolor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              FluentSystemIcons.ic_fluent_arrow_left_regular,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
        title: Text(
          'Checkout',
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
                // Booking Summary
                _buildBookingSummary(context),
                const Gap(24),

                // Passenger Info
                _buildPassengerSection(),
                const Gap(24),

                // Payment Method Selection
                Text(
                  'Pay with',
                  style: Styles.headlineStyle3,
                ),
                const Gap(6),
                Text(
                  'Tap a card to use it for this booking.',
                  style: Styles.headlineStyle4,
                ),
                const Gap(14),
                if (paymentMethods.isEmpty)
                  _CheckoutPaymentEmptyHint(
                    onAddPayment: () async {
                      await Navigator.push<void>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaymentMethodsScreen(),
                        ),
                      );
                    },
                  )
                else
                  ...List.generate(
                    paymentMethods.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildPaymentMethodOption(
                        paymentMethods[index],
                        selectedPaymentMethodId == paymentMethods[index].id,
                        () {
                          setState(() {
                            selectedPaymentMethodId =
                                paymentMethods[index].id;
                          });
                        },
                      ),
                    ),
                  ),
                const Gap(24),

                // Price Breakdown
                _buildPriceBreakdown(),
                const Gap(32),

                // Complete Booking Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isProcessing ? null : _processBooking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Styles.primarycolor,
                      disabledBackgroundColor: Colors.grey[400],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isProcessing
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            'Complete Booking',
                            style: Styles.headlineStyle3.copyWith(
                              color: Colors.white,
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
    );
  }

  Widget _buildBookingSummary(BuildContext context) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.ticket.fromCode,
                    style: Styles.headlineStyle2,
                  ),
                  const Gap(4),
                  Text(
                    widget.ticket.fromName,
                    style: Styles.textStyle.copyWith(
                      color: Colors.grey,
                      fontSize: 11,
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
                    widget.ticket.flyingTime,
                    style: Styles.headlineStyle4.copyWith(fontSize: 10),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.ticket.toCode,
                    style: Styles.headlineStyle2,
                  ),
                  const Gap(4),
                  Text(
                    widget.ticket.toName,
                    style: Styles.textStyle.copyWith(
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoColumn('Date', widget.ticket.date),
              _buildInfoColumn('Seat', widget.ticket.seat),
              _buildInfoColumn('Class', widget.ticket.ticketClass),
              _buildInfoColumn('Airline', widget.ticket.airline),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Styles.textStyle.copyWith(
            color: Colors.grey,
            fontSize: 10,
          ),
        ),
        const Gap(4),
        Text(
          value,
          style: Styles.headlineStyle4.copyWith(fontSize: 12),
        ),
      ],
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Passenger Information',
            style: Styles.headlineStyle3,
          ),
          const Gap(12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  FluentSystemIcons.ic_fluent_person_regular,
                  color: Styles.primarycolor,
                ),
                const Gap(12),
                Text(
                  widget.passengerName,
                  style: Styles.headlineStyle4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodOption(
    PaymentMethod method,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? Styles.primarycolor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: method.id,
              groupValue: selectedPaymentMethodId,
              onChanged: (_) => onTap(),
              fillColor: WidgetStateProperty.all(Styles.primarycolor),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.cardBrand.toUpperCase(),
                    style: Styles.headlineStyle4,
                  ),
                  const Gap(4),
                  Text(
                    method.maskedCardNumber,
                    style: Styles.textStyle.copyWith(
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            if (method.isDefault)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Default',
                  style: Styles.textStyle.copyWith(
                    color: Colors.green,
                    fontSize: 10,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceBreakdown() {
    const taxPercentage = 0.08;
    final tax = widget.ticket.price * taxPercentage;
    final total = widget.ticket.price + tax;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Breakdown',
            style: Styles.headlineStyle3,
          ),
          const Gap(12),
          _buildPriceRow(
              'Ticket Price', '\$${widget.ticket.price.toStringAsFixed(2)}'),
          const Gap(8),
          _buildPriceRow('Tax (8%)', '\$${tax.toStringAsFixed(2)}'),
          const Divider(height: 16),
          _buildPriceRow(
            'Total Amount',
            '\$${total.toStringAsFixed(2)}',
            isBold: true,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    String amount, {
    bool isBold = false,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold
              ? Styles.headlineStyle3
              : Styles.textStyle.copyWith(color: Colors.grey),
        ),
        Text(
          amount,
          style: isBold
              ? Styles.headlineStyle2.copyWith(
                  color: isTotal ? Styles.primarycolor : Colors.black,
                )
              : Styles.textStyle.copyWith(color: Colors.grey),
        ),
      ],
    );
  }

  void _processBooking() async {
    if (selectedPaymentMethodId.isEmpty) {
      NotificationService()
          .showError(context, 'Please select a payment method');
      return;
    }

    setState(() => isProcessing = true);

    try {
      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 2));

      final booking = Booking(
        bookingId: DateTime.now().millisecondsSinceEpoch.toString(),
        itemType: 'ticket',
        itemId: widget.ticket.number,
        passengername: widget.passengerName,
        paymentMethodId: selectedPaymentMethodId,
        amount: widget.ticket.price,
        status: 'completed',
        bookingDate: DateTime.now(),
        completionDate: DateTime.now(),
        bookingCode: widget.ticket.bookingCode,
      );

      ref.read(bookingProvider.notifier).addBooking(booking);

      setState(() => isProcessing = false);

      if (!mounted) return;

      NotificationService().showSuccess(
        context,
        'Booking completed successfully!',
      );

      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => TicketConfirmationScreen(
            ticket: widget.ticket,
            booking: booking,
          ),
        ),
      );
    } catch (e) {
      setState(() => isProcessing = false);
      if (mounted) {
        NotificationService()
            .showError(context, 'Booking failed. Please try again.');
      }
    }
  }
}

class _CheckoutPaymentEmptyHint extends StatelessWidget {
  final VoidCallback onAddPayment;

  const _CheckoutPaymentEmptyHint({required this.onAddPayment});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Styles.surfaceColor,
        borderRadius: BorderRadius.circular(Styles.radius),
        border: Border.all(color: Styles.lineColor.withValues(alpha: 0.65)),
        boxShadow: Styles.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.credit_card_rounded, color: Styles.primarycolor),
              const Gap(12),
              Expanded(
                child: Text(
                  'No saved cards yet',
                  style: Styles.headlineStyle3,
                ),
              ),
            ],
          ),
          const Gap(8),
          Text(
            'Add a secure card here — checkout becomes one tap next time.',
            style: Styles.headlineStyle4,
          ),
          const Gap(16),
          FilledButton.icon(
            onPressed: onAddPayment,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add payment method'),
          ),
        ],
      ),
    );
  }
}
