import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mogu_app/user/home/main_page/common/common_methods.dart';
import 'package:mogu_app/user/home/main_page/home_page/home_post_card.dart';
import 'package:mogu_app/user/home/main_page/home_page/home_search_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../service/location_service.dart';
import '../../menu_page.dart';
import '../../notification_page.dart';
import '../../post/post_create_page.dart';
import '../../search_page.dart';
import '../bottom/home_page_bottom.dart';

class HomeMainPage extends StatefulWidget {
  const HomeMainPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeMainPage();
  }
}

class _HomeMainPage extends State<HomeMainPage> {
  late Map<String, dynamic> userInfo;

  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  String _selectedSortOption = '최신순';
  final List<String> _sortOptions = ['최신순', '가까운 순'];

  late double longitude;
  late double latitude;
  late String token;
  int userUid = 0;
  List<Map<String, dynamic>> posts = []; // 게시글 리스트 초기화

  Future<void> _getUserInfo() async {
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
    setState(() {
      userInfo = jsonDecode(userJson);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
    _getUserInfo().then((value) {
      _initializeUserInfo();
      findUserLevel(context);
      _findAllPost(context); // 초기화 시 모든 게시글을 불러옴
    });
  }

  void _initializeUserInfo() {
    token = userInfo['token'] ?? '';
    longitude = userInfo['longitude']?.toDouble() ?? 0.0;
    latitude = userInfo['latitude']?.toDouble() ?? 0.0;
  }

  Future<void> findUserLevel(BuildContext context) async {
    String url = 'http://${dotenv.env['SERVER_IP']}:${dotenv.env['SERVER_PORT']}/user/level';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        setState(() {
          userUid = data['userUid'];
          // level = data['level'];
          // currentPurchaseCount = data['currentPurchaseCount'];
          // needPurchaseCount = data['needPurchaseCount'];
        });
      } else {
        CommonMethods.showErrorDialog(context, '오류', '서버에서 오류가 발생했습니다.');
      }
    } catch (e) {
      CommonMethods.showErrorDialog(context, '오류', '서버와의 연결 오류가 발생했습니다.');
    }
  }

  Future<void> _findAllPost(BuildContext context) async {
    String url = 'http://${dotenv.env['SERVER_IP']}:${dotenv.env['SERVER_PORT']}/post/all';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': token, // 토큰을 헤더에 추가
          'Content-Type': 'application/json', // 필요한 경우 헤더에 Content-Type도 추가
        },
      );

      if (response.statusCode == 200) {
        // 응답 데이터의 body를 UTF-8로 디코딩
        String decodedBody = utf8.decode(response.bodyBytes);
        List<dynamic> responseData = jsonDecode(decodedBody);

        setState(() {
          posts.clear(); // 기존 게시글 리스트 초기화
          for (var item in responseData) {
            if (item['isHidden'] == true) {
              continue; // isHidden이 true이면 해당 아이템을 건너뜁니다.
            }

            double postLatitude = item['latitude']?.toDouble() ?? 0.0;
            double postLongitude = item['longitude']?.toDouble() ?? 0.0;

            // 주소를 가져옵니다.
            String postAddress = '주소를 불러오는 중...';

            // 주소를 비동기로 가져옵니다.
            LocationService().getAddressFromCoordinates(postLatitude, postLongitude).then((address) {
              setState(() {
                // 해당 게시물의 주소를 업데이트합니다.
                int index = posts.indexWhere((p) => p['id'] == item['id']);
                if (index != -1) {
                  posts[index]['address'] = address;
                }
              });
            });

            posts.add({
              'id': item['id'] ?? 0, // ID 추가
              'category': item['category'] ?? '알 수 없음', // 카테고리 추가
              'isHidden': item['isHidden'] ?? false, // 숨김 상태 추가
              'recruitState': item['recruitState'] ?? '모집중', // 모집 상태 추가
              'title': item['title'] ?? '제목 없음',
              'userNickname': item['userNickname'] ?? '알 수 없음',
              'userUid': item['userUid'] ?? 0, // 사용자 ID 추가
              'chiefPrice': item['chiefPrice'] ?? 0, // 주최자 가격 추가
              'originalPrice': item['originalPrice'] ?? 0, // 원래 가격 추가
              'shareCondition': item['shareCondition'] ?? false, // 공유 조건 추가
              'pricePerCount': item['pricePerCount'] ?? 0, // 인당 가격 추가
              'userCount': item['userCount'] ?? 0, // 최대 참가자 수 추가
              'currentUserCount': item['currentUserCount'] ?? 0,
              'userProfiles': item['userProfiles'] ?? '',
              'heartCount': item['heartCount'] ?? 0,
              'viewCount': item['viewCount'] ?? 0,
              'reportCount': item['reportCount'] ?? 0, // 신고 수 추가
              'longitude': postLongitude, // 경도 추가
              'latitude': postLatitude, // 위도 추가
              'thumbnail': item['thumbnail'] ?? '', // 게시글 썸네일 URL
              'postDate': item['postDate'] ?? '', // 게시일 추가
              'purchaseDate': item['purchaseDate'] ?? '', // 구매일 추가
              'address': postAddress, // 주소 추가
            });
          }

          // 정렬 옵션에 따라 게시글 리스트를 정렬
          _sortPosts();
        });
      } else {
        CommonMethods.showErrorDialog(context, '불러오기 실패', '서버에서 오류가 발생했습니다.');
      }
    } catch (e) {
      CommonMethods.showErrorDialog(context, '오류', '서버와의 연결 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }

  void _sortPosts() {
    if (_selectedSortOption == '최신순') {
      posts.sort((a, b) => DateTime.parse(b['postDate']).compareTo(DateTime.parse(a['postDate'])));
    } else if (_selectedSortOption == '가까운 순') {
      posts.sort((a, b) {
        double distanceA = CommonMethods.calculateDistance(latitude, longitude, a['latitude'], a['longitude']);
        double distanceB = CommonMethods.calculateDistance(latitude, longitude, b['latitude'], b['longitude']);
        return distanceA.compareTo(distanceB);
      });
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: dotenv.env['GOOGLE_AD_BANNER_API_KEY'] ?? '',
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

  void _onSortOptionChanged(String? newValue) {
    setState(() {
      _selectedSortOption = newValue!;
      _sortPosts();  // 선택된 정렬 옵션에 따라 게시물 정렬
    });
  }
  void applySearchOptions(Map<String, dynamic> options) {
    double currentDistanceValue = options['currentDistanceValue'];
    String selectedRecruitmentStatus = options['selectedRecruitmentStatus'];
    String selectedPurchaseRoute = options['selectedPurchaseRoute'];
    String selectedPurchaseStatus = options['selectedPurchaseStatus'];
    print('${currentDistanceValue},${selectedRecruitmentStatus},${selectedPurchaseRoute},${selectedPurchaseStatus}');
    // 위 print는 콜백 로그 찍어보기용
  }

  void _filterByCategory(String value) async {
    await _findAllPost(context);
    print(posts);
    setState(() {
      posts = posts.where((post) => post['category'] == value).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
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
            ).then((value) {
              _filterByCategory(value);
            });
          },
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
        actions: [
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
            icon: Icon(Icons.notifications),
            color: Color(0xFFFFD3F0),
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => NotificationPage(userInfo: userInfo),
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
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          if (_isAdLoaded)
            Container(
              alignment: Alignment.center,
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: SvgPicture.asset("assets/icons/search_filter.svg"),
                  onPressed: () {
                    HomeSearchOptions homeSearchOptions = HomeSearchOptions(
                      applySearchOptions: applySearchOptions
                    );
                    homeSearchOptions.showSearchOptions(context);
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
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return HomePostCard(post: posts[index], userUid: userUid);
              },
            )
          )
        ],
      ),
      bottomNavigationBar: HomePageBottom(selectedIndex: 0),
      floatingActionButton: ClipOval(
        child: Material(
          child: InkWell(
            splashColor: Colors.white.withOpacity(0.3),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostCreatePage(
                    userInfo: userInfo, // userInfo 전달
                  ),
                ),
              );

              if (result == true) {
                await _findAllPost(context);
              }
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
      ),
    );
  }
}