
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mogu_app/admin/home/main_page/complaint_management_page/complaint_management_page.dart';
import 'package:mogu_app/admin/home/main_page/home_page/home_page_FA.dart';
import 'package:mogu_app/admin/home/main_page/member_management_page/member_management_page.dart';

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AdminMainPage();
  }
}

class _AdminMainPage extends State<AdminMainPage> {
  int selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    HomeMainPageFA(),
    MemberManagementPage(),
    ComplaintManagementPage()
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
        type: BottomNavigationBarType.shifting, // 애니메이션 효과를 위한 설정
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/unselected_home.svg",
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/selected_home.svg",
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/unselected_member_management.svg",
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/selected_member_management.svg",
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            label: '회원관리',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/unselected_complaint_management.svg",
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/selected_complaint_management.svg",
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            label: '민원관리',
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