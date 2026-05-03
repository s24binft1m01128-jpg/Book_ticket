import 'dart:async';
import 'package:bookticket/providers/profile_provider.dart';
import 'package:bookticket/providers/search_provider.dart';
import 'package:bookticket/providers/ticket_provider.dart';
import 'package:bookticket/providers/hotel_provider.dart';
import 'package:bookticket/models/ticket_model.dart';
import 'package:bookticket/models/user_profile.dart';
import 'package:bookticket/utils/app_layout.dart';
import 'package:bookticket/utils/app_styles.dart';
import 'package:bookticket/widgets/double_text_widget.dart';
import 'package:bookticket/widgets/hotel_card.dart';
import 'package:bookticket/widgets/ticket_view.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      ref.read(searchQueryProvider.notifier).state = value;
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = AppLayout.horizontalPadding(context);
    final UserProfile userProfile = ref.watch(userProfileProvider);
    final List<TicketModel> tickets = ref.watch(ticketListProvider);
    final hotels = ref.watch(hotelListProvider);

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
                _TopBar(userProfile: userProfile),
                const Gap(24),
                _SearchBar(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                ),
                const Gap(32),
                if (tickets.isNotEmpty)
                  _HeroTripCard(ticket: tickets.first)
                else
                  const SizedBox.shrink(),
                const Gap(32),
                DoubleTextWidget(
                  bigtext: 'Upcoming Flights',
                  smalltext: 'View all',
                  onTap: () => context.push('/search'),
                ),
                const Gap(16),
                if (tickets.isNotEmpty)
                  SizedBox(
                    height: 189,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: tickets.length,
                      itemBuilder: (context, index) {
                        final ticket = tickets[index];
                        return TicketView(
                          ticket: ticket,
                          onTap: () =>
                              context.push('/tickets/${ticket.number}'),
                        );
                      },
                    ),
                  )
                else
                  const SizedBox.shrink(),
                const Gap(32),
                DoubleTextWidget(
                  bigtext: 'Recommended Hotels',
                  smalltext: 'View all',
                  onTap: () => context.push('/search'),
                ),
                const Gap(16),
                if (hotels.isNotEmpty)
                  SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: hotels.length,
                      itemBuilder: (context, index) {
                        return HotelCard(hotel: hotels[index]);
                      },
                    ),
                  )
                else
                  const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Top Bar ─────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final UserProfile userProfile;

  const _TopBar({required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning, ${userProfile.name}',
                style: Styles.headlineStyle4,
              ),
              const Gap(6),
              const Text(
                'Book Tickets',
                style: Styles.headlineStyle1,
              ),
            ],
          ),
        ),
        IconButton.filledTonal(
          onPressed: () {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('You have 2 trip updates.')),
              );
          },
          icon: const Icon(FluentSystemIcons.ic_fluent_alert_regular),
        ),
        const Gap(10),
        GestureDetector(
          onTap: () => context.push('/profile'),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              userProfile.avatarPath,
              width: 52,
              height: 52,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Search Bar ──────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchBar({
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search flights, cities, or hotels',
        prefixIcon: const Icon(FluentSystemIcons.ic_fluent_search_regular),
        suffixIcon: controller.text.isEmpty
            ? null
            : AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 200),
                child: IconButton(
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                  icon: const Icon(Icons.close_rounded),
                ),
              ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

// ─── Hero Trip Card ───────────────────────────────────────────────────────────

class _HeroTripCard extends StatelessWidget {
  final TicketModel ticket;

  const _HeroTripCard({required this.ticket});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/tickets/${ticket.number}'),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            colors: [Color(0xFF172033), Color(0xFF2F6FED)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2F6FED).withValues(alpha: 0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Status + flight icon ────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    ticket.status,
                    style: Styles.headlineStyle4.copyWith(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
                Icon(
                  Icons.flight_takeoff_rounded,
                  color: Colors.white.withValues(alpha: 0.88),
                ),
              ],
            ),
            const Gap(22),
            // ── From / duration / To ────────────────────────────────────────
            Row(
              children: [
                _HeroAirport(
                  code: ticket.fromCode,
                  city: ticket.fromName,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Container(
                          height: 2,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.42),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        const Gap(7),
                        Text(
                          ticket.flyingTime,
                          style: Styles.headlineStyle4.copyWith(
                            color: Colors.white.withValues(alpha: 0.78),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _HeroAirport(
                  code: ticket.toCode,
                  city: ticket.toName,
                  alignEnd: true,
                ),
              ],
            ),
            const Gap(22),
            // ── Date | Gate | Book now ──────────────────────────────────────
            Row(
              children: [
                _StatPill(label: 'Date', value: ticket.date),
                const Gap(10),
                _StatPill(label: 'Gate', value: ticket.gate),
                const Gap(10),
                Expanded(
                  child: FilledButton(
                    onPressed: () => context.push('/tickets/${ticket.number}'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Styles.textcolor,
                      minimumSize: const Size(120, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Book now'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Hero Airport ─────────────────────────────────────────────────────────────

class _HeroAirport extends StatelessWidget {
  final String code;
  final String city;
  final bool alignEnd;

  const _HeroAirport({
    required this.code,
    required this.city,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          code,
          style: Styles.headlineStyle1.copyWith(
            color: Colors.white,
            fontSize: 32,
          ),
        ),
        const Gap(4),
        Text(
          city,
          style: Styles.headlineStyle4.copyWith(
            color: Colors.white.withValues(alpha: 0.76),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// ─── Stat Pill ────────────────────────────────────────────────────────────────

class _StatPill extends StatelessWidget {
  final String label;
  final String value;

  const _StatPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 76),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Styles.headlineStyle4.copyWith(
              color: Colors.white.withValues(alpha: 0.70),
              fontSize: 12,
            ),
          ),
          const Gap(2),
          Text(
            value,
            style: Styles.textStyle.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
