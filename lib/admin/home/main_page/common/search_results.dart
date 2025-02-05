import 'package:flutter/material.dart';
import 'package:mogu_app/admin/home/main_page/common/post_card.dart';

class SearchResults {
  List<Widget> build(String searchQuery) {
    // 홈 탭에서만 게시글을 표시합니다.
    List<Map<String, String>> posts = [
      {
        'profileName': '김찬',
        'distance': '1~2km',
        'description': '방금 구매한 계란 5개씩 나눠실분..',
        'price': '2000원',
        'imagePath': 'icon',
        'endDate': '12/12',
        'views': '23',
      },
      {
        'profileName': '나하리',
        'distance': '500m 미만',
        'description': '~~위치에 필터가 10개에 6000원 필요하신분 있습니다.',
        'price': '2000원',
        'imagePath': 'icon',
        'endDate': '12/14',
        'views': '30',
      },
      {
        'profileName': '모비팡',
        'distance': '500m ~1km',
        'description': '손수 만든 인증기능 판매합니다',
        'price': '2000원',
        'imagePath': 'icon',
        'endDate': '12/16',
        'views': '45',
      },
      {
        'profileName': '윰쟁이',
        'distance': '500m ~1km',
        'description': '손수 만든 프로젝트 판매 안합니다',
        'price': '-2000원',
        'imagePath': 'icon',
        'endDate': '12/29',
        'views': '27',
      },
    ];

    // 검색어가 있으면 필터링
    if (searchQuery.isNotEmpty) {
      posts = posts
          .where((post) => post['description']!.contains(searchQuery))
          .toList();
    }

    // 필터링된 게시글을 위젯으로 변환
    List<Widget> results = posts.map((post) {
      return PostCard(
        profileName: post['profileName']!,
        distance: post['distance']!,
        description: post['description']!,
        price: post['price']!,
        imagePath: post['imagePath']!,
        endDate: post['endDate']!,
        views: post['views']!,
      );
    }).toList();

    return results;
  }
}