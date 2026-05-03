import 'package:flutter/foundation.dart';

@immutable
class PaymentMethod {
  final String id;
  final String cardNumber;
  final String holderName;
  final String expiryDate;
  final String cvv;
  final String type; // 'credit', 'debit', 'digital'
  final bool isDefault;
  final String cardBrand; // 'visa', 'mastercard', 'amex'

  const PaymentMethod({
    required this.id,
    required this.cardNumber,
    required this.holderName,
    required this.expiryDate,
    required this.cvv,
    required this.type,
    this.isDefault = false,
    required this.cardBrand,
  });

  String get _digitsOnly => cardNumber.replaceAll(RegExp(r'\D'), '');

  String get maskedCardNumber {
    final d = _digitsOnly;
    if (d.length < 4) {
      return d.isEmpty ? '•••• •••• •••• ••••' : '•••• •••• •••• ${d.padLeft(4, '•')}';
    }
    final last4 = d.substring(d.length - 4);
    return '•••• •••• •••• $last4';
  }

  PaymentMethod copyWith({
    String? id,
    String? cardNumber,
    String? holderName,
    String? expiryDate,
    String? cvv,
    String? type,
    bool? isDefault,
    String? cardBrand,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      cardNumber: cardNumber ?? this.cardNumber,
      holderName: holderName ?? this.holderName,
      expiryDate: expiryDate ?? this.expiryDate,
      cvv: cvv ?? this.cvv,
      type: type ?? this.type,
      isDefault: isDefault ?? this.isDefault,
      cardBrand: cardBrand ?? this.cardBrand,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cardNumber': cardNumber,
      'holderName': holderName,
      'expiryDate': expiryDate,
      'cvv': cvv,
      'type': type,
      'isDefault': isDefault,
      'cardBrand': cardBrand,
    };
  }

  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      id: map['id'] ?? '',
      cardNumber: map['cardNumber'] ?? '',
      holderName: map['holderName'] ?? '',
      expiryDate: map['expiryDate'] ?? '',
      cvv: map['cvv'] ?? '',
      type: map['type'] ?? 'credit',
      isDefault: map['isDefault'] ?? false,
      cardBrand: map['cardBrand'] ?? 'visa',
    );
  }
}

@immutable
class Booking {
  final String bookingId;
  final String itemType; // 'ticket' or 'hotel'
  final String itemId;
  final String passengername;
  final String paymentMethodId;
  final double amount;
  final String status; // 'pending', 'confirmed', 'completed', 'cancelled'
  final DateTime bookingDate;
  final DateTime? completionDate;
  final String bookingCode;

  const Booking({
    required this.bookingId,
    required this.itemType,
    required this.itemId,
    required this.passengername,
    required this.paymentMethodId,
    required this.amount,
    required this.status,
    required this.bookingDate,
    this.completionDate,
    required this.bookingCode,
  });

  Booking copyWith({
    String? bookingId,
    String? itemType,
    String? itemId,
    String? passengername,
    String? paymentMethodId,
    double? amount,
    String? status,
    DateTime? bookingDate,
    DateTime? completionDate,
    String? bookingCode,
  }) {
    return Booking(
      bookingId: bookingId ?? this.bookingId,
      itemType: itemType ?? this.itemType,
      itemId: itemId ?? this.itemId,
      passengername: passengername ?? this.passengername,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      bookingDate: bookingDate ?? this.bookingDate,
      completionDate: completionDate ?? this.completionDate,
      bookingCode: bookingCode ?? this.bookingCode,
    );
  }
}
