import 'package:bookticket/models/payment_model.dart';
import 'package:bookticket/providers/payment_provider.dart';
import 'package:bookticket/utils/app_layout.dart';
import 'package:bookticket/utils/app_styles.dart';
import 'package:bookticket/utils/notification_service.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

bool _passesLuhn(String digits) {
  if (digits.length < 13 || digits.length > 19) return false;
  var sum = 0;
  var alternate = false;
  for (var i = digits.length - 1; i >= 0; i--) {
    var n = int.tryParse(digits[i]) ?? 0;
    if (alternate) {
      n *= 2;
      if (n > 9) n -= 9;
    }
    sum += n;
    alternate = !alternate;
  }
  return sum % 10 == 0;
}

bool _validExpiryMmYy(String raw) {
  final parts = raw.split('/');
  if (parts.length != 2) return false;
  final m = int.tryParse(parts[0].trim());
  final y = int.tryParse(parts[1].trim());
  if (m == null || y == null || m < 1 || m > 12) return false;
  final now = DateTime.now();
  final fullYear = 2000 + y;
  if (fullYear < now.year) return false;
  if (fullYear == now.year && m < now.month) return false;
  return true;
}

Color _brandAccent(String brand) {
  switch (brand.toLowerCase()) {
    case 'visa':
      return const Color(0xFF1434CB);
    case 'mastercard':
      return const Color(0xFFEB001B);
    case 'amex':
      return const Color(0xFF006FCF);
    default:
      return Styles.mutedTextColor;
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final capped = digits.length > 19 ? digits.substring(0, 19) : digits;
    final buf = StringBuffer();
    for (var i = 0; i < capped.length; i++) {
      if (i > 0 && i % 4 == 0) buf.write(' ');
      buf.write(capped[i]);
    }
    final text = buf.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final capped = digits.length > 4 ? digits.substring(0, 4) : digits;
    var text = capped;
    if (capped.length >= 2) {
      text = '${capped.substring(0, 2)}/${capped.substring(2)}';
    }
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

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
        leading: IconButton.filled(
          style: IconButton.styleFrom(
            backgroundColor: Styles.surfaceColor,
            foregroundColor: Styles.textcolor,
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: Styles.lineColor.withValues(alpha: 0.6)),
            ),
          ),
          onPressed: () => Navigator.pop(context),
          icon: const Icon(FluentSystemIcons.ic_fluent_arrow_left_regular),
        ),
        title: Text('Wallet', style: Styles.headlineStyle2),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: AppLayout.contentWidth(context),
            ),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    8,
                    horizontalPadding,
                    24,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Saved payment methods',
                          style: Styles.headlineStyle4,
                        ),
                        const Gap(6),
                        Text(
                          'Tap a card to make it default for checkout. Your full number is never shown.',
                          style: Styles.headlineStyle4.copyWith(fontSize: 13),
                        ),
                        const Gap(24),
                      ],
                    ),
                  ),
                ),
                if (paymentMethods.isEmpty)
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    sliver: SliverToBoxAdapter(
                      child: _WalletEmptyCard(
                        onAdd: () => _openAddSheet(context, ref),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final method = paymentMethods[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _WalletCard(
                              method: method,
                              onTap: () {
                                if (!method.isDefault) {
                                  ref
                                      .read(paymentMethodsProvider.notifier)
                                      .setDefaultPaymentMethod(method.id);
                                  NotificationService().showSuccess(
                                    context,
                                    'Default card updated',
                                  );
                                }
                              },
                              onRemove: () async {
                                final ok = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text(
                                      'Remove card?',
                                      style: Styles.headlineStyle3,
                                    ),
                                    content: Text(
                                      'You can add this card again anytime.',
                                      style: Styles.headlineStyle4,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, false),
                                        child: const Text('Cancel'),
                                      ),
                                      FilledButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, true),
                                        child: const Text('Remove'),
                                      ),
                                    ],
                                  ),
                                );
                                if (ok == true && context.mounted) {
                                  ref
                                      .read(paymentMethodsProvider.notifier)
                                      .removePaymentMethod(method.id);
                                  NotificationService().showSuccess(
                                    context,
                                    'Card removed',
                                  );
                                }
                              },
                            ),
                          );
                        },
                        childCount: paymentMethods.length,
                      ),
                    ),
                  ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    8,
                    horizontalPadding,
                    32,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: FilledButton.icon(
                      onPressed: () => _openAddSheet(context, ref),
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Add debit or credit card'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(54),
                      ),
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

  void _openAddSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Styles.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: _AddPaymentSheet(
          onSave: (method) {
            ref.read(paymentMethodsProvider.notifier).addPaymentMethod(method);
            Navigator.pop(sheetContext);
            NotificationService().showSuccess(
              context,
              'Card saved securely',
            );
          },
        ),
      ),
    );
  }
}

class _WalletEmptyCard extends StatelessWidget {
  final VoidCallback onAdd;

  const _WalletEmptyCard({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Styles.primarycolor.withValues(alpha: 0.12),
            Styles.secondaryColor.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Styles.lineColor.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.wallet_rounded,
            size: 48,
            color: Styles.primarycolor.withValues(alpha: 0.85),
          ),
          const Gap(16),
          Text(
            'No cards yet',
            style: Styles.headlineStyle2,
            textAlign: TextAlign.center,
          ),
          const Gap(8),
          Text(
            'Add a card once — SkyPass masks your details and uses your default card at checkout.',
            style: Styles.headlineStyle4,
            textAlign: TextAlign.center,
          ),
          const Gap(22),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add your first card'),
          ),
        ],
      ),
    );
  }
}

class _WalletCard extends StatelessWidget {
  final PaymentMethod method;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _WalletCard({
    required this.method,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final accent = _brandAccent(method.cardBrand);
    final isDefault = method.isDefault;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: isDefault
                ? LinearGradient(
                    colors: [
                      const Color(0xFF0F172A),
                      Styles.primaryDark,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isDefault ? null : Styles.surfaceColor,
            border: Border.all(
              color: isDefault
                  ? Colors.white.withValues(alpha: 0.12)
                  : Styles.lineColor.withValues(alpha: 0.65),
            ),
            boxShadow: isDefault ? Styles.softShadow : Styles.cardLift,
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: (isDefault ? Colors.white : accent)
                          .withValues(alpha: isDefault ? 0.18 : 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      method.cardBrand.toUpperCase(),
                      style: Styles.headlineStyle4.copyWith(
                        color: isDefault ? Colors.white : accent,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (isDefault)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Styles.secondaryColor.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            size: 14,
                            color: Colors.white.withValues(alpha: 0.95),
                          ),
                          const Gap(6),
                          Text(
                            'Default',
                            style: Styles.headlineStyle4.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_horiz_rounded,
                      color: isDefault
                          ? Colors.white.withValues(alpha: 0.85)
                          : Styles.mutedTextColor,
                    ),
                    color: Styles.surfaceColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    onSelected: (value) {
                      if (value == 'remove') onRemove();
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'remove',
                        child: Text(
                          'Remove card',
                          style: Styles.textStyle.copyWith(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Gap(18),
              Text(
                method.maskedCardNumber,
                style: Styles.headlineStyle2.copyWith(
                  color: isDefault ? Colors.white : Styles.textcolor,
                  letterSpacing: 1.2,
                  fontSize: 18,
                ),
              ),
              const Gap(14),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cardholder',
                          style: Styles.headlineStyle4.copyWith(
                            fontSize: 11,
                            color: isDefault
                                ? Colors.white.withValues(alpha: 0.65)
                                : Styles.mutedTextColor,
                          ),
                        ),
                        const Gap(4),
                        Text(
                          method.holderName,
                          style: Styles.headlineStyle3.copyWith(
                            fontSize: 14,
                            color:
                                isDefault ? Colors.white : Styles.textcolor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Expires',
                        style: Styles.headlineStyle4.copyWith(
                          fontSize: 11,
                          color: isDefault
                              ? Colors.white.withValues(alpha: 0.65)
                              : Styles.mutedTextColor,
                        ),
                      ),
                      const Gap(4),
                      Text(
                        method.expiryDate,
                        style: Styles.headlineStyle3.copyWith(
                          fontSize: 14,
                          color:
                              isDefault ? Colors.white : Styles.textcolor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (!isDefault) ...[
                const Gap(14),
                Text(
                  'Tap to use as default checkout card',
                  style: Styles.headlineStyle4.copyWith(
                    fontSize: 12,
                    color: Styles.primarycolor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _AddPaymentSheet extends StatefulWidget {
  final ValueChanged<PaymentMethod> onSave;

  const _AddPaymentSheet({required this.onSave});

  @override
  State<_AddPaymentSheet> createState() => _AddPaymentSheetState();
}

class _AddPaymentSheetState extends State<_AddPaymentSheet> {
  final _cardNumber = TextEditingController();
  final _holderName = TextEditingController();
  final _expiry = TextEditingController();
  final _cvv = TextEditingController();

  String _brand = 'visa';
  String _type = 'credit';
  bool _makeDefault = false;

  @override
  void dispose() {
    _cardNumber.dispose();
    _holderName.dispose();
    _expiry.dispose();
    _cvv.dispose();
    super.dispose();
  }

  InputDecoration _dec(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: Styles.surfaceMuted,
      counterText: '',
    );
  }

  void _submit() {
    final digits = _cardNumber.text.replaceAll(RegExp(r'\D'), '');
    final holder = _holderName.text.trim();
    final expiry = _expiry.text.trim();
    final cvv = _cvv.text.trim();

    if (digits.length < 13 ||
        holder.isEmpty ||
        expiry.length < 5 ||
        cvv.length < 3) {
      NotificationService()
          .showError(context, 'Please complete all fields correctly.');
      return;
    }
    if (!_passesLuhn(digits)) {
      NotificationService().showError(
        context,
        'Card number doesn’t look valid. Double-check the digits.',
      );
      return;
    }
    if (!_validExpiryMmYy(expiry)) {
      NotificationService().showError(
        context,
        'Expiry must be MM/YY and in the future.',
      );
      return;
    }

    widget.onSave(
      PaymentMethod(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        cardNumber: digits,
        holderName: holder,
        expiryDate: expiry,
        cvv: cvv,
        type: _type,
        isDefault: _makeDefault,
        cardBrand: _brand,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 8, 22, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Add a card', style: Styles.headlineStyle2),
          const Gap(6),
          Text(
            'Demo only — numbers stay on this device.',
            style: Styles.headlineStyle4.copyWith(fontSize: 13),
          ),
          const Gap(22),
          TextField(
            controller: _cardNumber,
            keyboardType: TextInputType.number,
            inputFormatters: [_CardNumberFormatter()],
            decoration: _dec('Card number', '4242 4242 4242 4242'),
            autofillHints: const [AutofillHints.creditCardNumber],
          ),
          const Gap(14),
          TextField(
            controller: _holderName,
            textCapitalization: TextCapitalization.words,
            decoration: _dec('Name on card', 'As printed on card'),
            autofillHints: const [AutofillHints.creditCardName],
          ),
          const Gap(14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: _expiry,
                  keyboardType: TextInputType.number,
                  inputFormatters: [_ExpiryFormatter()],
                  decoration: _dec('Expires', 'MM/YY'),
                  autofillHints: const [AutofillHints.creditCardExpirationDate],
                ),
              ),
              const Gap(12),
              Expanded(
                child: TextField(
                  controller: _cvv,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 4,
                  decoration: _dec('CVV', '•••').copyWith(counterText: ''),
                  autofillHints: const [AutofillHints.creditCardSecurityCode],
                ),
              ),
            ],
          ),
          const Gap(18),
          Text('Brand', style: Styles.headlineStyle4),
          const Gap(10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: ['visa', 'mastercard', 'amex'].map((b) {
              final selected = _brand == b;
              return ChoiceChip(
                label: Text(b.toUpperCase()),
                selected: selected,
                onSelected: (_) => setState(() => _brand = b),
                selectedColor: Styles.primarycolor.withValues(alpha: 0.18),
                labelStyle: Styles.headlineStyle4.copyWith(
                  color: selected ? Styles.primarycolor : Styles.textcolor,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(
                    color: selected
                        ? Styles.primarycolor
                        : Styles.lineColor.withValues(alpha: 0.8),
                  ),
                ),
              );
            }).toList(),
          ),
          const Gap(18),
          Text('Card type', style: Styles.headlineStyle4),
          const Gap(10),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'credit', label: Text('Credit')),
              ButtonSegment(value: 'debit', label: Text('Debit')),
              ButtonSegment(value: 'digital', label: Text('Digital')),
            ],
            selected: {_type},
            onSelectionChanged: (s) => setState(() => _type = s.first),
          ),
          const Gap(18),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Use for checkout by default',
              style: Styles.headlineStyle3.copyWith(fontSize: 15),
            ),
            subtitle: Text(
              'Other cards stay saved — you can switch anytime.',
              style: Styles.headlineStyle4.copyWith(fontSize: 12),
            ),
            value: _makeDefault,
            activeTrackColor: Styles.primarycolor.withValues(alpha: 0.35),
            onChanged: (v) => setState(() => _makeDefault = v),
          ),
          const Gap(22),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _submit,
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
              child: const Text('Save card'),
            ),
          ),
        ],
      ),
    );
  }
}
