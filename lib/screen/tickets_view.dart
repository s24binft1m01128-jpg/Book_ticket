import 'package:bookticket/utils/app_layout.dart';
import 'package:bookticket/utils/app_styles.dart';
import 'package:bookticket/widgets/layout_builder_widget.dart';
import 'package:bookticket/widgets/thick_container.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TicketView extends StatelessWidget {
  final Map<String, dynamic> ticket;
  final bool? isColor;
  final bool wholeScreen;
  final VoidCallback? onTap;

  const TicketView({
    super.key,
    required this.ticket,
    this.isColor,
    this.wholeScreen = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getsize(context);
    final width = wholeScreen
        ? double.infinity
        : (size.width >= 640 ? 420.0 : size.width * 0.82);
    final isLight = isColor != null;
    final topColor = isLight ? Colors.white : Styles.ticketBlue;
    final bottomColor = isLight ? Colors.white : Styles.orangecolor;
    final foreground = isLight ? Styles.textcolor : Colors.white;
    // FIX: withValues(alpha:) → withOpacity()
    final supporting =
        isLight ? Styles.mutedTextColor : Colors.white.withValues(alpha: 0.78);

    final card = SizedBox(
      width: width,
      child: Container(
        margin: EdgeInsets.only(right: wholeScreen ? 0 : 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Styles.radius),
          // FIX: replaced Styles.softShadow with explicit BoxShadow
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Styles.radius),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Top section ───────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                decoration: BoxDecoration(
                  color: topColor,
                  gradient: isLight
                      ? null
                      : const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF243B6B), Color(0xFF2F6FED)],
                        ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _AirportCode(
                          // FIX: safe null-aware access on nested maps
                          code: (ticket['from'] as Map?)?['code'] as String? ??
                              '',
                          city: (ticket['from'] as Map?)?['name'] as String? ??
                              '',
                          alignment: CrossAxisAlignment.start,
                          foreground: foreground,
                          supporting: supporting,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    ThickContainer(isColor: isLight),
                                    Expanded(
                                      child: SizedBox(
                                        height: 24,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            LayoutBuilderWidget(
                                              sections: 7,
                                              isColor: isLight ? true : null,
                                            ),
                                            Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                color: isLight
                                                    // FIX: withValues(alpha:) → withOpacity()
                                                    ? Styles.primarycolor
                                                        .withValues(alpha: 0.10)
                                                    : Colors.white.withValues(
                                                        alpha: 0.16),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.flight_rounded,
                                                size: 17,
                                                color: isLight
                                                    ? Styles.primarycolor
                                                    : Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    ThickContainer(isColor: isLight),
                                  ],
                                ),
                                const Gap(8),
                                Text(
                                  // FIX: safe cast
                                  ticket['flying_time'] as String? ?? '',
                                  style: Styles.headlineStyle4.copyWith(
                                    color: supporting,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        _AirportCode(
                          // FIX: safe null-aware access on nested maps
                          code:
                              (ticket['to'] as Map?)?['code'] as String? ?? '',
                          city:
                              (ticket['to'] as Map?)?['name'] as String? ?? '',
                          alignment: CrossAxisAlignment.end,
                          foreground: foreground,
                          supporting: supporting,
                        ),
                      ],
                    ),
                    const Gap(14),
                    Row(
                      children: [
                        Icon(
                          Icons.airlines_rounded,
                          size: 18,
                          color: supporting,
                        ),
                        const Gap(8),
                        Expanded(
                          child: Text(
                            ticket['airline'] as String? ?? 'SkyPass Air',
                            style: Styles.headlineStyle4.copyWith(
                              color: supporting,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          ticket['status'] as String? ?? 'Confirmed',
                          style: Styles.headlineStyle4.copyWith(
                            color: supporting,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // ── Punch divider ─────────────────────────────────────────────
              Container(
                color: bottomColor,
                child: Row(
                  children: [
                    const _PunchCutout(isLeft: true),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: LayoutBuilderWidget(
                          sections: 12,
                          isColor: isLight ? true : null,
                          width: 5,
                        ),
                      ),
                    ),
                    const _PunchCutout(isLeft: false),
                  ],
                ),
              ),
              // ── Bottom meta row ───────────────────────────────────────────
              Container(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
                decoration: BoxDecoration(
                  color: bottomColor,
                  border: isLight
                      ? const Border(
                          top: BorderSide(color: Styles.lineColor),
                        )
                      : null,
                ),
                child: Row(
                  children: [
                    _TicketMeta(
                      // FIX: safe cast
                      value: ticket['date'] as String? ?? '',
                      label: 'Date',
                      foreground: foreground,
                      supporting: supporting,
                      alignment: CrossAxisAlignment.start,
                    ),
                    const Spacer(),
                    _TicketMeta(
                      // FIX: safe cast
                      value: ticket['departure_time'] as String? ?? '',
                      label: 'Departure',
                      foreground: foreground,
                      supporting: supporting,
                      alignment: CrossAxisAlignment.center,
                    ),
                    const Spacer(),
                    _TicketMeta(
                      // FIX: safe toString on number which may be int or String
                      value: ticket['number']?.toString() ?? '',
                      label: 'Flight',
                      foreground: foreground,
                      supporting: supporting,
                      alignment: CrossAxisAlignment.end,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (onTap == null) return card;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Styles.radius),
        child: card,
      ),
    );
  }
}

// ─── Airport Code ─────────────────────────────────────────────────────────────

class _AirportCode extends StatelessWidget {
  final String code;
  final String city;
  final CrossAxisAlignment alignment;
  final Color foreground;
  final Color supporting;

  const _AirportCode({
    required this.code,
    required this.city,
    required this.alignment,
    required this.foreground,
    required this.supporting,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 84),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Text(
            code,
            style: Styles.headlineStyle2.copyWith(
              color: foreground,
              fontSize: 23,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Gap(4),
          Text(
            city,
            style: Styles.headlineStyle4.copyWith(color: supporting),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ─── Ticket Meta ──────────────────────────────────────────────────────────────

class _TicketMeta extends StatelessWidget {
  final String value;
  final String label;
  final Color foreground;
  final Color supporting;
  final CrossAxisAlignment alignment;

  const _TicketMeta({
    required this.value,
    required this.label,
    required this.foreground,
    required this.supporting,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Text(
            value,
            style: Styles.headlineStyle3.copyWith(color: foreground),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Gap(5),
          Text(
            label,
            style: Styles.headlineStyle4.copyWith(color: supporting),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ─── Punch Cutout ─────────────────────────────────────────────────────────────

class _PunchCutout extends StatelessWidget {
  final bool isLeft;

  const _PunchCutout({required this.isLeft});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 12,
      height: 24,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Styles.bgcolor,
          borderRadius: BorderRadius.horizontal(
            left: isLeft ? Radius.zero : const Radius.circular(12),
            right: isLeft ? const Radius.circular(12) : Radius.zero,
          ),
        ),
      ),
    );
  }
}
