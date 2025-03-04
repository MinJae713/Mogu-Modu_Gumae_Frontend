import 'package:flutter/material.dart';
import 'package:mogu_app/user/home/notification_page/notification_page_viewModel.dart';

import 'package:mogu_app/user/home/post/post_ask_review_page/post_ask_review_page.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  final Map<String, dynamic> userInfo;

  const NotificationPage({super.key, required this.userInfo});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<NotificationPageViewModel>(context, listen: false);
    viewModel.initViewModel(context, widget.userInfo);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<NotificationPageViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Color(0xFFFFD3F0),
          onPressed: () {
            Navigator.pop(context); // 뒤로 가기 동작을 정의
          },
        ),
        title: Text(
          '알림',
          style: TextStyle(
            color: Color(0xFFFFD3F0),
            fontSize: 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Color(0xFFB34FD1),
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color(0xFFB34FD1),
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: Color(0xFFB34FD1), width: 3),
                insets: EdgeInsets.symmetric(horizontal: 0.0),
              ),
              tabs: const [
                Tab(text: '참여알림'),
                Tab(text: '새소식'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView.separated(
            itemCount: viewModel.notifications.length,
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey.shade300,
              thickness: 1,
              height: 1,
            ),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          PostAskReviewPage(),
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
                child: ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey.shade300,
                    child: Icon(Icons.image, color: Colors.white),
                  ),
                  title: Text(viewModel.notifications[index]['title']!),
                  subtitle: Text(viewModel.notifications[index]['time']!),
                  trailing: Icon(Icons.chevron_right),
                ),
              );
            },
          ),
          Center(
            child: Text(
              '새소식이 없습니다',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
