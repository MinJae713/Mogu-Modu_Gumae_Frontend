import 'package:flutter/material.dart';

class MemberList {
  List<Widget> build(String searchQuery) {
    // 회원관리 탭에서 표시할 회원 목록을 정의합니다.
    List<Map<String, String>> members = [
      {
        'profileName': '김찬',
        'phoneNumber': '010-1234-5678',
        'email': '1234qwer@naver.com',
        'address': '서울특별시 서대문구 거북골로 34-1 2층 302호',
        'totalTrades': '12',
        'reports': '1',
      },
      {
        'profileName': '나하리',
        'phoneNumber': '010-1234-5678',
        'email': '1234qwer@naver.com',
        'address': '서울특별시 서대문구 남가좌동',
        'totalTrades': '12',
        'reports': '1',
      },
      {
        'profileName': '모비팡',
        'phoneNumber': '010-1234-5678',
        'email': '1234qwer@naver.com',
        'address': '서울특별시 서대문구 남가좌동',
        'totalTrades': '12',
        'reports': '1',
      },
      {
        'profileName': '윰대찬',
        'phoneNumber': '010-3737-2855',
        'email': 'dbalsend@naver.com',
        'address': '고양시 덕양구 행신동',
        'totalTrades': '20',
        'reports': '1',
      },
    ];

    // 검색어가 있으면 필터링
    if (searchQuery.isNotEmpty) {
      members = members
          .where((member) => member['profileName']!.contains(searchQuery))
          .toList();
    }

    // 필터링된 회원 목록을 위젯으로 변환
    List<Widget> results = members.map((member) {
      return MemberCard(
        profileName: member['profileName']!,
        phoneNumber: member['phoneNumber']!,
        email: member['email']!,
        address: member['address']!,
        totalTrades: member['totalTrades']!,
        reports: member['reports']!,
      );
    }).toList();

    return results;
  }
}

class MemberCard extends StatefulWidget {
  final String profileName;
  final String phoneNumber;
  final String email;
  final String address;
  final String totalTrades;
  final String reports;
  const MemberCard({super.key,
    required this.profileName,
    required this.phoneNumber,
    required this.email,
    required this.address,
    required this.totalTrades,
    required this.reports
  });

  @override
  State<StatefulWidget> createState() {
    return _MemberCard();
  }
}

class _MemberCard extends State<MemberCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('${widget.profileName} 회원 클릭됨');
      },
      splashColor: Colors.purple.withOpacity(0.3), // 물결 효과 색상
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    child: Icon(Icons.person), // 프로필 이미지를 여기에 추가할 수 있음
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.profileName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text('이름 : ${widget.profileName}'),
              Text('전화번호 : ${widget.phoneNumber}'),
              Text('이메일 : ${widget.email}'),
              Text('주소 : ${widget.address}'),
              Text('총 거래 횟수 : ${widget.totalTrades}'),
              Text(
                '신고당한 횟수 : ${widget.reports}',
                style: TextStyle(color: Colors.red),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      print('메시지 전송 클릭됨');
                    },
                    child: Text(
                      '메시지전송',
                      style: TextStyle(color: Colors.purple),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      print('차단하기 클릭됨');
                      // 차단 다이얼로그 표시 코드 추가
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            titlePadding: EdgeInsets.only(top: 24),
                            contentPadding: EdgeInsets.symmetric(horizontal: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            title: Center(
                              child: Text(
                                '차단 사유를 입력해주세요',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ),
                            content: SizedBox(
                              height: 100,
                              child: TextField(
                                maxLines: 4,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.purple, backgroundColor: Colors.purple[100], // 글자 색상
                                      minimumSize: Size(80, 40), // 최소 크기
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    child: Text('확인'),
                                  ),
                                  SizedBox(width: 8), // 버튼 사이의 간격
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.purple, backgroundColor: Colors.purple[200], // 글자 색상
                                      minimumSize: Size(80, 40), // 최소 크기
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    child: Text('취소'),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      '차단하기',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}