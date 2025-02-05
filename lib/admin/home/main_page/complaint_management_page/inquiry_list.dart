import 'package:flutter/material.dart';

import '../../../complaint/complaint_detail_page.dart';

class InquiryList {
  List<Widget> build(String searchQuery) {
    // 문의 탭에서 표시할 문의 목록을 정의합니다.
    List<Map<String, String>> inquiries = [
      {
        'profileName': '김찬',
        'inquiry': '이상한 남자가 말 걸어요',
        'imagePath': 'icon',
        'status': '대기중',
      },
      {
        'profileName': '나하리',
        'inquiry': '개명했습니다',
        'imagePath': '',
        'status': '완료',
      },
      {
        'profileName': '모비팡',
        'inquiry': '모비팡모비팡모비팡모비팡모비팡모비팡',
        'imagePath': '',
        'status': '완료',
      },
      {
        'profileName': '윰쟁이소금쟁이',
        'inquiry': '한치두치세치네치',
        'imagePath': '',
        'status': '대기중',
      },
    ];

    // 검색어가 있으면 필터링
    if (searchQuery.isNotEmpty) {
      inquiries = inquiries
          .where((inquiry) => inquiry['inquiry']!.contains(searchQuery))
          .toList();
    }

    // 필터링된 문의 목록을 위젯으로 변환
    List<Widget> results = inquiries.map((inquiry) {
      return InquiryCard(
        profileName: inquiry['profileName']!,
        inquiry: inquiry['inquiry']!,
        imagePath: inquiry['imagePath']!,
        status: inquiry['status']!,
      );
    }).toList();

    return results;
  }
}

class InquiryCard extends StatefulWidget {
  final String profileName;
  final String inquiry;
  final String imagePath;
  final String status;
  const InquiryCard({
    super.key,
    required this.profileName,
    required this.inquiry,
    required this.imagePath,
    required this.status
  });

  @override
  State<StatefulWidget> createState() {
    return _InquiryCard();
  }
}

class _InquiryCard extends State<InquiryCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('${widget.profileName} 문의 클릭됨');
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                ComplaintDetailPage(),
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
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    child: Icon(Icons.person), // 프로필 이미지를 여기에 추가할 수 있음
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.profileName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text(widget.inquiry),
              SizedBox(height: 12),
              if (widget.imagePath.isNotEmpty)
                Container(
                  width: 100,
                  height: 60,
                  color: Colors.pink[100],
                  child: Center(
                    child: Text('문의 사진', style: TextStyle(color: Colors.white)),
                  ),
                ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '처리상태 : ${widget.status}',
                    style: TextStyle(
                      color: widget.status == '대기중' ? Colors.purple : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
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