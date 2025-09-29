import 'package:flutter/material.dart';
import 'package:image_identification_submisison_app/features/detail/detail_page.dart';
import 'package:image_identification_submisison_app/features/home/home_page.dart';
import 'package:image_identification_submisison_app/features/search/search_page.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  final List<Widget> _pages = [HomePage(), SearchPage(), DetailPage()];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0.1, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                ),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: Container(
          key: ValueKey<int>(_currentIndex),
          child: _pages[_currentIndex],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        indicatorColor: Theme.of(
          context,
        ).colorScheme.primary.withValues(alpha: 0.15),
        height: 64,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home),
            selectedIcon: Icon(
              Icons.home,
              color: Theme.of(context).colorScheme.primary,
            ),
            label: 'home',
            tooltip: 'home',
          ),
          NavigationDestination(
            icon: const Icon(Icons.search),
            selectedIcon: Icon(
              Icons.details,
              color: Theme.of(context).colorScheme.primary,
            ),
            label: 'search',
            tooltip: 'search',
          ),
          NavigationDestination(
            icon: const Icon(Icons.details),
            selectedIcon: Icon(
              Icons.details,
              color: Theme.of(context).colorScheme.primary,
            ),
            label: 'detail',
            tooltip: 'detail',
          ),
        ],
      ),
    );
  }
}
