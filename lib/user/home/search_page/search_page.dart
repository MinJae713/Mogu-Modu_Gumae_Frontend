import 'package:flutter/material.dart';
import 'package:mogu_app/user/home/search_page/widgets/product_card.dart';
import 'package:mogu_app/user/home/search_page/widgets/search_chip.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // 최근 검색어 리스트
  List<String> recentSearches = ['최근 검색 1', '최근 검색 2', '최근 검색 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Color(0xFFFFD3F0),
          onPressed: () {
            Navigator.pop(context); // 뒤로 가기 동작을 정의
          },
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.68, -0.73),
              end: Alignment(-0.68, 0.73),
              colors: const [Color(0xFFFFA7E1), Color(0xB29322CC)],
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8), // 패딩 조정
          child: Container(
            height: 35, // 핑크색 부분의 높이 조정
            decoration: BoxDecoration(
              color: Color(0xFFFFBDE9),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20), // 좌우 패딩
                      isDense: true, // 밀집된 형태로 만들기
                    ),
                  ),
                ),
                Padding(
                  // 여기에 패딩 추가
                  padding: const EdgeInsets.only(right: 8.0), // 오른쪽 패딩 조정
                  child: IconButton(
                    icon: Icon(Icons.search),
                    color: Color(0xFFFFD3F0),
                    padding: EdgeInsets.zero, // 기본 패딩 제거
                    constraints: BoxConstraints(), // 아이콘의 크기 조정
                    onPressed: () {
                      // 이 버튼을 눌렀을 때 실행될 동작을 정의하세요.
                      print('Search button pressed');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '최근 검색어',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: recentSearches.map((search) {
                return Chip(
                  label: Text(search),
                  onDeleted: () {
                    setState(() {
                      recentSearches.remove(search); // 삭제
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Text(
              '실시간 인기 검색어',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: const [
                SearchChip(label: '계란'),
                SearchChip(label: '물티슈'),
                SearchChip(label: '돚대기 시장'),
              ],
            ),
            SizedBox(height: 16),
            RichText(
              text: TextSpan(
                children: const [
                  TextSpan(
                    text: '최근에 ',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  TextSpan(
                    text: '물티슈',
                    style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  TextSpan(
                    text: '를 검색했어요! 나를 위한 추천 구매',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            ProductCard(
              userName: '김찬',
              distance: '1~2km',
              title: '방금 구매한 물티슈 1개씩 나눌 분...',
              price: '2000원',
              discount: '10% 더 싸요',
              moguPeople: '모구 12/32',
              likes: '7',
              views: '23'
            ),
            ProductCard(
              userName: '나허리',
              distance: '500m 미만',
              title: '~~위치에 물티슈 10개에 6000원 할인하고 있습니다!',
              price: '2000원',
              discount: '10% 더 싸요',
              moguPeople: '모구 12/32',
              likes: '7',
              views: '23'
            ),
          ],
        ),
      ),
    );
  }
}

