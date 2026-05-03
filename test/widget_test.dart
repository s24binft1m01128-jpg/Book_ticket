import 'package:bookticket/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('SkyPass opens and navigates to search', (tester) async {
    print('SkyPass widget test: pumping MyApp…');
    await tester.pumpWidget(
      const ProviderScope(child: MyApp()),
    );
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Book Tickets'), findsOneWidget);
    expect(find.text('Upcoming Flights'), findsOneWidget);

    print('SkyPass widget test: opening Search tab…');
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();

    expect(find.text('Find your next trip'), findsOneWidget);
    expect(find.text('Flights'), findsOneWidget);

    print('SkyPass widget test: switching to Hotels…');
    await tester.tap(find.text('Hotels'));
    await tester.pumpAndSettle();

    expect(find.text('Find hotels'), findsOneWidget);
    expect(find.text('Available Hotels'), findsOneWidget);
    print('SkyPass widget test: completed successfully.');
  });
}
