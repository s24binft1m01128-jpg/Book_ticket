import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookticket/models/hotel_model.dart';

final _initialHotels = [
  const HotelModel(
    id: '1',
    image: 'assets/download (1).jpeg',
    place: 'The Urban Nest',
    destination: 'London',
    price: 125,
    rating: 4.8,
    distance: '1.2 km from center',
  ),
  const HotelModel(
    id: '2',
    image: 'assets/OIP (1).jpeg',
    place: 'Global Will Suites',
    destination: 'London',
    price: 140,
    rating: 4.6,
    distance: 'Near Canary Wharf',
  ),
  const HotelModel(
    id: '3',
    image: 'assets/download.jpeg',
    place: 'Skyline Atrium',
    destination: 'Dubai',
    price: 168,
    rating: 4.9,
    distance: 'Downtown Dubai',
  ),
];

class HotelNotifier extends StateNotifier<List<HotelModel>> {
  HotelNotifier() : super(_initialHotels);

  void addHotel(HotelModel hotel) {
    state = [...state, hotel];
  }

  void removeHotel(String id) {
    state = state.where((hotel) => hotel.id != id).toList();
  }

  void updateHotel(HotelModel updatedHotel) {
    state = state.map((hotel) {
      if (hotel.id == updatedHotel.id) {
        return updatedHotel;
      }
      return hotel;
    }).toList();
  }

  void filterByDestination(String destination) {
    state = _initialHotels
        .where((h) =>
            h.destination.toLowerCase().contains(destination.toLowerCase()))
        .toList();
  }

  void filterByRating(double minRating) {
    state = _initialHotels.where((h) => h.rating >= minRating).toList();
  }

  void filterByPrice(double minPrice, double maxPrice) {
    state = _initialHotels
        .where((h) => h.price >= minPrice && h.price <= maxPrice)
        .toList();
  }

  void resetFilters() {
    state = _initialHotels;
  }
}

final hotelListProvider =
    StateNotifierProvider<HotelNotifier, List<HotelModel>>((ref) {
  return HotelNotifier();
});

final hotelByIdProvider = FutureProvider.family<HotelModel?, String>((ref, id) {
  final hotels = ref.watch(hotelListProvider);
  try {
    return hotels.firstWhere((h) => h.id == id);
  } catch (e) {
    return null;
  }
});
