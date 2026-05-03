import 'package:bookticket/utils/app_styles.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomBar extends StatefulWidget {
  final Widget child;

  const BottomBar({super.key, required this.child});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  final List<String> _routes = const ['/', '/search', '/tickets', '/profile'];

  @override
  void didUpdateWidget(BottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateIndexFromLocation();
  }

  void _updateIndexFromLocation() {
    final location = GoRouterState.of(context).uri.path;
    int newIndex = 0;
    if (location.startsWith('/search')) {
      newIndex = 1;
    } else if (location.startsWith('/tickets')) {
      newIndex = 2;
    } else if (location.startsWith('/profile')) {
      newIndex = 3;
    }
    if (newIndex != _selectedIndex) {
      setState(() {
        _selectedIndex = newIndex;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    context.go(_routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: widget.child,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
          child: Material(
            elevation: 0,
            color: Colors.transparent,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Styles.surfaceColor,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Styles.lineColor.withValues(alpha: 0.55)),
                boxShadow: Styles.softShadow,
              ),
              child: NavigationBar(
                selectedIndex: _selectedIndex,
                onDestinationSelected: _onItemTapped,
                height: 68,
                elevation: 0,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                indicatorColor: Styles.primarycolor.withValues(alpha: 0.14),
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                destinations: const [
                  NavigationDestination(
                    icon: Icon(FluentSystemIcons.ic_fluent_home_regular),
                    selectedIcon: Icon(FluentSystemIcons.ic_fluent_home_filled),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Icon(FluentSystemIcons.ic_fluent_search_regular),
                    selectedIcon:
                        Icon(FluentSystemIcons.ic_fluent_search_filled),
                    label: 'Search',
                  ),
                  NavigationDestination(
                    icon: Icon(FluentSystemIcons.ic_fluent_ticket_regular),
                    selectedIcon:
                        Icon(FluentSystemIcons.ic_fluent_ticket_filled),
                    label: 'Tickets',
                  ),
                  NavigationDestination(
                    icon: Icon(FluentSystemIcons.ic_fluent_person_regular),
                    selectedIcon:
                        Icon(FluentSystemIcons.ic_fluent_person_filled),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
