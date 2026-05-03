import 'package:bookticket/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SkyPass opens and navigates to search', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Book Tickets'), findsOneWidget);
    expect(find.text('Upcoming Flights'), findsOneWidget);

    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();

    expect(find.text('Find your next trip'), findsOneWidget);
    expect(find.text('Flights'), findsOneWidget);

    await tester.tap(find.text('Hotels'));
    await tester.pumpAndSettle();

    expect(find.text('Find hotels'), findsOneWidget);
    expect(find.text('Available Hotels'), findsOneWidget);
  });
}
