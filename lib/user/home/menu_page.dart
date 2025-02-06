import 'package:flutter/material.dart';

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
              children: [
                _buildCategoryItem(Icons.fastfood, '식료품', context),
                _buildCategoryItem(Icons.local_drink, '일회용품', context),
                _buildCategoryItem(Icons.cleaning_services, '청소용품', context),
                _buildCategoryItem(Icons.brush, '뷰티/미용', context),
                _buildCategoryItem(Icons.videogame_asset, '취미/게임', context),
                _buildCategoryItem(Icons.kitchen, '생활/주방', context),
                _buildCategoryItem(Icons.baby_changing_station, '육아용품', context),
                _buildCategoryItem(Icons.card_giftcard, '기타', context),
                _buildCategoryItem(Icons.card_giftcard, '무료 나눔', context),
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
              children: [
                _buildSupportItem(0,Icons.campaign, '공지사항'),
                SizedBox(width: 16),
                _buildSupportItem(1, Icons.help, '문의'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(IconData iconData,
      String label, BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: Ink(
            decoration: BoxDecoration(
              color: Color(0xFFEDEDED),
              shape: BoxShape.circle,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(32),
              splashColor: Colors.purple.withOpacity(0.2),
              onTap: () {
                Navigator.pop(context, label);
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(
                  iconData,
                  color: Color(0xFFB34FD1),
                  size: 28,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSupportItem(int index, IconData iconData, String label) {
    return InkWell(
      onTap: () {
        // 여기에 아이콘 클릭 시 동작할 코드 작성
        print('$label 클릭됨');
      },
      borderRadius: BorderRadius.circular(32), // 물결 효과가 텍스트를 감싸도록 경계 설정
      splashColor: Colors.purple.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              iconData,
              color: index == 0 ? Colors.red : Colors.blue, // 첫 번째는 빨간색, 두 번째는 파란색
            ),
            SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}


