import 'package:flutter/material.dart';

import '../../../user/home/post/post_detail_page.dart';

class PostAskReviewPage extends StatelessWidget {
  const PostAskReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Color(0xFFE9F8FF),
          onPressed: () {
            Navigator.pop(context);
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
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildRequestCard(context, '김찬', '매너인^^', 60, '1~2km', '방금 구매한 계란 5개씩 나누실 분...'),
          _buildRequestCard(context, '모땡땡', '매너인^^', 60, '1~2km', '방금 구매한 계란 5개씩 나누실 분...'),
          _buildRequestCard(context, '모땡땡', '매너인^^', 60, '1~2km', '방금 구매한 계란 5개씩 나누실 분...'),
        ],
      ),
    );
  }

  Widget _buildRequestCard(BuildContext context, String name, String status, int history, String distance, String description) {
    return Material(
      color: Colors.transparent, // 기본 배경색 투명
      borderRadius: BorderRadius.circular(10), // 오브젝트의 둥근 모서리
      child: InkWell(
        onTap: () {
          //todo:포스트 디테일에 포스트 정보 주기
          // Navigator.push(
          //   context,
          //   PageRouteBuilder(
          //     pageBuilder: (context, animation, secondaryAnimation) =>
          //         PostDetailPage(),
          //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
          //       const begin = Offset(1.0, 0.0); // 오른쪽에서 시작
          //       const end = Offset.zero;
          //       const curve = Curves.ease;
          //
          //       var tween = Tween(begin: begin, end: end)
          //           .chain(CurveTween(curve: curve));
          //
          //       return SlideTransition(
          //         position: animation.drive(tween),
          //         child: child,
          //       );
          //     },
          //   ),
          // );
        },
        borderRadius: BorderRadius.circular(10), // 물결 효과의 경계 설정
        splashColor: Colors.purple.withOpacity(0.3), // 물결 효과 색상 보라색으로 설정
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // 카드의 둥근 모서리
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.image, size: 40, color: Colors.grey),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: Text(
                        description,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          child: Icon(Icons.person),
                        ),
                        SizedBox(width: 16.0),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(status),
                        Text('거래내역 $history회'),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Material(
                        color: Color(0xFFDA70D6), // 수락 버튼의 배경색
                        borderRadius: BorderRadius.circular(8.0),
                        child: InkWell(
                          onTap: () {
                            // 수락 버튼을 눌렀을 때 실행될 동작을 정의하세요.
                          },
                          borderRadius: BorderRadius.circular(8.0),
                          splashColor: Colors.white.withOpacity(0.3), // 물결 효과 색상
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            alignment: Alignment.center,
                            child: Text(
                              '수락',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: Material(
                        color: Colors.grey, // 거절 버튼의 배경색
                        borderRadius: BorderRadius.circular(8.0),
                        child: InkWell(
                          onTap: () {
                            // 거절 버튼을 눌렀을 때 실행될 동작을 정의하세요.
                          },
                          borderRadius: BorderRadius.circular(8.0),
                          splashColor: Colors.black.withOpacity(0.3), // 물결 효과 색상
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            alignment: Alignment.center,
                            child: Text(
                              '거절',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}