import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mogu_app/user/home/main_page/chatting_page/chatting_page_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChattingPageViewModel extends ChangeNotifier {
  late Map<String, dynamic> userInfo;
  late ChattingPageModel _model;
  ChattingPageModel get model => _model;

  bool isInitialized = false;

  void initUserInfo(BuildContext context) async {
    getUserInfo(context).then((value) {
      _model = ChattingPageModel();
      isInitialized = true;
      notifyListeners();
    });
  }

  Future<void> getUserInfo(BuildContext context) async {
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
    userInfo = jsonDecode(userJson);
    if (userJson != null) notifyListeners();
  }

  String getChatFilter() {
    return _model.getChatFilter();
  }

  void setChatFilter(String label) {
    _model.setChatFilter(label);
    notifyListeners();
  }
}