import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mogu_app/user/home/main_page/chatting_page/chatting_page.dart';
import 'package:mogu_app/user/home/main_page/home_page/home_page.dart';
import 'package:mogu_app/user/home/main_page/mogulist_page/mogulist_page.dart';

import 'my_page/my_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainPage();
  }
}

class _MainPage extends State<MainPage> {
  int selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    ChattingPage(),
    MoguListPage(),
    MyPage(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              selectedIndex == 0 ? "assets/icons/selected_home.svg" : "assets/icons/unselected_home.svg",
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              selectedIndex == 1 ? "assets/icons/selected_chat.svg" : "assets/icons/unselected_chat.svg",
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            label: '채팅',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              selectedIndex == 2 ? "assets/icons/selected_history.svg" : "assets/icons/unselected_history.svg",
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            label: '모구내역',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              selectedIndex == 3 ? "assets/icons/selected_my_page.svg" : "assets/icons/unselected_my_page.svg",
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            label: 'MY',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Color(0xFFB34FD1),
        unselectedItemColor: Color(0xFFFFBDE9),
        onTap: _onItemTapped,
      ),
    );
  }
}