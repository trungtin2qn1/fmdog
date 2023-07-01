import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fmdog/ui/home/home_screen.dart';
import 'package:fmdog/ui/insights/insights_screen.dart';
import 'package:fmdog/ui/settings/settings_screen.dart';
import 'package:fmdog/core/theme/theme.dart';

class BottomNavigationState extends StatefulWidget {
  const BottomNavigationState({
    Key? key,
  }) : super(key: key);

  @override
  State createState() => _BottomNavigationState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _BottomNavigationState extends State<BottomNavigationState> {
  int _selectedIndex = 0;

  final int homeScreen = 0;
  final int insightsScreen = 1;
  final int settingsScreen = 2;

  static const List<Widget> _widgetOptions = [
    HomePage(),
    InsightsScreen(),
    SettingsScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: iconEmojiWidget(Icons.home, Colors.grey),
              activeIcon: iconEmojiWidget(Icons.home, context.appPrimaryColor),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: iconEmojiWidget(Icons.insights_outlined, Colors.grey),
              activeIcon:
                  iconEmojiWidget(Icons.insights, context.appPrimaryColor),
              label: 'Insights',
            ),
            BottomNavigationBarItem(
              icon: iconEmojiWidget(Icons.settings, Colors.grey),
              activeIcon:
                  iconEmojiWidget(Icons.settings, context.appPrimaryColor),
              label: 'Settings',
            ),
          ],
          type: BottomNavigationBarType.fixed,
          selectedItemColor: context.appPrimaryColor,
          selectedFontSize: 14,
          unselectedFontSize: 14,
          backgroundColor: context.appBgColor,
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
      onWillPop: () => _onWillPop(),
    );
  }

  Widget iconEmojiWidget(IconData iconString, Color color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
      child: Icon(iconString),
    );
  }

  Future<bool> _onWillPop() async {
    // upon mobile back button press navigate to event tab from other tabs
    if (_selectedIndex != homeScreen) {
      setState(() {
        _selectedIndex = homeScreen;
      });
      return false;
    }
    return true;
  }
}
