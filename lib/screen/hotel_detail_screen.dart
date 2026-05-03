import 'package:bookticket/providers/hotel_provider.dart';
import 'package:bookticket/utils/app_layout.dart';
import 'package:bookticket/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class HotelDetailScreen extends ConsumerWidget {
  final String hotelId;

  const HotelDetailScreen({super.key, required this.hotelId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hotelAsync = ref.watch(hotelByIdProvider(hotelId));
    final horizontalPadding = AppLayout.horizontalPadding(context);

    return hotelAsync.when(
      data: (hotel) {
        if (hotel == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Hotel Details')),
            body: const Center(child: Text('Hotel not found')),
          );
        }

        return Scaffold(
          backgroundColor: Styles.bgcolor,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 260,
                floating: true,
                snap: true,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.asset(
                    hotel.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(22),
                      topRight: Radius.circular(22),
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    20,
                    horizontalPadding,
                    28,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              hotel.place,
                              style: Styles.headlineStyle2,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Gap(12),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Color(0xFFFFB545),
                                size: 18,
                              ),
                              const Gap(4),
                              Text(
                                '${hotel.rating}',
                                style: Styles.textStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Gap(12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Styles.bgcolor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 16,
                              color: Styles.primarycolor,
                            ),
                            const Gap(6),
                            Flexible(
                              child: Text(
                                hotel.distance,
                                style: Styles.headlineStyle4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Price per night',
                                style: Styles.headlineStyle4,
                              ),
                              const Gap(4),
                              Row(
                                children: [
                                  Text(
                                    '\$${hotel.price.toStringAsFixed(0)}',
                                    style: Styles.headlineStyle1,
                                  ),
                                  const Gap(6),
                                  Text(
                                    '/night',
                                    style: Styles.headlineStyle4,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 1,
                            height: 50,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Styles.lineColor,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                hotel.destination,
                                style: Styles.headlineStyle4,
                              ),
                              const Gap(4),
                              Text(
                                hotel.place,
                                style: Styles.textStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Gap(20),
                      Text(
                        'Amenities',
                        style: Styles.headlineStyle3,
                      ),
                      const Gap(12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          const _AmenityChip(icon: Icons.wifi, label: 'WiFi'),
                          const _AmenityChip(icon: Icons.pool, label: 'Pool'),
                          const _AmenityChip(
                              icon: Icons.fitness_center, label: 'Gym'),
                          const _AmenityChip(
                              icon: Icons.restaurant, label: 'Restaurant'),
                        ],
                      ),
                      const Gap(24),
                      FilledButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Booking confirmed for ${hotel.place}!',
                                ),
                              ),
                            );
                        },
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text('Book this hotel'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Loading')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _AmenityChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _AmenityChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Styles.lineColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Styles.primarycolor),
          const Gap(6),
          Text(label, style: Styles.textStyle),
        ],
      ),
    );
  }
}
