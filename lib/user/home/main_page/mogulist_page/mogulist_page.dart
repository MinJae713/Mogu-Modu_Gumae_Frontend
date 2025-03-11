import 'package:flutter/material.dart';
import 'package:mogu_app/user/home/main_page/mogulist_page/mogulist_page_viewModel.dart';
import 'package:mogu_app/user/home/main_page/mogulist_page/widgets/mogu_history_card.dart';
import 'package:mogu_app/user/home/main_page/mogulist_page/widgets/my_mogu_card.dart';
import 'package:provider/provider.dart';

import '../../notification_page/notification_page.dart';

class MoguListPage extends StatefulWidget {
  const MoguListPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MoguListPageState();
  }
}

class _MoguListPageState extends State<MoguListPage> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<MoguListPageViewModel>(context, listen: false);
    viewModel.initViewModel(context);
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MoguListPageViewModel>(context);
    if (!viewModel.isInitialized)
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '모구내역',
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: tabController,
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
                Tab(text: '나의 참여'),
                Tab(text: '나의 모구'),
              ],
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
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      NotificationPage(userInfo: viewModel.userInfo),
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
        ],
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: viewModel.model.posts.length,
                  itemBuilder: (context, index) {
                    return MoguHistoryCard(post: viewModel.model.posts[index],
                        userUid: viewModel.model.userUid);
                  },
                ),
              ),
            ],
          ),
          ListView.builder(
            itemCount: viewModel.model.posts.length,
            itemBuilder: (context, index) {
              return MyMoguCard(
                post: viewModel.model.posts[index],
                userUid: viewModel.model.userUid
              );
            },
          ),
        ],
      ),
    );
  }
}