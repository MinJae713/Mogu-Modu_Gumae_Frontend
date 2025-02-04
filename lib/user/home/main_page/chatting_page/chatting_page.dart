import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../chat/chat_room_page.dart';
import '../../notification_page.dart';
import '../bottom/home_page_bottom.dart';

class ChattingPage extends StatefulWidget {
  const ChattingPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ChattingPageState();
  }
}

class _ChattingPageState extends State<ChattingPage> {
  late Map<String, dynamic> userInfo;
  final List<Map<String, String>> chatItems = List.generate(
    6,
        (index) => {
      'title': '그럼 명지대학교에서 봐윰',
      'time': '오후 9시 13분',
    },
  );
  String _selectedChatFilter = '전체';

  Future<void> initUserInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? userJson = pref.getString('userJson');
    userJson == null ? showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('로그인 정보가 전달되지 않았습니다.'),
        );
      }
    ) :
    setState(() {
      userInfo = jsonDecode(userJson);
    });
  }

  Widget _buildChatFilterButton(String label) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          _selectedChatFilter = label;
        });
      },
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        backgroundColor: _selectedChatFilter == label ? Colors.grey.shade200 : Colors.white,
        side: BorderSide(
          color: _selectedChatFilter == label ? Colors.black : Colors.grey,
        ),
      ),
      child: Text(label, style: TextStyle(fontSize: 14)),
    );
  }

  @override
  Widget build(BuildContext context) {
    initUserInfo();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '채팅목록',
          style: TextStyle(
            color: Color(0xFFFFD3F0),
            fontWeight: FontWeight.bold,
          ),
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
            icon: Icon(Icons.notifications),
            color: Color(0xFFFFD3F0),
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => NotificationPage(userInfo: userInfo),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.ease;
                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
              );
            },
          )
        ]
      ),
      body: Column(
        children: <Widget>[
          Expanded( // widgetOptions[1]
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildChatFilterButton('전체'),
                      SizedBox(width: 8),
                      _buildChatFilterButton('판매'),
                      SizedBox(width: 8),
                      _buildChatFilterButton('구매'),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: chatItems.length,
                    itemBuilder: (context, index) {
                      final chat = chatItems[index];
                      return ListTile(
                        leading: Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey,
                        ),
                        title: Text(chat['title']!),
                        subtitle: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: const [
                                CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Colors.grey,
                                  child: Icon(
                                    Icons.person,
                                    size: 10,
                                    color: Colors.white,
                                  ),
                                ),
                                Positioned(
                                  left: 8,
                                  child: CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Colors.grey,
                                    child: Icon(
                                      Icons.person,
                                      size: 10,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Text(chat['time']!),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => ChatRoomPage(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                const begin = Offset(1.0, 0.0);
                                const end = Offset.zero;
                                const curve = Curves.ease;
                                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: HomePageBottom(selectedIndex: 1),
    );
  }
}