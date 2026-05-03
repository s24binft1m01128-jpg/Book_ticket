// models/hotel_model.dart

import 'package:flutter/foundation.dart';

@immutable
class HotelModel {
  final String id;
  final String image;
  final String place;
  final String destination;
  final double price;
  final double rating;
  final String distance;
  final List<String> amenities;

  const HotelModel({
    required this.id,
    required this.image,
    required this.place,
    required this.destination,
    required this.price,
    required this.rating,
    required this.distance,
    this.amenities = const ['WiFi', 'Pool', 'Gym', 'Restaurant'],
  });

  // ─── Factory ──────────────────────────────────────────────────────────────
  factory HotelModel.fromMap(Map<String, dynamic> map) {
    return HotelModel(
      // FIX: safe cast on every String field
      id: (map['id'] as String?) ?? '',
      image: (map['image'] as String?) ?? '',
      place: (map['place'] as String?) ?? '',
      destination: (map['destination'] as String?) ?? '',
      // FIX: null-safe num cast
      price: map['price'] != null ? (map['price'] as num).toDouble() : 0.0,
      rating: map['rating'] != null ? (map['rating'] as num).toDouble() : 0.0,
      distance: (map['distance'] as String?) ?? '',
      amenities: map['amenities'] != null
          ? List<String>.from(map['amenities'] as List)
          : const ['WiFi', 'Pool', 'Gym', 'Restaurant'],
    );
  }

  // ─── toMap ────────────────────────────────────────────────────────────────
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'place': place,
      'destination': destination,
      'price': price,
      'rating': rating,
      'distance': distance,
      'amenities': amenities,
    };
  }

  // ─── copyWith ─────────────────────────────────────────────────────────────
  HotelModel copyWith({
    String? id,
    String? image,
    String? place,
    String? destination,
    double? price,
    double? rating,
    String? distance,
    List<String>? amenities,
  }) {
    return HotelModel(
      id: id ?? this.id,
      image: image ?? this.image,
      place: place ?? this.place,
      destination: destination ?? this.destination,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      distance: distance ?? this.distance,
      amenities: amenities ?? this.amenities,
    );
  }

  // ─── Equality ─────────────────────────────────────────────────────────────
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HotelModel &&
        other.id == id &&
        other.place == place &&
        other.destination == destination &&
        other.price == price &&
        other.rating == rating;
  }

  @override
  int get hashCode => Object.hash(id, place, destination, price, rating);

  @override
  String toString() =>
      'HotelModel(id: $id, place: $place, destination: $destination, '
      'price: \$$price, rating: $rating)';
}