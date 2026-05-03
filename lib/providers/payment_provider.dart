import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookticket/models/payment_model.dart';

class PaymentNotifier extends StateNotifier<List<PaymentMethod>> {
  PaymentNotifier()
      : super([
          PaymentMethod(
            id: '1',
            cardNumber: '4532123456789010',
            holderName: 'John Doe',
            expiryDate: '12/25',
            cvv: '123',
            type: 'credit',
            isDefault: true,
            cardBrand: 'visa',
          ),
          PaymentMethod(
            id: '2',
            cardNumber: '5425233010103010',
            holderName: 'John Doe',
            expiryDate: '08/26',
            cvv: '456',
            type: 'debit',
            isDefault: false,
            cardBrand: 'mastercard',
          ),
        ]);

  void addPaymentMethod(PaymentMethod method) {
    state = [...state, method];
  }

  void removePaymentMethod(String id) {
    state = state.where((method) => method.id != id).toList();
  }

  void updatePaymentMethod(PaymentMethod updatedMethod) {
    state = state.map((method) {
      if (method.id == updatedMethod.id) {
        return updatedMethod;
      }
      return method;
    }).toList();
  }

  void setDefaultPaymentMethod(String id) {
    state = state.map((method) {
      return method.copyWith(isDefault: method.id == id);
    }).toList();
  }
}

final paymentMethodsProvider =
    StateNotifierProvider<PaymentNotifier, List<PaymentMethod>>((ref) {
  return PaymentNotifier();
});

final defaultPaymentMethodProvider = Provider<PaymentMethod?>((ref) {
  final methods = ref.watch(paymentMethodsProvider);
  try {
    return methods.firstWhere((method) => method.isDefault);
  } catch (e) {
    return methods.isNotEmpty ? methods.first : null;
  }
});

class BookingNotifier extends StateNotifier<List<Booking>> {
  BookingNotifier() : super([]);

  void addBooking(Booking booking) {
    state = [...state, booking];
  }

  void updateBooking(Booking updatedBooking) {
    state = state.map((booking) {
      if (booking.bookingId == updatedBooking.bookingId) {
        return updatedBooking;
      }
      return booking;
    }).toList();
  }

  void removeBooking(String bookingId) {
    state = state.where((booking) => booking.bookingId != bookingId).toList();
  }
}

final bookingProvider =
    StateNotifierProvider<BookingNotifier, List<Booking>>((ref) {
  return BookingNotifier();
});

final bookingByIdProvider = FutureProvider.family<Booking?, String>((ref, id) {
  final bookings = ref.watch(bookingProvider);
  try {
    return bookings.firstWhere((b) => b.bookingId == id);
  } catch (e) {
    return null;
  }
});
