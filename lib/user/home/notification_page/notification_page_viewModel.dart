import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class NotificationPageViewModel extends ChangeNotifier {

  List<Map<String, String>> notifications = [];

  void initViewModel(BuildContext context,
      Map<String, dynamic> userInfo) {
    _findAlarmSignal(context, userInfo);
  }

  Future<void> _findAlarmSignal(BuildContext context,
      Map<String, dynamic> userInfo) async {
    // String url = 'http://${dotenv.env['SERVER_IP']}:${dotenv.env['SERVER_PORT']}/alarm/${userInfo['userId']}';
    String url = 'http://10.0.2.2:8080/alarm/${userInfo['userId']}';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        print('바디-${response.body}');
        /*
        바디-
        <!doctype html><html lang="en-US" dir="ltr">
        <head>
          <base href="https://accounts.google.com/v3/signin/">
          <link rel="preconnect" href="//www.gstatic.com">
          <meta name="referrer" content="origin">
          <style data-href="https://www.gstatic.com/_/mss/boq-identity/_/ss/k=boq-identity.AccountsSignInUi.a3vNyRoRVPE.L.X.O/am=yQGTZLgGECj_IxBABQCAAIACAAAAAAAAAABgAAAgEwI/d=1/ed=1/rs=AOaEmlGTygNpU8XtXJJCHVk_ceiJpItYBw/m=identifierview,_b,_tp" nonce="Vi1OGavOdfRXEw4isRdO8A">@-webkit-keyframes quantumWizBoxInkSpread{0%{-webkit-transform:translate(-50%,-50%) scale(0.2);-webkit-transform:translate(-50%,-50%) scale(0.2);-ms-transform:translate(-50%,-50%) scale(0.2);-o-transform:translate(-50%,-50%) scale(0.2);transform:translate(-50%,-50%) scale(0.2)}to{-webkit-transform:translate(-50%,-50%) scale(2.2);-webkit-transform:translate(-50%,-50%) scale(2.2);-ms-transform:translate(-50%,-50%) scale(2.2);-o-transform:translate(-50%,-50%) scale(2.2);transform:translate(-50%,-50%) scale(2.2)}}@keyframes quantumWizBoxInkSpread{0%{-webkit-t
         */
        // reponse.body 찍어보면 저렇게 나옴 -> json 결과가 아니라서 Decode 못함 -> 그래서 에러가 생기는거 같네유
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