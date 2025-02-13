import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chat_room_page_viewModel.dart';

class ChatRoomPage extends StatelessWidget {
  const ChatRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ChatRoomPageViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Color(0xFFE9F8FF),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: const [
            CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white), // 임시 아이콘
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                '방금 구매한 계란 5개씩 나누실 분...',
                style: TextStyle(color: Color(0xFFE9F8FF)),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
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
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              viewModel.showMoreOptions(context);
            },
            color: Color(0xFFFFD3F0),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 채팅방 제목과 관련 정보 표시
            Row(
              children: const [
                Icon(Icons.circle, color: Colors.purple, size: 12), // 장소 아이콘
                SizedBox(width: 4),
                Text("명지사거리 우리은행 앞", style: TextStyle(fontSize: 12)),
                SizedBox(width: 16),
                Icon(Icons.calendar_today, color: Colors.purple, size: 12), // 일정 아이콘
                SizedBox(width: 4),
                Text("2024년 5월 20일 금요일 12시", style: TextStyle(fontSize: 12)),
              ],
            ),
            Divider(color: Colors.grey, thickness: 1, height: 32),
            Expanded(
              child: ListView(
                children: [
                  // 첫 번째 채팅 메시지 (왼쪽)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        "그럼 명지대학교 정문에서 뵙겠습니다.",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("오후 9시 13분", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ),
                  SizedBox(height: 16),
                  // 두 번째 채팅 메시지 (오른쪽)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.pink.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            "그럼 명지대학교 정문에서 뵙겠습니다. 람쥐 다람쥐다 람쥐",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.grey, // Placeholder for profile image
                              child: Icon(Icons.person, size: 10, color: Colors.white),
                            ),
                            SizedBox(width: 4),
                            Text("오후 9시 13분", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: const [
                      Color(0xFFFFBDE9),
                      Color(0xFFFFD3F0),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  style: TextStyle(fontSize: 14), // 텍스트 필드의 텍스트 크기 조정
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // 위아래 패딩을 줄임
                  ),
                ),
              ),
            ),
            SizedBox(width: 8), // 입력창과 버튼 사이의 간격
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(30), // 동그란 물결 효과를 위해 설정
                onTap: () {
                  // 전송 버튼 클릭 시 동작을 정의
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.send, color: Color(0xFFFFD3F0)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}