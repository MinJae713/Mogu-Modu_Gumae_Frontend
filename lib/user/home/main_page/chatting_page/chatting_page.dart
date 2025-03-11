import 'package:flutter/material.dart';
import 'package:mogu_app/user/home/main_page/chatting_page/widgets/chat_filter_button.dart';
import 'package:provider/provider.dart';

import '../../../chat/chat_room_page.dart';
import '../../notification_page/notification_page.dart';
import 'chatting_page_viewModel.dart';

class ChattingPage extends StatefulWidget {
  const ChattingPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ChattingPageState();
  }
}

class _ChattingPageState extends State<ChattingPage> {

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ChattingPageViewModel>(context);
    viewModel.initUserInfo(context);
    if (!viewModel.isInitialized) return Scaffold();
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
                  pageBuilder: (context, animation, secondaryAnimation) => NotificationPage(userInfo: viewModel.userInfo),
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
                      ChatFilterButton(
                        label: '전체',
                        getChatFilter: viewModel.getChatFilter,
                        setChatFilter: viewModel.setChatFilter
                      ),
                      // _buildChatFilterButton('전체'),
                      SizedBox(width: 8),
                      ChatFilterButton(
                        label: '판매',
                        getChatFilter: viewModel.getChatFilter,
                        setChatFilter: viewModel.setChatFilter
                      ),
                      // _buildChatFilterButton('판매'),
                      SizedBox(width: 8),
                      ChatFilterButton(
                        label: '구매',
                        getChatFilter: viewModel.getChatFilter,
                        setChatFilter: viewModel.setChatFilter
                      ),
                      // _buildChatFilterButton('구매')
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.model.chatItems.length,
                    itemBuilder: (context, index) {
                      final chat = viewModel.model.chatItems[index];
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
    );
  }
}