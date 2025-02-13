import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class NotificationPageViewModel extends ChangeNotifier {
  late TabController _tabController;
  List<Map<String, String>> notifications = [];

  TabController get tabController => _tabController;

  void initViewModel(BuildContext context,
      SingleTickerProviderStateMixin vsync,
      Map<String, dynamic> userInfo) {
    _tabController = TabController(length: 2, vsync: vsync);
    _findAlarmSignal(context, userInfo);
  }

  void disposeViewModel() {
    _tabController.dispose();
  }

  Future<void> _findAlarmSignal(BuildContext context,
      Map<String, dynamic> userInfo) async {
    String url = 'http://10.0.2.2:8080/alarm/${userInfo['userId']}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<Map<String, dynamic>> data = List<Map<String, String>>.from(jsonDecode(response.body));
        notifications = (data as List<dynamic>).map((item) {
          return {
            'title': item['content'] as String? ?? '알림 내용 없음',
            'time': item['createdAt'] as String? ?? '시간 정보 없음',
          };
        }).toList();
      } else {
        _showErrorDialog(context, '알림 불러오기 실패', '서버에서 오류가 발생했습니다.');
      }
    } catch (e) {
      _showErrorDialog(context, '오류', '서버와의 연결 오류가 발생했습니다.');
    }
  }

  void _showErrorDialog(BuildContext context,
      String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
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