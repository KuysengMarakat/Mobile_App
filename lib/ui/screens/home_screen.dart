import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import 'scan_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

/// Home screen with bottom navigation bar hosting Scan, History, Settings.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    ScanScreen(),
    HistoryScreen(),
    SettingsScreen(),
  ];

  final List<String> _titles = const [
    'Phneak Teb',
    'Scan History',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        backgroundColor: AppTheme.primaryPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(
            _currentIndex == 0
                ? Icons.visibility
                : _currentIndex == 1
                    ? Icons.history
                    : Icons.settings,
            color: AppTheme.accentGold,
          ),
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: AppTheme.primaryPurple,
        unselectedItemColor: AppTheme.darkGray,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            activeIcon: Icon(Icons.saved_search),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            activeIcon: Icon(Icons.history_toggle_off),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
