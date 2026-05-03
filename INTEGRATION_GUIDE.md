# Integration & Setup Guide - BookTicket Booking System

## 🚀 Quick Start

### Prerequisites
- Flutter 3.3.0 or higher
- Dart 3.3.0 or higher
- Android SDK 21+ / iOS 11+

### Installation Steps

1. **Get dependencies**
   ```bash
   flutter pub get
   ```

2. **Run the app**
   ```bash
   flutter run
   ```

3. **Build for production**
   ```bash
   flutter build apk      # Android
   flutter build ipa      # iOS
   flutter build web      # Web
   ```

---

## 📦 New Packages Structure

### Models Added
```
lib/models/payment_model.dart
├── PaymentMethod
│   ├── id: String
│   ├── cardNumber: String
│   ├── holderName: String
│   ├── expiryDate: String
│   ├── cvv: String
│   ├── type: String (credit/debit/digital)
│   ├── isDefault: bool
│   └── cardBrand: String
│
└── Booking
    ├── bookingId: String
    ├── itemType: String (ticket/hotel)
    ├── itemId: String
    ├── passengername: String
    ├── paymentMethodId: String
    ├── amount: double
    ├── status: String (pending/confirmed/completed/cancelled)
    ├── bookingDate: DateTime
    ├── completionDate: DateTime
    └── bookingCode: String
```

### Providers Added
```
lib/providers/payment_provider.dart
├── PaymentNotifier (StateNotifier)
├── paymentMethodsProvider
├── defaultPaymentMethodProvider
├── BookingNotifier (StateNotifier)
└── bookingProvider
```

### Screens Added
```
lib/screen/
├── payment_methods_screen.dart
│   └── PaymentMethodsScreen (ConsumerWidget)
│   └── _PaymentMethodCard (StatelessWidget)
│   └── _AddPaymentSheet (StatefulWidget)
│
├── checkout_screen.dart
│   └── CheckoutScreen (ConsumerStatefulWidget)
│   └── _buildBookingSummary()
│   └── _buildPassengerSection()
│   └── _buildPaymentMethodOption()
│   └── _buildPriceBreakdown()
│
├── ticket_confirmation_screen.dart
│   └── TicketConfirmationScreen (StatelessWidget)
│   └── _buildBookingCodeSection()
│   └── _buildTicketDetailsCard()
│   └── _buildBarcodeSection()
│   └── _buildQRCodeSection()
│   └── _buildPassengerSection()
│   └── _buildPaymentMethodSection()
│
└── ticket_detail_screen.dart (updated)
    └── Added _PassengerSelectionSheet
    └── Added "Book Now" button
```

### Utilities Added
```
lib/utils/notification_service.dart
├── NotificationService (Singleton)
├── showSuccess()
├── showError()
├── showInfo()
├── showWarning()
└── _showNotification() (private)
```

---

## 🔗 Integration Points

### 1. Profile Screen Integration

**File**: `lib/screen/profile_screen.dart`

**Changes**:
- Added imports for payment and notification services
- Updated "Payment methods" tile to navigate to PaymentMethodsScreen
- Displays default payment method in subtitle
- Notifications use NotificationService instead of SnackBar

**Code**:
```dart
_ActionTile(
  icon: Icons.credit_card_rounded,
  title: 'Payment methods',
  subtitle: defaultPaymentMethod != null
      ? defaultPaymentMethod.maskedCardNumber
      : 'No payment method added',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PaymentMethodsScreen(),
      ),
    );
  },
),
```

### 2. Ticket Detail Screen Integration

**File**: `lib/screen/ticket_detail_screen.dart`

**Changes**:
- Added "Book Now" button that opens passenger selection sheet
- Uses notification service for actions
- Fixed icon issues (airplane vs download)
- Integrated checkout flow

**Code**:
```dart
SizedBox(
  width: double.infinity,
  child: FilledButton.icon(
    onPressed: () {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        builder: (context) => _PassengerSelectionSheet(ticket: ticket),
      );
    },
    icon: const Icon(FluentSystemIcons.ic_fluent_ticket_regular),
    label: const Text('Book Now'),
  ),
)
```

### 3. Router Integration

**File**: `lib/router.dart`

**Changes**:
- Added import for new screens
- Added `/checkout` route
- Added `/ticket-confirmation` route
- Routes handle extra data passing

**Code**:
```dart
GoRoute(
  path: '/checkout',
  name: 'checkout',
  pageBuilder: (context, state) {
    final args = state.extra as Map<String, dynamic>?;
    return _buildPage(
      child: CheckoutScreen(
        ticket: args?['ticket'],
        passengerName: args?['passengerName'] ?? '',
      ),
      state: state,
    );
  },
),
```

---

## 🔄 Data Flow Diagrams

### Booking Flow
```
User on Ticket Detail Screen
  ↓
[Book Now] button pressed
  ↓
Passenger Selection Sheet shows
  ↓
User enters passenger name
  ↓
[Continue to Checkout] tapped
  ↓
CheckoutScreen opens with:
- Ticket details
- Passenger info
- Payment method options
  ↓
User selects payment method
  ↓
[Complete Booking] tapped
  ↓
Payment processing (simulated 2s delay)
  ↓
Booking added to bookingProvider
  ↓
Navigate to TicketConfirmationScreen
  ↓
Show success notification
  ↓
Display confirmation details
```

### Payment Method Management Flow
```
Profile Screen
  ↓
[Payment methods] tile tapped
  ↓
PaymentMethodsScreen shows
  ↓
List of payment methods displayed
  ↓
User can:
├─ [Set as Default] → updates paymentMethodsProvider
├─ [Delete] → removes from paymentMethodsProvider
└─ [Add Payment Method] → opens _AddPaymentSheet
  ↓
Form validated
  ↓
New method added to paymentMethodsProvider
  ↓
Success notification shown
  ↓
Screen updates automatically (Riverpod watching)
```

---

## 🧪 Testing the Implementation

### Test 1: Add Payment Method
1. Navigate to Profile → Payment methods
2. Click "Add Payment Method"
3. Fill form:
   - Card Number: 4532123456789010
   - Name: Test User
   - Expiry: 12/25
   - CVV: 123
4. Click "Add Payment Method"
5. Verify: Success notification, card appears in list

### Test 2: Complete Booking
1. Go to Tickets tab
2. Select a ticket
3. Click "Book Now"
4. Enter passenger name: "Test Passenger"
5. Click "Continue to Checkout"
6. Select payment method
7. Click "Complete Booking"
8. Verify: Loading spinner → Success notification → Confirmation screen

### Test 3: Set Default Payment
1. Go to Profile → Payment methods
2. Click "Set as Default" on non-default card
3. Verify: Card marked as default
4. Go back, open again
5. Verify: Default badge persists

### Test 4: Notifications
1. Try adding payment method without filling fields
2. Verify: Error notification shows
3. Complete booking successfully
4. Verify: Success notification shows

---

## 🔐 State Management Details

### PaymentNotifier Methods

```dart
void addPaymentMethod(PaymentMethod method)
// Adds new payment method to state

void removePaymentMethod(String id)
// Removes payment method by id

void updatePaymentMethod(PaymentMethod updatedMethod)
// Updates existing payment method

void setDefaultPaymentMethod(String id)
// Sets one method as default, others as non-default
```

### BookingNotifier Methods

```dart
void addBooking(Booking booking)
// Adds new booking to state

void updateBooking(Booking updatedBooking)
// Updates existing booking

void removeBooking(String bookingId)
// Removes booking by id
```

### Provider Selectors

```dart
// Get all payment methods
final methods = ref.watch(paymentMethodsProvider);

// Get default payment method (or null)
final defaultMethod = ref.watch(defaultPaymentMethodProvider);

// Get specific booking by ID
final booking = ref.watch(bookingByIdProvider('booking-id'));

// Get all bookings
final bookings = ref.watch(bookingProvider);
```

---

## 🎯 Key Features Implementation

### Feature 1: Payment Method Card Masking
```dart
String get maskedCardNumber => 
  '**** **** **** ${cardNumber.substring(cardNumber.length - 4)}';
// Output: **** **** **** 9010
```

### Feature 2: Default Payment Method Display
```dart
final defaultPaymentMethod = ref.watch(defaultPaymentMethodProvider);

String subtitle = defaultPaymentMethod != null
    ? defaultPaymentMethod.maskedCardNumber
    : 'No payment method added';
```

### Feature 3: Price Breakdown Calculation
```dart
const taxPercentage = 0.08;
final tax = ticket.price * taxPercentage;
final total = ticket.price + tax;

// Display: Ticket: $399.00, Tax: $31.92, Total: $430.92
```

### Feature 4: Barcode & QR Generation
```dart
// Barcode (for ticket scanning)
BarcodeWidget(
  barcode: Barcode.code128(),
  data: ticket.number,
  drawText: true,
)

// QR Code (for mobile check-in)
BarcodeWidget(
  barcode: Barcode.qrCode(),
  data: '${ticket.number}|${ticket.bookingCode}|${booking.bookingId}',
)
```

---

## 🚨 Error Handling

### Input Validation

**Passenger Name**:
```dart
if (passengerNameController.text.isEmpty) {
  NotificationService().showError(context, 'Please enter passenger name');
  return;
}
```

**Payment Method Selection**:
```dart
if (selectedPaymentMethodId.isEmpty) {
  NotificationService().showError(context, 'Please select a payment method');
  return;
}
```

**Payment Form Fields**:
```dart
if (cardNumberController.text.isEmpty ||
    holderNameController.text.isEmpty ||
    expiryDateController.text.isEmpty ||
    cvvController.text.isEmpty) {
  NotificationService().showError(context, 'Please fill all fields');
  return;
}
```

### Exception Handling

```dart
try {
  // Simulate payment processing
  await Future.delayed(const Duration(seconds: 2));
  
  // Create booking
  final booking = Booking(...);
  ref.read(bookingProvider.notifier).addBooking(booking);
  
  // Navigate to confirmation
  Navigator.pushReplacementNamed(context, '/ticket-confirmation', ...);
} catch (e) {
  setState(() => isProcessing = false);
  NotificationService().showError(context, 'Booking failed. Please try again.');
}
```

---

## 📊 State Debugging

### Print Riverpod State
```dart
// In console/logs
final methods = ref.watch(paymentMethodsProvider);
print('Payment methods: $methods');

final defaultMethod = ref.watch(defaultPaymentMethodProvider);
print('Default method: $defaultMethod');
```

### DevTools Support
- Riverpod DevTools can track state changes
- Use Flutter DevTools to inspect widget tree
- Check Network tab for future API calls (when implemented)

---

## 🔄 Future Backend Integration

### When Ready for Production Backend:

**Step 1: Create API Service**
```dart
class BookingApiService {
  Future<Booking> completeBooking(Booking booking) async {
    final response = await http.post(
      Uri.parse('$apiUrl/bookings'),
      body: jsonEncode(booking.toMap()),
    );
    if (response.statusCode == 200) {
      return Booking.fromMap(jsonDecode(response.body));
    }
    throw Exception('Failed to book');
  }
}
```

**Step 2: Replace Simulated Processing**
```dart
// Replace this:
await Future.delayed(const Duration(seconds: 2));

// With this:
final bookingResult = await apiService.completeBooking(booking);
```

**Step 3: Add Real Payment Gateway**
- Integrate Stripe/PayPal SDK
- Process payment before creating booking
- Store transaction ID in booking

---

## ✅ Deployment Checklist

- [ ] All imports are correct
- [ ] No unused imports
- [ ] State management working
- [ ] Notifications displaying properly
- [ ] Navigation flows working
- [ ] Forms validated
- [ ] Error handling in place
- [ ] Loading indicators showing
- [ ] UI responsive on all screen sizes
- [ ] Icons displaying correctly
- [ ] No console errors
- [ ] Test on physical device
- [ ] Test on emulator
- [ ] Performance optimized
- [ ] Accessibility checked

---

## 📞 Support & Troubleshooting

### Common Issues & Solutions

**Issue**: Notifications not showing
**Solution**: Ensure ScaffoldMessenger is in widget tree

**Issue**: Payment methods empty
**Solution**: Check Riverpod provider initialization

**Issue**: Navigation not working
**Solution**: Verify routes added to router.dart

**Issue**: Icons not displaying
**Solution**: Confirm fluentui_icons package installed

**Issue**: State not updating
**Solution**: Ensure using `ref.watch()` to listen to changes

---

## 📚 Documentation References

- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Guide](https://riverpod.dev)
- [Go Router Guide](https://pub.dev/packages/go_router)
- [Barcode Widget](https://pub.dev/packages/barcode_widget)
- [Material Design](https://material.io/design)

---

**Integration Guide Version**: 1.0
**Last Updated**: May 3, 2026
**Status**: Complete & Ready for Use
