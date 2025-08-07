// lib/screens/main_tabs_screen.dart - Full-fledged app with 5 bottom navigation tabs

import 'package:flutter/material.dart';
import 'package:meelo/screens/home/home_screen.dart';
import 'package:meelo/screens/memories/memories_screen.dart';
import 'package:meelo/screens/questionnaire/questionnaire_screen.dart';
import 'package:meelo/screens/figures/figures_screen.dart';
import 'package:meelo/screens/profile/profile_screen.dart';
import 'package:meelo/l10n/app_localizations.dart';

class MainTabsScreen extends StatefulWidget {
  const MainTabsScreen({super.key});

  @override
  State<MainTabsScreen> createState() => _MainTabsScreenState();
}

class _MainTabsScreenState extends State<MainTabsScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  final List<String> _tabTitles = [
    'Home',
    'Memories',
    'Questionnaire', 
    'Figures',
    'Profile',
  ];

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(onTabChange: _changeTab),
      const MemoriesScreen(),
      const QuestionnaireScreen(),
      const FiguresScreen(),
      const ProfileScreen(),
    ];
  }

  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF483FA9),
          unselectedItemColor: Colors.grey.shade600,
          selectedFontSize: 12,
          unselectedFontSize: 10,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: _buildNavIcon(Icons.home_outlined, Icons.home, 0),
              label: _tabTitles[0],
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon(Icons.auto_stories_outlined, Icons.auto_stories, 1),
              label: _tabTitles[1],
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon(Icons.quiz_outlined, Icons.quiz, 2),
              label: _tabTitles[2],
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon(Icons.analytics_outlined, Icons.analytics, 3),
              label: _tabTitles[3],
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon(Icons.person_outline, Icons.person, 4),
              label: _tabTitles[4],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData outlinedIcon, IconData filledIcon, int index) {
    final bool isSelected = _currentIndex == index;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected 
            ? const Color(0xFF483FA9).withOpacity(0.1) 
            : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        isSelected ? filledIcon : outlinedIcon,
        size: 24,
        color: isSelected 
            ? const Color(0xFF483FA9) 
            : Colors.grey.shade600,
      ),
    );
  }
}