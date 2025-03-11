import 'package:flutter/material.dart';
import 'package:mogu_app/user/home/main_page/my_page/my_page_viewModel.dart';
import 'package:provider/provider.dart';

import '../../../myPage/account_management_page/account_management_page.dart';
import '../../../myPage/setting_page/setting_page.dart';
import '../../../myPage/update_profile_page/update_profile_page.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyPageState();
  }
}

class _MyPageState extends State<MyPage> {

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<MyPageViewModel>(context, listen: false);
    viewModel.initViewModel(context);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MyPageViewModel>(context);
    if (!viewModel.isInitialized) return const Scaffold();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '마이페이지',
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
            icon: Icon(Icons.settings),
            color: Color(0xFFFFD3F0),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text('계정관리'),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                  AccountManagementPage(userInfo: viewModel.userInfo),
                              ),
                            ).then((_) => viewModel.getUpdatedUserInfo(context));
                          },
                        ),
                        ListTile(
                          title: Text('환경설정'),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SettingPage(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: Text('취소'),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded( // widgetOptions[3]
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        color: Color(0xFFB34FD1),
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: viewModel.model.profileImage.isNotEmpty
                            ? NetworkImage(viewModel.model.profileImage)
                            : null,
                        child: viewModel.model.profileImage.isEmpty
                            ? Icon(Icons.person, size: 50, color: Colors.white)
                            : null,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          'Lv.${viewModel.model.level}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB34FD1),
                          ),
                        ),
                        SizedBox(width: 15), // 간격을 자연스럽게 조절
                        Text(
                          viewModel.model.nickname,
                          style: TextStyle(
                            fontSize: 24, // 닉네임을 강조하기 위해 더 크게 설정
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final updatedUserInfo = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateProfilePage(
                              userId: viewModel.model.userId,
                              nickname: viewModel.model.nickname,
                              profileImage: viewModel.model.profileImage,
                              longitude: viewModel.model.longitude,
                              latitude: viewModel.model.latitude,
                              token: viewModel.model.token,
                            ),
                          ),
                        );

                        if (updatedUserInfo != null) {
                          await viewModel.getUpdatedUserInfo(context); // 프로필 수정 후 사용자 정보를 다시 가져옵니다.
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.grey.shade200,
                      ),
                      child: Text('프로필 수정하기'),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Column(
                          children: [
                            Text('현재 거래 횟수', style: TextStyle(fontSize: 16, color: Color(0xFFB34FD1))),
                            SizedBox(height: 10),
                            Text(
                              '${viewModel.model.currentPurchaseCount} / ${viewModel.model.needPurchaseCount}',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '다음 레벨까지 ${(viewModel.model.needPurchaseCount -
                                  viewModel.model.currentPurchaseCount).abs()}번 남음',
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text('매너도', style: TextStyle(fontSize: 16, color: Color(0xFFB34FD1))),
                            SizedBox(height: 10),
                            Text(
                              viewModel.model.manner,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ListTile(
                      leading: Icon(Icons.location_on, color: Color(0xFFB34FD1)),
                      title: Text('나의 위치', style: TextStyle(color: Color(0xFFB34FD1))),
                      subtitle: Text(viewModel.model.address),
                    ),
                    ListTile(
                      leading: Icon(Icons.calendar_today, color: Color(0xFFB34FD1)),
                      title: Text('가입일', style: TextStyle(color: Color(0xFFB34FD1))),
                      subtitle: Text('${viewModel.model.registerDate.year}/${viewModel.model.registerDate.month}/${viewModel.model.registerDate.day}',
                          style: TextStyle(fontSize: 18)),
                    ),
                    ListTile(
                      leading: Icon(Icons.money, color: Color(0xFFB34FD1)),
                      title: Text('모구로 아낌비용', style: TextStyle(color: Color(0xFFB34FD1))),
                      subtitle: Text(
                        '${viewModel.formatCurrency(viewModel.model.savingCost)}원',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}