import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bookticket/screen/home_screen.dart';
import 'package:bookticket/screen/search_screen.dart';
import 'package:bookticket/screen/ticket_detail_screen.dart';
import 'package:bookticket/screen/profile_screen.dart';
import 'package:bookticket/screen/hotel_detail_screen.dart';
import 'package:bookticket/screen/ticket_screen.dart';
import 'package:bookticket/screen/bottom_bar.dart';
import 'package:bookticket/screen/checkout_screen.dart';
import 'package:bookticket/screen/ticket_confirmation_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    ShellRoute(
      builder: (context, state, child) => BottomBar(child: child),
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          name: 'home',
          pageBuilder: (context, state) =>
              _buildPage(child: const HomeScreen(), state: state),
        ),
        GoRoute(
          path: '/search',
          name: 'search',
          pageBuilder: (context, state) =>
              _buildPage(child: const SearchScreen(), state: state),
        ),
        GoRoute(
          path: '/tickets',
          name: 'tickets',
          // FIX: TicketsScreen is the full screen that lists all tickets
          pageBuilder: (context, state) =>
              _buildPage(child: const TicketsScreen(), state: state),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          pageBuilder: (context, state) =>
              _buildPage(child: const ProfileScreen(), state: state),
        ),
      ],
    ),
    GoRoute(
      path: '/tickets/:id',
      name: 'ticket_detail',
      pageBuilder: (context, state) => _buildPage(
        child: TicketDetailScreen(
          ticketId: state.pathParameters['id']!,
        ),
        state: state,
      ),
    ),
    GoRoute(
      path: '/hotel/:id',
      name: 'hotel_detail',
      pageBuilder: (context, state) => _buildPage(
        child: HotelDetailScreen(
          hotelId: state.pathParameters['id']!,
        ),
        state: state,
      ),
    ),
    GoRoute(
      path: '/checkout',
      name: 'checkout',
      pageBuilder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        return _buildPage(
          child: CheckoutScreen(
            ticket: args?['ticket'],
            passengerName: args?['passengerName'] ?? '',
          ),
          state: state,
        );
      },
    ),
    GoRoute(
      path: '/ticket-confirmation',
      name: 'ticket_confirmation',
      pageBuilder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        return _buildPage(
          child: TicketConfirmationScreen(
            ticket: args?['ticket'],
            booking: args?['booking'],
          ),
          state: state,
        );
      },
    ),
  ],
);

CustomTransitionPage<void> _buildPage({
  required Widget child,
  required GoRouterState state,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 200),
    reverseTransitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: animation.drive(
            Tween<Offset>(
              begin: const Offset(0, 0.04),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeOut)),
          ),
          child: child,
        ),
      );
    },
  );
}
