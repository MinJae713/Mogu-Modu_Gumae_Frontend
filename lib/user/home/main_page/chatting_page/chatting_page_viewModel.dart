import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChattingPageViewModel extends ChangeNotifier {
  late Map<String, dynamic> userInfo;
  final List<Map<String, String>> chatItems = List.generate(
    5,
        (index) => {
      'title': '그럼 명지대학교에서 봐윰윰',
      'time': '오후 9시 13분',
    },
  );
  String _selectedChatFilter = '전체';

  Future<void> initUserInfo(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? userJson = pref.getString('userJson');
    userJson == null ? showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('로그인 정보가 전달되지 않았습니다.'),
        );
      }
    ) : userInfo = jsonDecode(userJson);
    if (userJson != null) notifyListeners();
  }

  String getChatFilter() {
    return _selectedChatFilter;
  }

  void setChatFilter(String label) {
    _selectedChatFilter = label;
    notifyListeners();
  }
}