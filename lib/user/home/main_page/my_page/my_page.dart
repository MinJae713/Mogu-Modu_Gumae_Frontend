import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mogu_app/user/home/main_page/common/common_methods.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../service/location_service.dart';
import '../../../myPage/account_management_page.dart';
import '../../../myPage/setting_page.dart';
import '../../../myPage/update_profile_page.dart';
import '../bottom/home_page_bottom.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyPageState();
  }
}

class _MyPageState extends State<MyPage> {
  late Map<String, dynamic> userInfo;
  late String userId;
  late String name;
  late String nickname;
  late String phone;
  late int level;
  late String manner;
  late double longitude;
  late double latitude;
  late int distanceMeters;
  late DateTime registerDate;
  late String profileImage;
  late String address = "Loading location...";
  late String token;

  int currentPurchaseCount = 0;
  int needPurchaseCount = 0;
  int savingCost = 0;

  @override
  void initState() {
    super.initState();
    _getUserInfo().then((value) {
      _initializeUserInfo();
      _getAddress();
      findUserLevel(context);
      findUserSavingCost(context);
    });
  }

  Future<void> _getUserInfo() async {
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

  void _initializeUserInfo() {
    userId = userInfo['userId'] ?? '';
    token = userInfo['token'] ?? '';
    name = userInfo['name'] ?? '';
    nickname = userInfo['nickname'] ?? '';
    phone = userInfo['phone'] ?? '';
    level = userInfo['level'] ?? 0;
    manner = userInfo['manner'] ?? '';
    longitude = userInfo['longitude']?.toDouble() ?? 0.0;
    latitude = userInfo['latitude']?.toDouble() ?? 0.0;
    distanceMeters = userInfo['distanceMeters'] ?? 0;
    registerDate = DateTime.parse(userInfo['registerDate'] ?? DateTime.now().toIso8601String());
    profileImage = userInfo['profileImage'] ?? '';
  }

  Future<void> _getUpdatedUserInfo() async {
    final updatedUserInfo = await fetchUpdatedUserInfo(userId, token);
    if (updatedUserInfo != null) {
      setState(() {
        nickname = updatedUserInfo['nickname'] ?? nickname;
        profileImage = updatedUserInfo['profileImage'] ?? profileImage;
        longitude = updatedUserInfo['longitude']?.toDouble() ?? longitude;
        latitude = updatedUserInfo['latitude']?.toDouble() ?? latitude;
      });
      await _getAddress();
    } else {
      CommonMethods.showErrorDialog(context, '오류', '사용자 정보를 불러올 수 없습니다.');
    }
  }

  Future<Map<String, dynamic>?> fetchUpdatedUserInfo(String userId, String token) async {
    String url = 'http://${dotenv.env['SERVER_IP']}:${dotenv.env['SERVER_PORT']}/user/my';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        CommonMethods.showErrorDialog(context, '오류', '인증 오류: 로그인 정보가 유효하지 않습니다.');
        return null;
      } else {
        CommonMethods.showErrorDialog(context, '오류', '사용자 정보를 불러올 수 없습니다.');
        return null;
      }
    } catch (e) {
      CommonMethods.showErrorDialog(context, '오류', '서버와의 연결 오류가 발생했습니다: ${e.toString()}');
      return null;
    }
  }

  Future<void> _getAddress() async {
    try {
      String fetchedAddress = await LocationService().getAddressFromCoordinates(latitude, longitude);
      setState(() {
        address = fetchedAddress;
      });
    } catch (e) {
      setState(() {
        address = "주소를 가져올 수 없습니다.";
      });
    }
  }

  Future<void> findUserLevel(BuildContext context) async {
    String url = 'http://${dotenv.env['SERVER_IP']}:${dotenv.env['SERVER_PORT']}/user/level';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        setState(() {
          // userUid = data['userUid']; // 여기선 uid가 필요가 없어유
          level = data['level'];
          currentPurchaseCount = data['currentPurchaseCount'];
          needPurchaseCount = data['needPurchaseCount'];
        });
      } else {
        CommonMethods.showErrorDialog(context, '오류', '서버에서 오류가 발생했습니다.');
      }
    } catch (e) {
      CommonMethods.showErrorDialog(context, '오류', '서버와의 연결 오류가 발생했습니다.');
    }
  }

  Future<void> findUserSavingCost(BuildContext context) async {
    String url = 'http://${dotenv.env['SERVER_IP']}:${dotenv.env['SERVER_PORT']}/user/saving';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        setState(() {
          savingCost = data['savingCost'];
        });
      } else {
        CommonMethods.showErrorDialog(context, '오류', '서버에서 오류가 발생했습니다.');
      }
    } catch (e) {
      CommonMethods.showErrorDialog(context, '오류', '서버와의 연결 오류가 발생했습니다.');
    }
  }

  String formatCurrency(int amount) {
    final formatter = NumberFormat('#,###');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
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
                                builder: (context) => AccountManagementPage(userInfo: userInfo),
                              ),
                            ).then((_) => _getUpdatedUserInfo());
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
                        backgroundImage: profileImage.isNotEmpty
                            ? NetworkImage(profileImage)
                            : null,
                        child: profileImage.isEmpty
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
                          'Lv.$level',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB34FD1),
                          ),
                        ),
                        SizedBox(width: 15), // 간격을 자연스럽게 조절
                        Text(
                          nickname,
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
                              userId: userId,
                              nickname: nickname,
                              profileImage: profileImage,
                              longitude: longitude,
                              latitude: latitude,
                              token: token,
                            ),
                          ),
                        );

                        if (updatedUserInfo != null) {
                          await _getUpdatedUserInfo(); // 프로필 수정 후 사용자 정보를 다시 가져옵니다.
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
                              '$currentPurchaseCount / $needPurchaseCount',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '다음 레벨까지 ${(needPurchaseCount - currentPurchaseCount).abs()}번 남음',
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text('매너도', style: TextStyle(fontSize: 16, color: Color(0xFFB34FD1))),
                            SizedBox(height: 10),
                            Text(
                              manner,
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
                      subtitle: Text(address),
                    ),
                    ListTile(
                      leading: Icon(Icons.calendar_today, color: Color(0xFFB34FD1)),
                      title: Text('가입일', style: TextStyle(color: Color(0xFFB34FD1))),
                      subtitle: Text('${registerDate.year}/${registerDate.month}/${registerDate.day}',
                          style: TextStyle(fontSize: 18)),
                    ),
                    ListTile(
                      leading: Icon(Icons.money, color: Color(0xFFB34FD1)),
                      title: Text('모구로 아낌비용', style: TextStyle(color: Color(0xFFB34FD1))),
                      subtitle: Text(
                        '${formatCurrency(savingCost)}원',
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
      bottomNavigationBar: HomePageBottom(selectedIndex: 3),
    );
  }
}