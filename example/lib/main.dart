import 'package:flutter/material.dart';
import 'package:glass_pill_nav/glass_pill_nav.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glass Pill Nav Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

enum NavMode { standard, expandable, morphing }

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  NavMode _navMode = NavMode.standard;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<Widget> get _screens => [
        _buildScrollableScreen(
          'Home Screen',
          Icons.home_rounded,
          Colors.blueAccent,
        ),
        _buildScrollableScreen(
          'Social Screen',
          Icons.people_outline_rounded,
          Colors.blueAccent,
        ),
        _buildScrollableScreen(
          'Chat Screen',
          Icons.chat_bubble_outline_rounded,
          Colors.blueAccent,
        ),
        _buildScrollableScreen(
          'Profile Screen',
          Icons.person_outline_rounded,
          Colors.blueAccent,
        ),
      ];

  Widget _buildScrollableScreen(String title, IconData icon, Color color) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(top: 120, bottom: 120),
      itemCount: 50,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              Icon(icon, size: 100, color: color),
              const SizedBox(height: 16),
              Text(title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
            ],
          );
        }
        return ListTile(
          title: Text('Scrollable Item $index'),
          subtitle: const Text('Scroll down to see the nav bar collapse'),
          leading: const CircleAvatar(child: Icon(Icons.star_outline)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      extendBody: true,
      body: Stack(
        children: [
          // Background decoration to show off glass effect
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withValues(alpha: 0.2),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purple.withValues(alpha: 0.2),
              ),
            ),
          ),
          _screens[_currentIndex],

          Positioned(
            top: 60,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white24),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<NavMode>(
                  value: _navMode,
                  dropdownColor: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(12),
                  onChanged: (v) => setState(() => _navMode = v!),
                  items: NavMode.values.map((mode) {
                    return DropdownMenuItem(
                      value: mode,
                      child: Text(
                        mode.name.toUpperCase(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    switch (_navMode) {
      case NavMode.expandable:
        return GlassPillNav.expandable(
          currentIndex: _currentIndex,
          scrollController: _scrollController,
          style: GlassPillNavStyle.nebula().copyWith(
            animationDuration: const Duration(milliseconds: 400),
            enableLiquidEffect: false,
          ),
          onTabTap: (index) => setState(() => _currentIndex = index),
          centerAction: const GlassPillAction(),
          expandableItems: _expandableItems,
          expandedCentralAction: const Icon(
            Icons.close_rounded,
            color: Colors.white,
            size: 28,
          ),
          items: _navItems,
        );
      case NavMode.morphing:
        return GlassPillNav.morphing(
          currentIndex: _currentIndex,
          scrollController: _scrollController,
          style: GlassPillNavStyle.nebula().copyWith(
            animationDuration: const Duration(milliseconds: 400),
            enableLiquidEffect: false,
          ),
          onTabTap: (index) => setState(() => _currentIndex = index),
          centerAction:
              const Icon(Icons.grid_view_rounded, color: Colors.white),
          items: _navItems,
        );
      case NavMode.standard:
        return GlassPillNav(
          currentIndex: _currentIndex,
          scrollController: _scrollController,
          style: GlassPillNavStyle.nebula().copyWith(
            animationDuration: const Duration(milliseconds: 400),
            enableLiquidEffect: false,
          ),
          onTabTap: (index) => setState(() => _currentIndex = index),
          centerAction: const GlassPillAction(),
          onCenterActionTap: () =>
              _showSnackBar(context, 'Center Action tapped'),
          items: _navItems,
        );
    }
  }

  List<GlassPillNavItem> get _navItems => const [
        GlassPillNavItem(icon: Icons.home_rounded, label: 'Home'),
        GlassPillNavItem(icon: Icons.people_outline_rounded),
        GlassPillNavItem(icon: Icons.chat_bubble_outline_rounded),
        GlassPillNavItem(icon: Icons.person_outline_rounded, label: 'Profile'),
      ];

  List<GlassPillNavItem> get _expandableItems => [
        GlassPillNavItem(
          icon: Icons.layers_outlined,
          label: 'Views',
          onTap: () => _showSnackBar(context, 'Views tapped'),
        ),
        GlassPillNavItem(
          icon: Icons.settings_outlined,
          label: 'Settings',
          onTap: () => _showSnackBar(context, 'Settings tapped'),
        ),
        GlassPillNavItem(
          icon: Icons.add_to_home_screen_outlined,
          label: 'Add Device',
          onTap: () => _showSnackBar(context, 'Add Device tapped'),
        ),
        GlassPillNavItem(
          icon: Icons.qr_code_scanner_outlined,
          label: 'Scan',
          onTap: () => _showSnackBar(context, 'Scan tapped'),
        ),
      ];

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
