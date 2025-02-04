import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomePageBottom extends StatefulWidget {
  final int selectedIndex;
  const HomePageBottom({super.key, required this.selectedIndex});

  @override
  State<StatefulWidget> createState() {
    return _HomePageBottomState();
  }

}

class _HomePageBottomState extends State<HomePageBottom> {
  void _onItemTapped(int index) async {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/user/homeMainPage');
      case 1:
        Navigator.pushReplacementNamed(context, '/user/chattingPage');
      case 2:
        Navigator.pushReplacementNamed(context, '/user/moguListPage');
      case 3:
        Navigator.pushReplacementNamed(context, '/user/myPage');
    }
    if (index == 0) {
      // 홈 화면이 선택된 경우에만 포스트 목록을 새로고침
      // 옮기기 일단 보류
      // await _findAllPost(context);
    }
    // setState(() {
    //   selectedIndex = index;
    // });
  }
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            widget.selectedIndex == 0 ? "assets/icons/selected_home.svg" : "assets/icons/unselected_home.svg",
            width: 24,
            height: 24,
            fit: BoxFit.contain,
          ),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            widget.selectedIndex == 1 ? "assets/icons/selected_chat.svg" : "assets/icons/unselected_chat.svg",
            width: 24,
            height: 24,
            fit: BoxFit.contain,
          ),
          label: '채팅',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            widget.selectedIndex == 2 ? "assets/icons/selected_history.svg" : "assets/icons/unselected_history.svg",
            width: 24,
            height: 24,
            fit: BoxFit.contain,
          ),
          label: '모구내역',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            widget.selectedIndex == 3 ? "assets/icons/selected_my_page.svg" : "assets/icons/unselected_my_page.svg",
            width: 24,
            height: 24,
            fit: BoxFit.contain,
          ),
          label: 'MY',
        ),
      ],
      currentIndex: widget.selectedIndex,
      selectedItemColor: Color(0xFFB34FD1),
      unselectedItemColor: Color(0xFFFFBDE9),
      onTap: _onItemTapped,
    );
  }
}