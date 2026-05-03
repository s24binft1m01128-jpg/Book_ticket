// models/ticket_model.dart

import 'package:flutter/foundation.dart';

@immutable
class TicketModel {
  final String number;
  final String airline;
  final String fromCode;
  final String fromName;
  final String toCode;
  final String toName;
  final String flyingTime;
  final String date;
  final String departureTime;
  final String arrivalTime;
  final String gate;
  final String seat;
  final String ticketClass;
  final double price;
  final String bookingCode;
  final String eTicket;
  final String passport;
  final String passenger;
  final String paymentLast4;
  final String terminal;
  final String status;

  const TicketModel({
    required this.number,
    required this.airline,
    required this.fromCode,
    required this.fromName,
    required this.toCode,
    required this.toName,
    required this.flyingTime,
    required this.date,
    required this.departureTime,
    required this.arrivalTime,
    required this.gate,
    required this.seat,
    required this.ticketClass,
    required this.price,
    required this.bookingCode,
    required this.eTicket,
    required this.passport,
    required this.passenger,
    required this.paymentLast4,
    required this.terminal,
    required this.status,
  });

  // ─── Factory ──────────────────────────────────────────────────────────────
  factory TicketModel.fromMap(Map<String, dynamic> map) {
    return TicketModel(
      // FIX: preserve as String but handle both int and String source data
      number: map['number'].toString(),
      airline: (map['airline'] as String?) ?? '',
      fromCode: (map['from']['code'] as String?) ?? '',
      fromName: (map['from']['name'] as String?) ?? '',
      toCode: (map['to']['code'] as String?) ?? '',
      toName: (map['to']['name'] as String?) ?? '',
      flyingTime: (map['flying_time'] as String?) ?? '',
      date: (map['date'] as String?) ?? '',
      departureTime: (map['departure_time'] as String?) ?? '',
      arrivalTime: (map['arrival_time'] as String?) ?? '',
      gate: (map['gate'] as String?) ?? '',
      seat: (map['seat'] as String?) ?? '',
      ticketClass: (map['class'] as String?) ?? '',
      // FIX: safe cast that handles int, double, or missing
      price: map['price'] != null ? (map['price'] as num).toDouble() : 0.0,
      bookingCode: (map['booking_code'] as String?) ?? '',
      eTicket: (map['e_ticket'] as String?) ?? '',
      passport: (map['passport'] as String?) ?? '',
      passenger: (map['passenger'] as String?) ?? '',
      paymentLast4: (map['payment_last4'] as String?) ?? '',
      terminal: (map['terminal'] as String?) ?? '',
      status: (map['status'] as String?) ?? '',
    );
  }

  // ─── toMap ────────────────────────────────────────────────────────────────
  // FIX: number stored as int to match original data shape so round-tripping
  // fromMap → toMap → fromMap stays consistent.
  Map<String, dynamic> toMap() {
    return {
      'number': int.tryParse(number) ?? number,
      'airline': airline,
      'from': {'code': fromCode, 'name': fromName},
      'to': {'code': toCode, 'name': toName},
      'flying_time': flyingTime,
      'date': date,
      'departure_time': departureTime,
      'arrival_time': arrivalTime,
      'gate': gate,
      'seat': seat,
      'class': ticketClass,
      'price': price,
      'booking_code': bookingCode,
      'e_ticket': eTicket,
      'passport': passport,
      'passenger': passenger,
      'payment_last4': paymentLast4,
      'terminal': terminal,
      'status': status,
    };
  }

  // ─── copyWith ─────────────────────────────────────────────────────────────
  // Needed for StateNotifier updates e.g. notifier.updateStatus('Boarded')
  TicketModel copyWith({
    String? number,
    String? airline,
    String? fromCode,
    String? fromName,
    String? toCode,
    String? toName,
    String? flyingTime,
    String? date,
    String? departureTime,
    String? arrivalTime,
    String? gate,
    String? seat,
    String? ticketClass,
    double? price,
    String? bookingCode,
    String? eTicket,
    String? passport,
    String? passenger,
    String? paymentLast4,
    String? terminal,
    String? status,
  }) {
    return TicketModel(
      number: number ?? this.number,
      airline: airline ?? this.airline,
      fromCode: fromCode ?? this.fromCode,
      fromName: fromName ?? this.fromName,
      toCode: toCode ?? this.toCode,
      toName: toName ?? this.toName,
      flyingTime: flyingTime ?? this.flyingTime,
      date: date ?? this.date,
      departureTime: departureTime ?? this.departureTime,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      gate: gate ?? this.gate,
      seat: seat ?? this.seat,
      ticketClass: ticketClass ?? this.ticketClass,
      price: price ?? this.price,
      bookingCode: bookingCode ?? this.bookingCode,
      eTicket: eTicket ?? this.eTicket,
      passport: passport ?? this.passport,
      passenger: passenger ?? this.passenger,
      paymentLast4: paymentLast4 ?? this.paymentLast4,
      terminal: terminal ?? this.terminal,
      status: status ?? this.status,
    );
  }

  // ─── Equality ─────────────────────────────────────────────────────────────
  // Needed so Riverpod watch() only rebuilds when data actually changes
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TicketModel &&
        other.number == number &&
        other.airline == airline &&
        other.fromCode == fromCode &&
        other.toCode == toCode &&
        other.date == date &&
        other.departureTime == departureTime &&
        other.gate == gate &&
        other.seat == seat &&
        other.status == status &&
        other.price == price &&
        other.bookingCode == bookingCode;
  }

  @override
  int get hashCode => Object.hash(
        number,
        airline,
        fromCode,
        toCode,
        date,
        departureTime,
        gate,
        seat,
        status,
        price,
        bookingCode,
      );

  @override
  String toString() =>
      'TicketModel(number: $number, $fromCode→$toCode, $date, $status)';
}