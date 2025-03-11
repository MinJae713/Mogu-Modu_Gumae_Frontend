import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomePageBottomFA extends StatefulWidget {
  final int selectedIndex;
  const HomePageBottomFA({super.key, required this.selectedIndex});

  @override
  State<StatefulWidget> createState() {
    return _HomePageBottomFA();
  }
}

class _HomePageBottomFA extends State<HomePageBottomFA> {
// 안씀
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/admin/homeMainPageFA');
      case 1:
        Navigator.pushReplacementNamed(context, '/admin/memberManagementPage');
      case 2:
        Navigator.pushReplacementNamed(context, '/admin/complaintManagementPage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
      currentIndex: widget.selectedIndex,
      selectedItemColor: Color(0xFFB34FD1),
      unselectedItemColor: Color(0xFFFFBDE9),
      onTap: _onItemTapped,
    );
  }
}