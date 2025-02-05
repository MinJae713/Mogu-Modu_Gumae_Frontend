import 'package:flutter/material.dart';

import '../../../complaint/notice_detail_page.dart';

class NoticeList {
  List<Widget> build(String searchQuery) {
    // 공지 탭에서 표시할 공지 목록을 정의합니다.
    List<Map<String, String>> notices = [
      {
        'date': '2024/07/20',
        'title': '2024년 7월 앱 기능 업데이트 소식 안내',
        'description': '2024년 7월 업데이트되는 기능입니다.',
        'likes': '700',
        'views': '2300',
      },
      {
        'date': '2024/07/20',
        'title': '2024년 7월 앱 기능 업데이트 소식 안내',
        'description': '2024년 7월 업데이트되는 기능입니다.',
        'likes': '700',
        'views': '2300',
      },
      {
        'date': '2024/07/20',
        'title': '2024년 7월 앱 기능 업데이트 소식 안내',
        'description': '2024년 7월 업데이트되는 기능입니다.',
        'likes': '700',
        'views': '2300',
      },
      {
        'date': '1999/07/13',
        'title': '1999년 7월 유민재 탄생 안내',
        'description': '업데이트는 되지 않습니다',
        'likes': '650',
        'views': '2100',
      },
    ];

    // 검색어가 있으면 필터링
    if (searchQuery.isNotEmpty) {
      notices = notices
          .where((notice) => notice['title']!.contains(searchQuery))
          .toList();
    }

    // 필터링된 공지 목록을 위젯으로 변환
    List<Widget> results = notices.map((notice) {
      return NoticeCard(
        date: notice['date']!,
        title: notice['title']!,
        description: notice['description']!,
        likes: notice['likes']!,
        views: notice['views']!,
      );
    }).toList();

    return results;
  }
}

class NoticeCard extends StatefulWidget {
  final String date;
  final String title;
  final String description;
  final String likes;
  final String views;
  const NoticeCard({
    super.key,
    required this.date,
    required this.title,
    required this.description,
    required this.likes,
    required this.views
  });

  @override
  State<StatefulWidget> createState() {
    return _NoticeCard();
  }
}

class _NoticeCard extends State<NoticeCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('${widget.title} 공지 클릭됨');
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                NoticeDetailPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0); // 오른쪽에서 시작
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween = Tween(begin: begin, end: end)
                  .chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      },
      splashColor: Colors.purple.withOpacity(0.3), // 물결 효과 색상
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.date,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 4),
              Text(
                widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.purple,
                ),
              ),
              SizedBox(height: 4),
              Text(
                widget.description,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.thumb_up, size: 16, color: Colors.purple),
                  SizedBox(width: 4),
                  Text(
                    widget.likes,
                    style: TextStyle(color: Colors.purple, fontSize: 12),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.remove_red_eye, size: 16, color: Colors.purple),
                  SizedBox(width: 4),
                  Text(
                    widget.views,
                    style: TextStyle(color: Colors.purple, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}