import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mogu_app/user/myPage/account_management_page/account_management_page_model.dart';

import '../../../intro/loading_page/loading_page.dart';

class AccountManagementPageViewModel extends ChangeNotifier {
  late AccountManagementPageModel _model;
  AccountManagementPageModel get model => _model;

  void initViewModel(Map<String, dynamic> userInfo) {
    _model = AccountManagementPageModel.fromJson(userInfo);
    notifyListeners();
  }

  Future<void> _updateUserPassword(BuildContext context,
      String newPassword, Map<String, dynamic> userInfo) async {
    String url = 'http://${dotenv.env['SERVER_IP']}:${dotenv.env['SERVER_PORT']}/user/password';

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': userInfo['token'],
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "password": newPassword,
        }),
      );

      if (response.statusCode == 200) {
        _showSuccessDialog('성공', '비밀번호 변경에 성공하였습니다.', context);
      } else {
        String decodedBody = utf8.decode(response.bodyBytes);
        _showErrorDialog('실패', decodedBody.substring(2, decodedBody.length - 2), context);
      }
    } catch (e) {
      _showErrorDialog('오류', '서버와의 연결 오류가 발생했습니다.', context);
    }
  }

  Future<void> _deleteUser(BuildContext context,
      Map<String, dynamic> userInfo) async {
    String url = 'http://${dotenv.env['SERVER_IP']}:${dotenv.env['SERVER_PORT']}/user/my';

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': userInfo['token'],
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 204) {
        _showSuccessDialog('성공', '회원탈퇴에 성공하였습니다.', context);
      } else {
        String decodedBody = utf8.decode(response.bodyBytes);
        _showErrorDialog('실패', decodedBody.substring(2, decodedBody.length - 2), context);
      }
    } catch (e) {
      _showErrorDialog('오류', '서버와의 연결 오류가 발생했습니다.', context);
    }
  }

  void showPasswordChangeDialog(BuildContext context,
      Map<String, dynamic> userInfo) {
    final TextEditingController _newPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('비밀번호 변경'),
          content: TextField(
            controller: _newPasswordController,
            obscureText: true,
            maxLength: 16,
            decoration: InputDecoration(
              hintText: '새 비밀번호 입력 (8-16자리)',
            ),
          ),
          actions: [
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('변경'),
              onPressed: () {
                final newPassword = _newPasswordController.text;
                if (newPassword.length >= 8 && newPassword.length <= 16) {
                  _updateUserPassword(context, newPassword, userInfo);
                  Navigator.of(context).pop();
                } else {
                  _showErrorDialog('오류', '비밀번호는 8자리에서 16자리 사이여야 합니다.', context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void showDeleteConfirmationDialog(BuildContext context,
      Map<String, dynamic> userInfo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('회원탈퇴'),
          content: Text('정말로 탈퇴하시겠습니까?'),
          actions: [
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('확인'),
              onPressed: () {
                _deleteUser(context, userInfo);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(String title,
      String content, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
                if (title == '성공' && content == '회원탈퇴에 성공하였습니다.') {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoadingPage()),
                        (Route<dynamic> route) => false,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String title,
      String content, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}