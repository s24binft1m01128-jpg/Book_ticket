import 'package:bookticket/models/ticket_model.dart';
import 'package:bookticket/models/hotel_model.dart';
import 'package:bookticket/providers/hotel_provider.dart';
import 'package:bookticket/providers/ticket_provider.dart';
import 'package:bookticket/utils/app_layout.dart';
import 'package:bookticket/utils/app_styles.dart';
import 'package:bookticket/widgets/hotel_card.dart';
import 'package:bookticket/widgets/ticket_tabs.dart';
import 'package:bookticket/widgets/ticket_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _fromController =
      TextEditingController(text: 'New York');
  final TextEditingController _toController =
      TextEditingController(text: 'London');
  final TextEditingController _hotelController =
      TextEditingController(text: 'London');

  int _modeIndex = 0;
  bool _searched = false;

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _hotelController.dispose();
    super.dispose();
  }

  List<TicketModel> _getFlightResults(List<TicketModel> tickets) {
    final from = _fromController.text.trim().toLowerCase();
    final to = _toController.text.trim().toLowerCase();

    return tickets.where((t) {
      final fromSearch = '${t.fromCode} ${t.fromName}'.toLowerCase();
      final toSearch = '${t.toCode} ${t.toName}'.toLowerCase();
      final matchesFrom = from.isEmpty || fromSearch.contains(from);
      final matchesTo = to.isEmpty || toSearch.contains(to);
      return matchesFrom && matchesTo;
    }).toList();
  }

  List<HotelModel> _getHotelResults(List<HotelModel> hotels) {
    final query = _hotelController.text.trim().toLowerCase();
    if (query.isEmpty) return hotels;
    return hotels.where((h) {
      final searchable = '${h.place} ${h.destination}'.toLowerCase();
      return searchable.contains(query);
    }).toList();
  }

  void _onFind(int flightCount, int hotelCount) {
    setState(() => _searched = true);
    final count = _modeIndex == 0 ? flightCount : hotelCount;
    final label = _modeIndex == 0 ? 'flight' : 'hotel';
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            count == 1 ? '1 $label found.' : '$count ${label}s found.',
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = AppLayout.horizontalPadding(context);

    final List<TicketModel> allTickets = ref.watch(ticketListProvider);
    final List<HotelModel> allHotels = ref.watch(hotelListProvider);

    final flightResults = _getFlightResults(allTickets);
    final hotelResults = _getHotelResults(allHotels);
    final resultCount =
        _modeIndex == 0 ? flightResults.length : hotelResults.length;

    return Scaffold(
      backgroundColor: Styles.bgcolor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: AppLayout.contentWidth(context),
            ),
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                20,
                horizontalPadding,
                28,
              ),
              children: [
                const Text(
                  'Find your next trip',
                  style: Styles.headlineStyle1,
                ),
                const Gap(18),
                AppTicketTabs(
                  firstTabs: 'Flights',
                  secondTabs: 'Hotels',
                  selectedIndex: _modeIndex,
                  onChanged: (index) => setState(() {
                    _modeIndex = index;
                    _searched = false;
                  }),
                ),
                const Gap(20),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: _modeIndex == 0
                      ? _FlightSearchForm(
                          key: const ValueKey('flights'),
                          fromController: _fromController,
                          toController: _toController,
                          onChanged: () => setState(() {}),
                        )
                      : _HotelSearchForm(
                          key: const ValueKey('hotels'),
                          controller: _hotelController,
                          onChanged: () => setState(() {}),
                        ),
                ),
                const Gap(18),
                FilledButton.icon(
                  onPressed: () =>
                      _onFind(flightResults.length, hotelResults.length),
                  icon: Icon(
                    _modeIndex == 0
                        ? Icons.flight_takeoff_rounded
                        : Icons.hotel_rounded,
                  ),
                  label: Text(
                    _modeIndex == 0 ? 'Find tickets' : 'Find hotels',
                  ),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
                const Gap(26),

                // ── Results header ──────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _modeIndex == 0
                            ? 'Available Flights'
                            : 'Available Hotels',
                        style: Styles.headlineStyle2,
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: _searched
                          ? Container(
                              key: ValueKey(resultCount),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Styles.primarycolor
                                    .withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '$resultCount found',
                                style: Styles.headlineStyle4.copyWith(
                                  color: Styles.primarycolor,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
                const Gap(14),

                // ── Results ─────────────────────────────────────────────
                if (_modeIndex == 0)
                  flightResults.isEmpty && _searched
                      ? const _EmptyState(
                          message: 'No flights found for your search.',
                        )
                      : Column(
                          children: flightResults.map((ticket) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: TicketView(
                                ticket: ticket,   // ← TicketModel directly
                                isColor: true,
                                wholeScreen: true,
                              ),
                            );
                          }).toList(),
                        )
                else
                  hotelResults.isEmpty && _searched
                      ? const _EmptyState(
                          message: 'No hotels found for your search.',
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          child: Row(
                            children: hotelResults
                                .map((hotel) => HotelCard(hotel: hotel))
                                .toList(),
                          ),
                        ),

                const Gap(24),
                const _OfferPanel(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Flight Search Form ──────────────────────────────────────────────────────

class _FlightSearchForm extends StatelessWidget {
  final TextEditingController fromController;
  final TextEditingController toController;
  final VoidCallback onChanged;

  const _FlightSearchForm({
    super.key,
    required this.fromController,
    required this.toController,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SearchField(
          controller: fromController,
          hint: 'Departure city or code',
          icon: Icons.flight_takeoff_rounded,
          onChanged: onChanged,
        ),
        const Gap(10),
        _SearchField(
          controller: toController,
          hint: 'Arrival city or code',
          icon: Icons.flight_land_rounded,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

// ─── Hotel Search Form ───────────────────────────────────────────────────────

class _HotelSearchForm extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const _HotelSearchForm({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _SearchField(
      controller: controller,
      hint: 'Destination city',
      icon: Icons.location_on_rounded,
      onChanged: onChanged,
    );
  }
}

// ─── Shared Search Field ─────────────────────────────────────────────────────

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final VoidCallback onChanged;

  const _SearchField({
    required this.controller,
    required this.hint,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: (_) => onChanged(),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

// ─── Offer Panel ─────────────────────────────────────────────────────────────

class _OfferPanel extends StatelessWidget {
  const _OfferPanel();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _OfferCard(
            backgroundColor: Styles.secondaryColor,
            icon: Icons.percent_rounded,
            title: '20% early deal',
            subtitle: 'Book 3 months ahead and save.',
          ),
        ),
        Gap(12),
        Expanded(
          child: _OfferCard(
            backgroundColor: Styles.orangecolor,
            icon: Icons.card_giftcard_rounded,
            title: 'Miles booster',
            subtitle: 'Earn double miles on hotel stays.',
          ),
        ),
      ],
    );
  }
}

class _OfferCard extends StatelessWidget {
  final Color backgroundColor;
  final IconData icon;
  final String title;
  final String subtitle;

  const _OfferCard({
    required this.backgroundColor,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 154),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(Styles.radius),
        boxShadow: Styles.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const Gap(18),
          Text(
            title,
            style: Styles.headlineStyle3.copyWith(color: Colors.white),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Gap(8),
          Text(
            subtitle,
            style: Styles.headlineStyle4.copyWith(
              color: Colors.white.withValues(alpha: 0.82),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ─── Empty State ─────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final String message;

  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Styles.radius),
        border: Border.all(color: Styles.lineColor),
      ),
      child: Text(message, style: Styles.headlineStyle4),
    );
  }
}