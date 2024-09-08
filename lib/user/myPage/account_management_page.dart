import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../firstStep/loading_page.dart';

class AccountManagementPage extends StatefulWidget {
  final Map<String, dynamic> userInfo;

  const AccountManagementPage({super.key, required this.userInfo});

  @override
  _AccountManagementPage createState() => _AccountManagementPage();
}

class _AccountManagementPage extends State<AccountManagementPage> {
  late String userId;
  late String password;
  late String name;
  late String phone;

  @override
  void initState() {
    super.initState();
    userId = widget.userInfo['userId'] ?? 'N/A';
    password = widget.userInfo['password'] ?? '********';  // password는 보통 표시하지 않거나 암호화된 형태로 보입니다.
    name = widget.userInfo['name'] ?? 'N/A';
    phone = _formatPhoneNumber(widget.userInfo['phone'] ?? 'N/A');
  }

  Future<void> updateUserPassword(BuildContext context, String newPassword) async {
    String url = 'http://${dotenv.env['SERVER_IP']}:${dotenv.env['SERVER_PORT']}/user/password';

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': widget.userInfo['token'],
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "password": newPassword,
        }),
      );

      if (response.statusCode == 200) {
        _showSuccessDialog('성공', '비밀번호 변경에 성공하였습니다.');
      } else {
        String decodedBody = utf8.decode(response.bodyBytes);
        _showErrorDialog('실패', decodedBody.substring(2, decodedBody.length - 2));
      }
    } catch (e) {
      _showErrorDialog('오류', '서버와의 연결 오류가 발생했습니다.');
    }
  }

  Future<void> deleteUser(BuildContext context) async {
    String url = 'http://${dotenv.env['SERVER_IP']}:${dotenv.env['SERVER_PORT']}/user/my';

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': widget.userInfo['token'],
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 204) {
        _showSuccessDialog('성공', '회원탈퇴에 성공하였습니다.');
      } else {
        String decodedBody = utf8.decode(response.bodyBytes);
        _showErrorDialog('실패', decodedBody.substring(2, decodedBody.length - 2));
      }
    } catch (e) {
      _showErrorDialog('오류', '서버와의 연결 오류가 발생했습니다.');
    }
  }

  String _formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.length == 11) {
      return '${phoneNumber.substring(0, 3)}-${phoneNumber.substring(3, 7)}-${phoneNumber.substring(7)}';
    } else if (phoneNumber.length == 10) {
      return '${phoneNumber.substring(0, 3)}-${phoneNumber.substring(3, 6)}-${phoneNumber.substring(6)}';
    } else {
      return phoneNumber; // 포맷에 맞지 않는 경우 그대로 반환
    }
  }

  void _showPasswordChangeDialog() {
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
                  updateUserPassword(context, newPassword);
                  Navigator.of(context).pop();
                } else {
                  _showErrorDialog('오류', '비밀번호는 8자리에서 16자리 사이여야 합니다.');
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog() {
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
                deleteUser(context);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(String title, String content) {
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

  void _showErrorDialog(String title, String content) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          color: Color(0xFFFFD3F0),
          onPressed: () {
            Navigator.pop(context); // 이전 페이지로 돌아가기
          },
        ),
        title: Text(
          '계정관리',
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInfoRow('아이디', userId),
              _buildInfoRow('비밀번호', password, hasButton: true),
              _buildInfoRow('이름', name),
              _buildInfoRow('전화번호', phone),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: _showDeleteConfirmationDialog,
                  child: Text(
                    '회원탈퇴',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, {bool hasButton = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                if (hasButton)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: ElevatedButton(
                      onPressed: _showPasswordChangeDialog,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFF5F5F5F),
                        minimumSize: Size(35, 25),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text('변경', style: TextStyle(fontSize: 12)),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}