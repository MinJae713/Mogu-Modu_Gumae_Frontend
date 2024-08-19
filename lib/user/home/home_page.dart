import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mogu_app/user/chat/chat_room_page.dart';
import 'package:mogu_app/user/home/post/post_create_page.dart';
import 'package:mogu_app/user/home/search_page.dart';
import 'package:mogu_app/user/myPage/account_management_page.dart';
import 'package:mogu_app/user/home/post/post_detail_page.dart';
import 'package:mogu_app/user/myPage/setting_page.dart';
import 'package:mogu_app/user/myPage/update_profile_page.dart';
import 'package:mogu_app/user/home/menu_page.dart';
import 'package:mogu_app/user/home/notification_page.dart';

import '../../service/location_service.dart';

class HomePage extends StatefulWidget {
  final Map<String, dynamic> userInfo;

  const HomePage({super.key, required this.userInfo});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
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
  int userUid = 0;
  int currentPurchaseCount = 0;
  int needPurchaseCount = 0;
  int savingCost = 0;

  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  int _selectedIndex = 0;
  late TabController _tabController;

  String _selectedSortOption = '최신순';
  final List<String> _sortOptions = ['최신순', '가까운 순'];
  double _currentDistanceValue = 2.0;

  String _selectedRecruitmentStatus = '모집중';
  String _selectedPurchaseRoute = '오프라인';
  String _selectedPurchaseStatus = '미구입';
  String _selectedChatFilter = '전체';

  final List<Map<String, dynamic>> posts = [
    {
      'username': '김찬',
      'distance': '1~2km',
      'title': '방금 구매한 계란 5개씩 나누실분...',
      'price': '2000원',
      'participants': 2,
      'maxParticipants': 3,
      'likes': 7,
      'comments': 23,
    },
    {
      'username': '나혜리',
      'distance': '500m 미만',
      'title': '~~~원치에 물티슈 10개에 6000원 원하시는분',
      'price': '2000원',
      'participants': 2,
      'maxParticipants': 3,
      'likes': 7,
      'comments': 23,
    },
  ];

  final List<Map<String, String>> chatItems = List.generate(
    6,
        (index) => {
      'title': '그럼 명지대학교에서 뵙겠습니다',
      'time': '오후 9시 13분',
    },
  );

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
    _tabController = TabController(length: 2, vsync: this);
    _initializeUserInfo();
    _getAddress(); // 초기 위치 정보를 가져오는 함수 호출
    findUserLevel(context);
    findUserSavingCose(context);
  }

  void _initializeUserInfo() {
    userId = widget.userInfo['userId'] ?? '';
    token = widget.userInfo['token'] ?? '';
    name = widget.userInfo['name'] ?? '';
    nickname = widget.userInfo['nickname'] ?? '';
    nickname = utf8.decode(widget.userInfo['nickname'].runes.toList());
    phone = widget.userInfo['phone'] ?? '';
    level = widget.userInfo['level'] ?? 0;
    manner = widget.userInfo['manner'] ?? '';
    manner = utf8.decode(widget.userInfo['manner'].runes.toList());
    longitude = widget.userInfo['longitude']?.toDouble() ?? 0.0;
    latitude = widget.userInfo['latitude']?.toDouble() ?? 0.0;
    distanceMeters = widget.userInfo['distanceMeters'] ?? 0;
    registerDate = DateTime.parse(widget.userInfo['registerDate'] ?? DateTime.now().toIso8601String());
    profileImage = widget.userInfo['profileImage'] ?? '';
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
      // 주소를 업데이트된 경도와 위도를 통해 가져오기
      await _getAddress();
    } else {
      _showErrorDialog('오류', '사용자 정보를 불러올 수 없습니다.');
    }
  }

  Future<Map<String, dynamic>?> fetchUpdatedUserInfo(String userId, String token) async {
    String url = 'http://${dotenv.env['SERVER_IP']}:${dotenv.env['SERVER_PORT']}/user/$userId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          // 'Authorization': token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        _showErrorDialog('오류', '인증 오류: 로그인 정보가 유효하지 않습니다.');
        return null;
      } else {
        _showErrorDialog('오류', '사용자 정보를 불러올 수 없습니다.');
        return null;
      }
    } catch (e) {
      _showErrorDialog('오류', '서버와의 연결 오류가 발생했습니다: ${e.toString()}');
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
      print('주소를 가져오는 중 오류 발생: $e');
    }
  }

  Future<void> findUserLevel(BuildContext context) async {
    String url = 'http://10.0.2.2:8080/user/$userId/level';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        setState(() {
          userUid = data['userUid'];
          level = data['level'];
          currentPurchaseCount = data['currentPurchaseCount'];
          needPurchaseCount = data['needPurchaseCount'];
        });
      } else {
        _showErrorDialog('오류', '서버에서 오류가 발생했습니다.');
      }
    } catch (e) {
      _showErrorDialog('오류', '서버와의 연결 오류가 발생했습니다.');
    }
  }

  Future<void> findUserSavingCose(BuildContext context) async {
    String url = 'http://10.0.2.2:8080/user/$userId/saving';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        setState(() {
          savingCost = data['savingCost'];
        });
      } else {
        _showErrorDialog('오류', '서버에서 오류가 발생했습니다.');
      }
    } catch (e) {
      _showErrorDialog('오류', '서버와의 연결 오류가 발생했습니다.');
    }
  }

  void _showErrorDialog(String title, String content) {
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

  @override
  void dispose() {
    _bannerAd?.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/9214589741',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          print('Failed to load a banner ad: $error');
          ad.dispose();
        },
      ),
    );
    _bannerAd!.load();
  }

  String formatCurrency(int amount) {
    final formatter = NumberFormat('#,###');
    return formatter.format(amount);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onSortOptionChanged(String? newValue) {
    setState(() {
      _selectedSortOption = newValue!;
    });
  }

  void _showSearchOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '검색 옵션',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text('나와의 거리'),
                  Slider(
                    value: _currentDistanceValue,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    label: '${_currentDistanceValue.toStringAsFixed(1)} km',
                    onChanged: (value) {
                      setModalState(() {
                        _currentDistanceValue = value;
                      });
                    },
                    activeColor: Color(0xFFB34FD1),
                    inactiveColor: Colors.grey,
                  ),
                  Text(
                    '~ ${_currentDistanceValue.toStringAsFixed(1)}km',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  _buildToggleButton(
                    '모집 상태',
                    '모집중',
                    '마감',
                    _selectedRecruitmentStatus,
                        (newValue) {
                      setModalState(() {
                        _selectedRecruitmentStatus = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  _buildToggleButton(
                    '구매 경로',
                    '오프라인',
                    '온라인',
                    _selectedPurchaseRoute,
                        (newValue) {
                      setModalState(() {
                        _selectedPurchaseRoute = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  _buildToggleButton(
                    '구매 상태',
                    '미구입',
                    '구입완료',
                    _selectedPurchaseStatus,
                        (newValue) {
                      setModalState(() {
                        _selectedPurchaseStatus = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey,
                          backgroundColor: Colors.grey.shade200,
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('초기화'),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Color(0xFFB34FD1),
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text('적용하기'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildToggleButton(
      String label,
      String option1,
      String option2,
      String selectedValue,
      ValueChanged<String> onChanged,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  onChanged(option1);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: selectedValue == option1 ? Colors.white : Colors.grey,
                  backgroundColor: selectedValue == option1 ? Color(0xFFB34FD1) : Colors.grey.shade200,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                ),
                child: Text(option1),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  onChanged(option2);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: selectedValue == option2 ? Colors.white : Colors.grey,
                  backgroundColor: selectedValue == option2 ? Color(0xFFB34FD1) : Colors.grey.shade200,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                ),
                child: Text(option2),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChatFilterButton(String label) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          _selectedChatFilter = label;
        });
      },
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        backgroundColor: _selectedChatFilter == label ? Colors.grey.shade200 : Colors.white,
        side: BorderSide(
          color: _selectedChatFilter == label ? Colors.black : Colors.grey,
        ),
      ),
      child: Text(label, style: TextStyle(fontSize: 14)),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    bool isLiked = false; // 초기 상태로 하트를 누르지 않은 상태로 설정
    int likeCount = post['likes']; // 초기 좋아요 수

    return StatefulBuilder(
      builder: (context, setState) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => PostDetailPage(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.ease;
                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
            );
          },
          splashColor: Color(0xFFB34FD1).withOpacity(0.2), // 카드 클릭 시 물결 효과 유지
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User info and location
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                            "https://example.com/profile_image.jpg"), // Placeholder for profile image
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post['username'],
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: const [
                          Icon(Icons.place, color: Color(0xFFB34FD1), size: 16),
                          SizedBox(width: 4),
                          Text(
                            '명지대사거리 우리은행 앞', // Placeholder location
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Post title and image/icon
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post['title'],
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFE6F7),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    '모구가',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFFB34FD1),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  post['price'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFFB34FD1),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      if (post['imageUrl'] != null && post['imageUrl'].isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            post['imageUrl'], // Actual image from post data
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.image,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Participant info, Mogoo deadline, and like/comment stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${post['participants']}/${post['maxParticipants']}',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          SizedBox(width: 8),
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.grey.shade300,
                                child: Icon(
                                  Icons.person,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                              Positioned(
                                left: 16,
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.grey.shade300,
                                  child: Icon(
                                    Icons.person,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 20),
                          Text(
                            '모구 마감',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '12/32',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isLiked = !isLiked;
                                likeCount += isLiked ? 1 : -1;
                              });
                            },
                            child: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              size: 20, // 하트 아이콘의 크기를 20으로 설정
                              color: Color(0xFFB34FD1),
                            ),
                          ),
                          SizedBox(width: 4),
                          Text('$likeCount', style: TextStyle(color: Color(0xFFB34FD1))),
                          SizedBox(width: 16),
                          SvgPicture.asset(
                            'assets/icons/views.svg', // SVG 아이콘 경로
                            width: 16,
                            height: 16,
                          ),
                          SizedBox(width: 4),
                          Text('${post['comments']}', style: TextStyle(color: Color(0xFFB34FD1))),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMoguHistoryCard() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => PostDetailPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.ease;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      },
      splashColor: Colors.purple.withOpacity(0.3),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.image, size: 60, color: Colors.grey),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('명지대사거리 우리은행 앞'),
                        Text(
                          '방금 구매한 계란 5개씩 나누실 분...',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text('모구가 : 2000원'),
                        Text('참여 인원 2/3\n모구 마감 12/32'),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '**신청 상태 : 승인',
                  style: TextStyle(color: Colors.purple),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMyMoguCard() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => PostDetailPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.ease;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      },
      splashColor: Colors.purple.withOpacity(0.3),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Icon(Icons.image, size: 60, color: Colors.grey),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '방금 구매한 계란 5개씩 나누실 분...',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('모구가 : 2000원'),
                    Text('모구 마감: 2024/12/32'),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text('2/3'),
                        SizedBox(width: 8),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.grey,
                            ),
                            Positioned(
                              left: 12,
                              child: CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return _buildPostCard(posts[index]);
        },
      ),
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildChatFilterButton('전체'),
                SizedBox(width: 8),
                _buildChatFilterButton('판매'),
                SizedBox(width: 8),
                _buildChatFilterButton('구매'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: chatItems.length,
              itemBuilder: (context, index) {
                final chat = chatItems[index];
                return ListTile(
                  leading: Icon(
                    Icons.image,
                    size: 50,
                    color: Colors.grey,
                  ),
                  title: Text(chat['title']!),
                  subtitle: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: const [
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.grey,
                            child: Icon(
                              Icons.person,
                              size: 10,
                              color: Colors.white,
                            ),
                          ),
                          Positioned(
                            left: 8,
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.grey,
                              child: Icon(
                                Icons.person,
                                size: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Text(chat['time']!),
                    ],
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => ChatRoomPage(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.ease;
                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      TabBarView(
        controller: _tabController,
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return _buildMoguHistoryCard();
                  },
                ),
              ),
            ],
          ),
          ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return _buildMyMoguCard();
            },
          ),
        ],
      ),
      SingleChildScrollView(
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
    ];

    return Scaffold(
      appBar: AppBar(
        leading: _selectedIndex == 0
            ? IconButton(
          icon: Icon(Icons.reorder),
          color: Color(0xFFFFD3F0),
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => MenuPage(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(-1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.ease;
                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
            );
          },
        )
            : null,
        title: _selectedIndex == 0
            ? null
            : Text(
          ['채팅목록', '모구내역', '마이페이지'][_selectedIndex - 1],
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
        bottom: _selectedIndex == 2
            ? PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Color(0xFFB34FD1),
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color(0xFFB34FD1),
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: Color(0xFFB34FD1), width: 3),
                insets: EdgeInsets.symmetric(horizontal: 0.0),
              ),
              tabs: const [
                Tab(text: '나의 참여'),
                Tab(text: '나의 모구'),
              ],
            ),
          ),
        )
            : null,
        actions: [
          if (_selectedIndex == 0)
            IconButton(
              icon: Icon(Icons.search),
              color: Color(0xFFFFD3F0),
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => SearchPage(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.ease;
                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                );
              },
            ),
          IconButton(
            icon: Icon(_selectedIndex == 3 ? Icons.settings : Icons.notifications),
            color: Color(0xFFFFD3F0),
            onPressed: () {
              if (_selectedIndex != 3) {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => NotificationPage(userInfo: widget.userInfo),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.ease;
                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                );
              } else {
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
                                  builder: (context) => AccountManagementPage(userInfo: widget.userInfo),
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
              }
            },
          ),
        ],
      ),
      body: _selectedIndex == 2
          ? TabBarView(
        controller: _tabController,
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return _buildMoguHistoryCard();
                  },
                ),
              ),
            ],
          ),
          ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return _buildMyMoguCard();
            },
          ),
        ],
      )
          : Column(
        children: <Widget>[
          if (_selectedIndex == 0 && _isAdLoaded)
            Container(
              alignment: Alignment.center,
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
          if (_selectedIndex == 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: SvgPicture.asset("assets/icons/search_filter.svg"),
                    onPressed: () {
                      _showSearchOptions(context);
                    },
                  ),
                  DropdownButton<String>(
                    value: _selectedSortOption,
                    items: _sortOptions.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(color: Color(0xFFB34FD1))),
                      );
                    }).toList(),
                    onChanged: _onSortOptionChanged,
                    iconEnabledColor: Color(0xFFB34FD1),
                    underline: SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          Expanded(
            child: widgetOptions[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _selectedIndex == 0 ? "assets/icons/selected_home.svg" : "assets/icons/unselected_home.svg",
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _selectedIndex == 1 ? "assets/icons/selected_chat.svg" : "assets/icons/unselected_chat.svg",
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            label: '채팅',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _selectedIndex == 2 ? "assets/icons/selected_history.svg" : "assets/icons/unselected_history.svg",
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            label: '모구내역',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _selectedIndex == 3 ? "assets/icons/selected_my_page.svg" : "assets/icons/unselected_my_page.svg",
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            label: 'MY',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFFB34FD1),
        unselectedItemColor: Color(0xFFFFBDE9),
        onTap: _onItemTapped,
      ),
      floatingActionButton: _selectedIndex == 0
          ? ClipOval(
        child: Material(
          child: InkWell(
            splashColor: Colors.white.withOpacity(0.3),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostCreatePage(
                    userInfo: widget.userInfo, // userInfo 전달
                  ),
                ),
              );
            },
            child: SizedBox(
              width: 56,
              height: 56,
              child: Center(
                child: SvgPicture.asset(
                  "assets/icons/post_create_button.svg",
                  width: 56,
                  height: 56,
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomRight,
                ),
              ),
            ),
          ),
        ),
      )
          : null,
    );
  }
}