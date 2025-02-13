import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _isPushNotificationEnabled = true;

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
          '환경설정',
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
            mainAxisSize: MainAxisSize.min, // Adjust the height of the container based on its content
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '푸쉬알림',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(10, 0), // X축으로 10픽셀 이동
                    child: Switch(
                      value: _isPushNotificationEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          _isPushNotificationEnabled = value;
                        });
                      },
                      activeColor: Colors.white, // 스위치 내부 원 색상
                      activeTrackColor: Color(0xFFB34FD1), // 스위치가 켜졌을 때의 트랙 색상
                    ),
                  ),
                ],
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  '언어선택',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Text(
                  '한국어',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                onTap: () {
                  // 언어 선택 시 동작할 로직을 추가하세요.
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  '버전',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Text(
                  '1.0.0v',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: 8), // Adjust the bottom padding to be similar to the top padding
            ],
          ),
        ),
      ),
    );
  }
}
