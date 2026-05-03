import 'dart:async';

import 'package:google_fonts/google_fonts.dart';

/// Runs before all tests in this package.
///
/// Disables downloading fonts from fonts.googleapis.com so widget tests stay
/// fast and deterministic when run from the IDE (VM Service) or CI — no network.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  GoogleFonts.config.allowRuntimeFetching = false;
  await testMain();
}
