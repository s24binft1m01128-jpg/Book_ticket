# UI/UX Design Guidelines - BookTicket Booking System

## 🎨 Design System

### Color Palette

| Color | Hex | Usage |
|-------|-----|-------|
| Primary Blue | #2F6FED | Buttons, headers, primary actions |
| Success Green | #00AA00 | Success states, confirmations |
| Error Red | #FF3333 | Errors, cancellations |
| Warning Orange | #FFA500 | Warnings, alerts |
| Info Cyan | #00CCFF | Information messages |
| Background White | #FFFFFF | Cards, surfaces |
| Light Gray | #F5F5F5 | Backgrounds, subtle elements |
| Dark Gray | #666666 | Secondary text |
| Text Black | #1A1A1A | Primary text |

### Typography

| Element | Font | Size | Weight | Usage |
|---------|------|------|--------|-------|
| Headline 1 | Roboto | 32px | Bold | Main titles |
| Headline 2 | Roboto | 24px | Bold | Section headers |
| Headline 3 | Roboto | 20px | Bold | Subsections |
| Headline 4 | Roboto | 16px | SemiBold | Emphasis text |
| Body | Roboto | 14px | Regular | Main content |
| Caption | Roboto | 12px | Regular | Secondary info |
| Label | Roboto | 10px | Regular | Labels, hints |

### Spacing Scale

```
4px   - Minimal spacing
8px   - Small spacing
12px  - Standard spacing
16px  - Card padding
20px  - Section spacing
24px  - Large section spacing
32px  - Extra large spacing
```

### Border Radius

- **Buttons & Small Elements**: `8px - 12px`
- **Cards**: `16px - 20px`
- **Bottom Sheets**: `24px - 28px`
- **Circular Elements**: `50% (BorderRadius.circular(50))`

---

## 📱 Screen Layouts

### 1. Payment Methods Screen

```
┌─────────────────────────────────┐
│ ← Payment Methods        Close   │
├─────────────────────────────────┤
│                                 │
│  ┌─────────────────────────┐   │
│  │ VISA        Default ✓   │   │
│  │ •••• •••• •••• 9010     │   │
│  │                         │   │
│  │ Cardholder  │  Expires  │   │
│  │ John Doe    │  12/25    │   │
│  │                         │   │
│  │ [Set Default]  [Delete] │   │
│  └─────────────────────────┘   │
│                                 │
│  ┌─────────────────────────┐   │
│  │ MASTERCARD              │   │
│  │ •••• •••• •••• 3010     │   │
│  │ [Set as Default] [Delete]   │
│  └─────────────────────────┘   │
│                                 │
│  ┌─────────────────────────┐   │
│  │ [+] Add Payment Method  │   │
│  └─────────────────────────┘   │
│                                 │
└─────────────────────────────────┘
```

### 2. Checkout Screen

```
┌─────────────────────────────────┐
│ ← Checkout              Close    │
├─────────────────────────────────┤
│                                 │
│  BOOKING SUMMARY                │
│  ┌─────────────────────────┐   │
│  │ NYC        5h 30m  LAX  │   │
│  │ 10:30 AM         3:00 PM│   │
│  │ Date: May 3  Seat: 12A  │   │
│  │ Price: $399.00          │   │
│  └─────────────────────────┘   │
│                                 │
│  PASSENGER INFORMATION          │
│  ┌─────────────────────────┐   │
│  │ 👤 John Doe             │   │
│  └─────────────────────────┘   │
│                                 │
│  SELECT PAYMENT METHOD          │
│  ◉ VISA ••• 9010 [Default]     │
│  ○ Mastercard ••• 3010         │
│                                 │
│  PRICE BREAKDOWN                │
│  Ticket:      $399.00          │
│  Tax (8%):    $ 31.92          │
│  ─────────────────────          │
│  TOTAL:       $430.92          │
│                                 │
│  [Complete Booking] (54.0%)    │
│                                 │
└─────────────────────────────────┘
```

### 3. Ticket Confirmation Screen

```
┌─────────────────────────────────┐
│ Booking Confirmed        ✓       │
├─────────────────────────────────┤
│            ⭕ ✓                  │
│      Payment Successful         │
│   Your booking has been         │
│      confirmed                  │
│                                 │
│  ┌─────────────────────────┐   │
│  │ BOOKING CODE            │   │
│  │ BK29384756     (copy)   │   │
│  │ Keep for check-in       │   │
│  └─────────────────────────┘   │
│                                 │
│  TICKET DETAILS                 │
│  ┌─────────────────────────┐   │
│  │ NYC     5h 30m     LAX  │   │
│  │ 10:30 AM       3:00 PM  │   │
│  │                         │   │
│  │ Terminal: T1  Gate: B12 │   │
│  │ Seat: 12A (Business)    │   │
│  │ Price: $399.00          │   │
│  └─────────────────────────┘   │
│                                 │
│  BARCODE                        │
│  ┌─────────────────────────┐   │
│  │  ║║║║ ║║║║ ║║║║        │   │
│  └─────────────────────────┘   │
│                                 │
│  QR CODE                        │
│  ┌─────────────────────────┐   │
│  │ ┌─────────────────┐     │   │
│  │ │ █ █ █ █ █ █ █ │     │   │
│  │ │ █ ▀ ▀ ▀ ▀ ▀ █ │     │   │
│  │ │ █ █ ▀ ▀ █ █ █ │     │   │
│  │ │ █ ▀ ▀ ▀ ▀ ▀ █ │     │   │
│  │ │ █ █ █ █ █ █ █ │     │   │
│  │ │ ▀ ▀ ▀ ▀ ▀ ▀ ▀ │     │   │
│  │ └─────────────────┘     │   │
│  │ Scan for check-in       │   │
│  └─────────────────────────┘   │
│                                 │
│  👤 John Doe (Passenger)        │
│  💳 Visa ••• 9010               │
│                                 │
│  [📤 Share]  [🏠 Home]         │
│                                 │
└─────────────────────────────────┘
```

---

## 🎯 Component Specifications

### Payment Method Card
- **Height**: Auto (min 120dp)
- **Padding**: 16dp all around
- **Border Radius**: 16dp
- **Shadow**: 0, 4, 12 (blur, offset, opacity)
- **Gap**: 12dp between items

**Sections**:
1. Header Row: Brand badge + Default badge
2. Card Number: Masked format with 2dp letter spacing
3. Details Row: Cardholder name + Expiry date
4. Action Buttons: Set Default + Delete

### Checkout Card
- **Padding**: 20dp
- **Border Radius**: 16dp
- **Divider**: After route, before details

**Sections**:
1. Route Overview: From → To with icon and flight time
2. Flight Details: 4-column grid (Date, Seat, Class, Airline)

### Confirmation Badge
- **Size**: 80×80dp
- **Icon Size**: 40dp
- **Background**: Green with 0.2 opacity
- **Animation**: Scale on entry

---

## ✨ Animation Guidelines

### Transitions
- **Duration**: 200-300ms for smooth feel
- **Curve**: Ease-in-out for natural motion
- **Fade + Slide**: Used for screen transitions

### Notifications
- **Fade In**: 200ms
- **Auto Dismiss**: 3 seconds
- **Slide From Top**: For entry animation

### Button States
- **Tap**: Scale 0.95
- **Loading**: Spinner inside button
- **Disabled**: Opacity 0.6, no interaction

---

## 🎨 Card Design Patterns

### Elevated Card
```dart
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 12,
        offset: Offset(0, 4),
      ),
    ],
  ),
)
```

### Gradient Card
```dart
Container(
  padding: EdgeInsets.all(20),
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFF2F6FED), Color(0xFF14B8A6)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(20),
  ),
)
```

### Status Badge
```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  decoration: BoxDecoration(
    color: Colors.green.withOpacity(0.2),
    borderRadius: BorderRadius.circular(8),
  ),
  child: Text('Default', style: TextStyle(color: Colors.green)),
)
```

---

## 📐 Responsive Design

### Breakpoints
| Device | Width | Constraints |
|--------|-------|-------------|
| Mobile | < 600dp | Full width with padding |
| Tablet | 600-900dp | Max 600dp content width |
| Desktop | > 900dp | Max 900dp content width |

**Implementation**:
```dart
ConstrainedBox(
  constraints: BoxConstraints(maxWidth: AppLayout.contentWidth(context)),
  child: ListView(...),
)
```

---

## 📋 Forms & Input Fields

### TextField Styling
```dart
TextField(
  decoration: InputDecoration(
    labelText: 'Card Number',
    filled: true,
    fillColor: Colors.grey[100],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Styles.primarycolor, width: 2),
    ),
  ),
)
```

### Dropdown Styling
- **Background**: `Colors.grey[100]`
- **Border Radius**: `12dp`
- **Padding**: `12dp` horizontal
- **Icon Color**: Primary color

---

## 🔔 Notification Styles

### Success
- **Icon**: Check Circle
- **Color**: #00AA00
- **Duration**: 3 seconds

### Error
- **Icon**: Error Circle
- **Color**: #FF3333
- **Duration**: 4 seconds (longer for errors)

### Info
- **Icon**: Info Circle
- **Color**: #00CCFF
- **Duration**: 3 seconds

### Warning
- **Icon**: Warning Triangle
- **Color**: #FFA500
- **Duration**: 4 seconds

---

## 📦 Code Structure for New Screens

```
lib/
├── models/
│   └── payment_model.dart (PaymentMethod, Booking)
├── providers/
│   └── payment_provider.dart (State management)
├── screen/
│   ├── payment_methods_screen.dart
│   ├── checkout_screen.dart
│   ├── ticket_confirmation_screen.dart
│   └── ticket_detail_screen.dart (updated)
├── utils/
│   └── notification_service.dart
├── widgets/ (if creating reusable components)
└── router.dart (updated with new routes)
```

---

## ✅ Perfect Pixel Checklist

- [x] All spacing uses scale (4, 8, 12, 16, 20, 24, 32)
- [x] Border radius consistent (8, 12, 16, 20)
- [x] Shadow depths match design system
- [x] Text sizes aligned to typography scale
- [x] Icon sizes: 16, 20, 24, 32, 40, 48
- [x] Component heights: 40, 44, 48, 52, 56
- [x] Card padding: 12, 16, 20, 24
- [x] Gaps consistent throughout
- [x] Colors from palette only
- [x] Animations smooth and timed

---

## 🚀 Implementation Tips

1. **Use Constants**: Define all measurements in a constants file
2. **Reusable Widgets**: Create custom widgets for repeated patterns
3. **Theme Integration**: Use Styles class for consistency
4. **Testing**: Test on multiple screen sizes
5. **Accessibility**: Ensure proper contrast and font sizes
6. **Performance**: Optimize images and animations

---

**Design System Version**: 1.0
**Last Updated**: May 3, 2026
**Status**: Complete & Production Ready
