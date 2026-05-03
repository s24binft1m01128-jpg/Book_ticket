import 'package:bookticket/models/payment_model.dart';
import 'package:bookticket/providers/payment_provider.dart';
import 'package:bookticket/utils/app_layout.dart';
import 'package:bookticket/utils/app_styles.dart';
import 'package:bookticket/utils/notification_service.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class PaymentMethodsScreen extends ConsumerWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentMethods = ref.watch(paymentMethodsProvider);
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
          'Payment Methods',
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
                ...List.generate(
                  paymentMethods.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _PaymentMethodCard(
                      method: paymentMethods[index],
                      onDelete: () {
                        ref
                            .read(paymentMethodsProvider.notifier)
                            .removePaymentMethod(paymentMethods[index].id);
                        NotificationService().showSuccess(
                          context,
                          'Payment method removed',
                        );
                      },
                      onSetDefault: () {
                        ref
                            .read(paymentMethodsProvider.notifier)
                            .setDefaultPaymentMethod(paymentMethods[index].id);
                        NotificationService().showSuccess(
                          context,
                          'Default payment method updated',
                        );
                      },
                    ),
                  ),
                ),
                const Gap(16),
                ElevatedButton.icon(
                  onPressed: () => _showAddPaymentSheet(context, ref),
                  icon: const Icon(FluentSystemIcons.ic_fluent_add_regular),
                  label: const Text('Add Payment Method'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Styles.primarycolor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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

  void _showAddPaymentSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddPaymentSheet(
        onAddMethod: (method) {
          ref.read(paymentMethodsProvider.notifier).addPaymentMethod(method);
          Navigator.pop(context);
          NotificationService().showSuccess(
            context,
            'Payment method added successfully',
          );
        },
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final PaymentMethod method;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const _PaymentMethodCard({
    required this.method,
    required this.onDelete,
    required this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getCardColor().withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  method.cardBrand.toUpperCase(),
                  style: Styles.headlineStyle4.copyWith(
                    color: _getCardColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (method.isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Default',
                    style: Styles.headlineStyle4.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),
          const Gap(12),
          Text(
            method.maskedCardNumber,
            style: Styles.headlineStyle4.copyWith(
              letterSpacing: 2,
              fontSize: 14,
            ),
          ),
          const Gap(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cardholder',
                    style: Styles.textStyle.copyWith(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    method.holderName,
                    style: Styles.headlineStyle4.copyWith(fontSize: 12),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Expires',
                    style: Styles.textStyle.copyWith(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    method.expiryDate,
                    style: Styles.headlineStyle4.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const Gap(16),
          Row(
            children: [
              if (!method.isDefault)
                Expanded(
                  child: OutlinedButton(
                    onPressed: onSetDefault,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Styles.primarycolor,
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Set as Default',
                      style: Styles.headlineStyle4.copyWith(
                        color: Styles.primarycolor,
                      ),
                    ),
                  ),
                ),
              if (!method.isDefault) const Gap(12),
              Expanded(
                child: OutlinedButton(
                  onPressed: onDelete,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Colors.red,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Delete',
                    style: Styles.headlineStyle4.copyWith(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getCardColor() {
    switch (method.cardBrand.toLowerCase()) {
      case 'visa':
        return const Color(0xFF1434CB);
      case 'mastercard':
        return const Color(0xFFEB001B);
      case 'amex':
        return const Color(0xFF006FCF);
      default:
        return Colors.grey;
    }
  }
}

class _AddPaymentSheet extends StatefulWidget {
  final Function(PaymentMethod) onAddMethod;

  const _AddPaymentSheet({required this.onAddMethod});

  @override
  State<_AddPaymentSheet> createState() => _AddPaymentSheetState();
}

class _AddPaymentSheetState extends State<_AddPaymentSheet> {
  late TextEditingController cardNumberController;
  late TextEditingController holderNameController;
  late TextEditingController expiryDateController;
  late TextEditingController cvvController;
  String selectedCardBrand = 'visa';
  String selectedType = 'credit';

  @override
  void initState() {
    super.initState();
    cardNumberController = TextEditingController();
    holderNameController = TextEditingController();
    expiryDateController = TextEditingController();
    cvvController = TextEditingController();
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    holderNameController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
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
              'Add Payment Method',
              style: Styles.headlineStyle2,
            ),
            const Gap(24),
            TextField(
              controller: cardNumberController,
              decoration: InputDecoration(
                hintText: 'Card Number',
                hintStyle: Styles.textStyle.copyWith(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.number,
              maxLength: 16,
            ),
            const Gap(16),
            TextField(
              controller: holderNameController,
              decoration: InputDecoration(
                hintText: 'Cardholder Name',
                hintStyle: Styles.textStyle.copyWith(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const Gap(16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: expiryDateController,
                    decoration: InputDecoration(
                      hintText: 'MM/YY',
                      hintStyle: Styles.textStyle.copyWith(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: TextField(
                    controller: cvvController,
                    decoration: InputDecoration(
                      hintText: 'CVV',
                      hintStyle: Styles.textStyle.copyWith(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    obscureText: true,
                  ),
                ),
              ],
            ),
            const Gap(16),
            Text(
              'Card Brand',
              style: Styles.headlineStyle4,
            ),
            const Gap(8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                value: selectedCardBrand,
                isExpanded: true,
                underline: SizedBox.shrink(),
                items: ['visa', 'mastercard', 'amex']
                    .map(
                      (brand) => DropdownMenuItem(
                        value: brand,
                        child: Text(brand.toUpperCase()),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedCardBrand = value);
                  }
                },
              ),
            ),
            const Gap(16),
            Text(
              'Card Type',
              style: Styles.headlineStyle4,
            ),
            const Gap(8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                value: selectedType,
                isExpanded: true,
                underline: SizedBox.shrink(),
                items: ['credit', 'debit', 'digital']
                    .map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(
                          type[0].toUpperCase() + type.substring(1),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedType = value);
                  }
                },
              ),
            ),
            const Gap(24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addPaymentMethod,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Styles.primarycolor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Add Payment Method',
                  style: Styles.headlineStyle4.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addPaymentMethod() {
    if (cardNumberController.text.isEmpty ||
        holderNameController.text.isEmpty ||
        expiryDateController.text.isEmpty ||
        cvvController.text.isEmpty) {
      NotificationService().showError(context, 'Please fill all fields');
      return;
    }

    final newMethod = PaymentMethod(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      cardNumber: cardNumberController.text,
      holderName: holderNameController.text,
      expiryDate: expiryDateController.text,
      cvv: cvvController.text,
      type: selectedType,
      cardBrand: selectedCardBrand,
    );

    widget.onAddMethod(newMethod);
  }
}
