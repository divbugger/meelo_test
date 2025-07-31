// lib/screens/main_tabs_screen.dart - Updated with Idem logo

import 'package:flutter/material.dart';
import 'package:meelo/screens/story/story_screen.dart';
import 'package:meelo/widgets/language_selector.dart';
import 'package:meelo/widgets/idem_logo.dart';

class MainTabsScreen extends StatefulWidget {
  const MainTabsScreen({super.key});

  @override
  State<MainTabsScreen> createState() => _MainTabsScreenState();
}

class _MainTabsScreenState extends State<MainTabsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // Use the Idem logo instead of text
        title: const IdemLogo(
          fontSize: 28,
          fontWeight: FontWeight.w700,
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        shadowColor: Colors.black12,
        centerTitle: false, // Align logo to the left
        actions: [const LanguageSelector()],
      ),
      body: Container(
        color: Colors.white,
        child: const StoryScreen(),
      ),
    );
  }
}