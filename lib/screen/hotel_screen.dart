import 'package:bookticket/utils/app_layout.dart';
import 'package:bookticket/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HotelScreen extends StatelessWidget {
  final Map<String, dynamic> hotel;
  final VoidCallback? onTap;

  const HotelScreen({
    super.key,
    required this.hotel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getsize(context);
    final width = size.width >= 640 ? 300.0 : size.width * 0.64;

    return SizedBox(
      width: width,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(Styles.radius),
          child: Container(
            margin: const EdgeInsets.only(right: 16, top: 6, bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Styles.surfaceColor,
              borderRadius: BorderRadius.circular(Styles.radius),
              boxShadow: Styles.softShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1.22,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          '${hotel['image']}',
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.92),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  size: 16,
                                  color: Styles.accentColor,
                                ),
                                const Gap(3),
                                Text(
                                  '${hotel['rating']}',
                                  style: Styles.headlineStyle4.copyWith(
                                    color: Styles.textcolor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(12),
                Text(
                  hotel['place'],
                  style: Styles.headlineStyle3,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Gap(5),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 16,
                      color: Styles.mutedTextColor,
                    ),
                    const Gap(4),
                    Expanded(
                      child: Text(
                        '${hotel['destination']} • ${hotel['distance']}',
                        style: Styles.headlineStyle4,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const Gap(12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${hotel['price']}',
                      style: Styles.headlineStyle2.copyWith(
                        color: Styles.primarycolor,
                      ),
                    ),
                    const Gap(4),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Text(
                        '/night',
                        style: Styles.headlineStyle4,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
