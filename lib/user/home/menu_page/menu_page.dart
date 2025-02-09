import 'package:flutter/material.dart';
import 'package:mogu_app/user/home/menu_page/widgets/category_item.dart';
import 'package:mogu_app/user/home/menu_page/widgets/support_item.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // 뒤로 가기 아이콘으로 변경
          color: Color(0xFFFFE9F8),
          onPressed: () {
            Navigator.pop(context); // 뒤로 가기 동작을 정의
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '카테고리',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 4, // 한 줄에 4개의 아이콘
              shrinkWrap: true,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: const [
                CategoryItem(iconData: Icons.fastfood, label: '식료품'),
                CategoryItem(iconData: Icons.local_drink, label: '일회용품'),
                CategoryItem(iconData: Icons.cleaning_services, label: '청소용품'),
                CategoryItem(iconData: Icons.brush, label: '뷰티/미용'),
                CategoryItem(iconData: Icons.videogame_asset, label: '취미/게임'),
                CategoryItem(iconData: Icons.kitchen, label: '생활/주방'),
                CategoryItem(iconData: Icons.baby_changing_station, label: '육아용품'),
                CategoryItem(iconData: Icons.card_giftcard, label: '기타'),
                CategoryItem(iconData: Icons.card_giftcard, label: '무료 나눔'),
              ],
            ),
            SizedBox(height: 16), // 고객센터와 무료나눔 사이의 간격 조정
            Text(
              '고객센터',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: const [
                SupportItem(index: 0, iconData: Icons.campaign, label: '공지사항'),
                SizedBox(width: 16),
                SupportItem(index: 1, iconData: Icons.help, label: '문의'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


