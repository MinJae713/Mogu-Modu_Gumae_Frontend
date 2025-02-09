import 'package:flutter/material.dart';

class ChatRoomPageViewModel extends ChangeNotifier {
  void showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text('알림 끄기 / 알림 켜기'),
              onTap: () {
                // 알림 끄기/켜기 동작을 정의하세요.
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('채팅방 나가기'),
              onTap: () {
                // 채팅방 나가기 동작을 정의하세요.
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('취소'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}