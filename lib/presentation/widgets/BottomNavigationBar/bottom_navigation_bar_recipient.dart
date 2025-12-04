import 'package:admin_giver_receiver/logic/services/colors_app.dart';
import 'package:admin_giver_receiver/presentation/screens/BottomNavigationBar/chats_screen.dart';
import 'package:admin_giver_receiver/presentation/screens/BottomNavigationBar/items_screen.dart';
import 'package:admin_giver_receiver/presentation/screens/BottomNavigationBar/admin_requests_screen.dart';
import 'package:admin_giver_receiver/presentation/screens/BottomNavigationBar/settings_screen/settings_screen..dart';
import 'package:flutter/material.dart';

import 'package:motion_tab_bar/MotionTabBar.dart';

class MainBottomNavAdmin extends StatefulWidget {
  const MainBottomNavAdmin({super.key});

  @override
  State<MainBottomNavAdmin> createState() => _MainBottomNavDonorState();
}

class _MainBottomNavDonorState extends State<MainBottomNavAdmin>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;

  late final List<Widget> _pages = [
    ItemsScreen(),
    AdminRequestsScreen(),
    ChatsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],

      bottomNavigationBar: MotionTabBar(
        initialSelectedTab: 'Items',
        labels: const ["Items", "Requests", "Chats", "Settings"],
        icons: const [
          Icons.description_outlined,
          Icons.volunteer_activism_outlined,
          Icons.chat_outlined,
          Icons.settings_outlined,
        ],
        tabIconColor: Colors.grey,
        tabIconSelectedColor: Colors.white,
        tabSelectedColor: AppColors().primaryColor,
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        onTabItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
