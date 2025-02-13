import 'package:flutter/material.dart';
import 'package:mogu_app/admin/people/people_page/widgets/nav_item.dart';

class PeoplePage extends StatelessWidget {
  const PeoplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Color(0xFFE9F8FF),
          onPressed: () {
            // 뒤로가기 동작
          },
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.68, -0.73),
              end: Alignment(-0.68, 0.73),
              colors: [Color(0xFFFFA7E1), Color(0xB29322CC)],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // 추가 동작
            },
            color: Color(0xFFFFD3F0),
          ),
        ],
      ),
      body: Center(
        child: Text('Main Content'),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              NavItem(icon: Icons.home, label: '홈', isSelected: false),
              NavItem(icon: Icons.people, label: '회원관리', isSelected: true),
              NavItem(icon: Icons.campaign, label: '민원관리', isSelected: false),
            ],
          ),
        ),
      ),
    );
  }
}