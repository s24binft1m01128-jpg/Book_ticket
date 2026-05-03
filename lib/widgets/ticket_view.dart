import 'package:bookticket/models/ticket_model.dart';
import 'package:bookticket/utils/app_styles.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TicketView extends StatelessWidget {
  // FIX 1: TicketModel not Ticket
  final TicketModel ticket;
  final bool? isColor;
  final bool wholeScreen;
  // FIX 2: VoidCallback? not required Future<Object?> Function()
  final VoidCallback? onTap;

  const TicketView({
    super.key,
    required this.ticket,
    this.isColor,
    this.wholeScreen = false,
    this.onTap, // FIX 3: optional, not required
  });

  @override
  Widget build(BuildContext context) {
    final isBig = isColor == null;

    final stackGap = wholeScreen ? 16.0 : (isBig ? 10.0 : 12.0);

    final card = Container(
      width: wholeScreen ? double.maxFinite : 323,
      height: wholeScreen ? null : 228,
      margin: EdgeInsets.only(right: wholeScreen ? 0 : 16),
      padding: EdgeInsets.all(wholeScreen ? 16 : 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isBig ? 28 : 20),
        gradient: isBig ? Styles.ticketHeroGradient : Styles.ticketLightGradient,
        border: isBig
            ? null
            : Border.all(color: Styles.lineColor.withValues(alpha: 0.45)),
        boxShadow: isBig ? Styles.softShadow : Styles.cardLift,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TicketHeader(ticket: ticket, isBig: isBig),
          Gap(stackGap),
          _TicketRoute(ticket: ticket, isBig: isBig),
          Gap(stackGap),
          _TicketDetails(ticket: ticket, isBig: isBig, onTap: onTap),
        ],
      ),
    );

    return onTap != null ? GestureDetector(onTap: onTap, child: card) : card;
  }
}

// ─── Ticket Header ───────────────────────────────────────────────────────────

class _TicketHeader extends StatelessWidget {
  // FIX: TicketModel not Ticket
  final TicketModel ticket;
  final bool isBig;

  const _TicketHeader({
    required this.ticket,
    required this.isBig,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color:
                isBig ? Colors.white.withValues(alpha: 0.14) : Styles.surfaceMuted,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            ticket.status,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isBig ? Colors.white : Styles.textcolor,
            ),
          ),
        ),
        Icon(
          FluentSystemIcons.ic_fluent_airplane_regular,
          color: isBig ? Colors.white : Styles.textcolor,
        ),
      ],
    );
  }
}

// ─── Ticket Route ────────────────────────────────────────────────────────────

class _TicketRoute extends StatelessWidget {
  // FIX: TicketModel not Ticket
  final TicketModel ticket;
  final bool isBig;

  const _TicketRoute({
    required this.ticket,
    required this.isBig,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ticket.fromCode,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: isBig ? Colors.white : Styles.textcolor,
              ),
            ),
            Gap(isBig ? 2 : 4),
            Text(
              ticket.fromName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isBig ? Colors.white : Styles.mutedTextColor,
              ),
            ),
          ],
        ),
        Expanded(
          child: Column(
            children: [
              SizedBox(
                height: 24,
                child: _DashedLine(
                  color: isBig ? Colors.white : Styles.lineColor,
                ),
              ),
              Gap(isBig ? 0 : 4),
              Icon(
                FluentSystemIcons.ic_fluent_arrow_right_regular,
                color: isBig ? Colors.white : Styles.textcolor,
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              ticket.toCode,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: isBig ? Colors.white : Styles.textcolor,
              ),
            ),
            Gap(isBig ? 2 : 4),
            Text(
              ticket.toName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isBig ? Colors.white : Styles.mutedTextColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Ticket Details ──────────────────────────────────────────────────────────

class _TicketDetails extends StatelessWidget {
  // FIX: TicketModel not Ticket
  final TicketModel ticket;
  final bool isBig;
  final VoidCallback? onTap;

  const _TicketDetails({
    required this.ticket,
    required this.isBig,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ticket.date,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isBig ? Colors.white : Styles.mutedTextColor,
              ),
            ),
            Gap(isBig ? 2 : 4),
            Text(
              ticket.departureTime,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isBig ? Colors.white : Styles.textcolor,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Gate',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isBig ? Colors.white : Styles.mutedTextColor,
              ),
            ),
            Gap(isBig ? 2 : 4),
            Text(
              ticket.gate,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isBig ? Colors.white : Styles.textcolor,
              ),
            ),
          ],
        ),
        SizedBox(
          width: 100,
          child: FilledButton(
            // FIX: uses onTap callback from parent — no internal navigation
            onPressed: onTap,
            style: FilledButton.styleFrom(
              backgroundColor: isBig ? Colors.white : Styles.primarycolor,
              foregroundColor: isBig ? Styles.primarycolor : Colors.white,
              minimumSize: const Size(double.maxFinite, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              isBig ? 'Book now' : 'View',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Dashed Line ─────────────────────────────────────────────────────────────

class _DashedLine extends StatelessWidget {
  final Color color;

  const _DashedLine({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedLinePainter(color: color),
      size: const Size.fromWidth(100), // FIX: const added
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;

  const _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) =>
      oldDelegate.color != color;
}
