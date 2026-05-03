import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedTabProvider = StateProvider<int>((ref) => 0);

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchModeProvider = StateProvider<String>((ref) => 'flights');
