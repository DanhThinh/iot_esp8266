import 'package:flutter/material.dart';
import 'package:iot_esp8266/main.dart';
import 'package:iot_esp8266/screen/action/action_screen.dart';
import 'package:iot_esp8266/screen/notification/notification.dart';

class HomeScreen extends StatefulWidget {
  static String id = "home_screen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _listScreen = const [
      ActionScreen(),
      NotificationScreen(),
    ];
    int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: navigatorKey,
      body: SafeArea(child: _listScreen[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black38,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        selectedFontSize: 10,
        iconSize: 16,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.attractions), label: "Action"),
          BottomNavigationBarItem(icon: Icon(Icons.notification_add), label: "Notifications"),
        ],
      ),
    );
  }
}
