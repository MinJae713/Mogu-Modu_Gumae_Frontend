import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mogu_app/user/home/main_page/home_page/home_page_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../service/location_service.dart';
import '../common/common_methods.dart';

class HomeMainPageViewModel extends ChangeNotifier {
  late Map<String, dynamic> userInfo;

  BannerAd? bannerAd;
  late HomePageModel _model;
  HomePageModel get model => _model;
  bool isInitialized = false;

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

  void initViewModel(BuildContext context) {
    loadBannerAd();
    getUserInfo(context).then((value) {
      _model = HomePageModel.fromJson(userInfo);
      findUserLevel(context);
      findAllPost(context);
      // 초기화 시 모든 게시글을 불러옴
      isInitialized = true;
      notifyListeners();
    });
  }

  Future<void> findUserLevel(BuildContext context) async {
    String url = 'http://${dotenv.env['SERVER_IP']}:${dotenv.env['SERVER_PORT']}/user/level';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': _model.token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        _model.setUserUid(data['userUid']);
        notifyListeners();
      } else {
        CommonMethods.showErrorDialog(context, '오류', '서버에서 오류가 발생했습니다.');
      }
    } catch (e) {
      CommonMethods.showErrorDialog(context, '오류', '서버와의 연결 오류가 발생했습니다.');
    }
  }

  Future<void> findAllPost(BuildContext context) async {
    String url = 'http://${dotenv.env['SERVER_IP']}:${dotenv.env['SERVER_PORT']}/post/all';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': _model.token, // 토큰을 헤더에 추가
          'Content-Type': 'application/json', // 필요한 경우 헤더에 Content-Type도 추가
        },
      );

      if (response.statusCode == 200) {
        // 응답 데이터의 body를 UTF-8로 디코딩
        String decodedBody = utf8.decode(response.bodyBytes);
        List<dynamic> responseData = jsonDecode(decodedBody);
        _model.posts.clear(); // 기존 게시글 리스트 초기화
        for (var item in responseData) {
          if (item['isHidden'] == true) {
            continue; // isHidden이 true이면 해당 아이템을 건너뜁니다.
          }

          double postLatitude = item['latitude']?.toDouble() ?? 0.0;
          double postLongitude = item['longitude']?.toDouble() ?? 0.0;

          // 주소를 가져옵니다.
          String postAddress = '주소를 불러오는 중...';

          // 주소를 비동기로 가져옵니다.
          LocationService().getAddressFromCoordinates(postLatitude, postLongitude)
              .then((address) {
            int index = _model.posts.indexWhere((p) => p['id'] == item['id']);
            if (index != -1) {
              _model.setPostAddress(index, address);
            }
            notifyListeners();
          });
          _model.addPost({
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
        sortPosts();
        notifyListeners();
      } else {
        CommonMethods.showErrorDialog(context, '불러오기 실패', '서버에서 오류가 발생했습니다.');
      }
    } catch (e) {
      CommonMethods.showErrorDialog(context, '오류', '서버와의 연결 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }

  void sortPosts() {
    if (_model.selectedSortOption == '최신순') {
      _model.posts.sort((a, b) => DateTime.parse(b['postDate']).compareTo(DateTime.parse(a['postDate'])));
    } else if (_model.selectedSortOption == '가까운 순') {
      _model.posts.sort((a, b) {
        double distanceA = CommonMethods.calculateDistance(_model.latitude, _model.longitude, a['latitude'], a['longitude']);
        double distanceB = CommonMethods.calculateDistance(_model.latitude, _model.longitude, b['latitude'], b['longitude']);
        return distanceA.compareTo(distanceB);
      });
    }
  }

  void disposeViewModel() {
    bannerAd?.dispose();
  }

  void loadBannerAd() {
    bannerAd = BannerAd(
      adUnitId: dotenv.env['GOOGLE_AD_BANNER_API_KEY'] ?? '',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _model.setAdLoaded(true);
          notifyListeners();
        },
        onAdFailedToLoad: (ad, error) {
          print('Failed to load a banner ad: $error');
          ad.dispose();
        },
      ),
    );
    bannerAd!.load();
  }

  void onSortOptionChanged(String? newValue) {
    _model.selectedSortOption = newValue!;
    sortPosts();  // 선택된 정렬 옵션에 따라 게시물 정렬
    notifyListeners();
  }
  void applySearchOptions(Map<String, dynamic> options) {
    double currentDistanceValue = options['currentDistanceValue'];
    String selectedRecruitmentStatus = options['selectedRecruitmentStatus'];
    String selectedPurchaseRoute = options['selectedPurchaseRoute'];
    String selectedPurchaseStatus = options['selectedPurchaseStatus'];
    print('${currentDistanceValue},${selectedRecruitmentStatus},${selectedPurchaseRoute},${selectedPurchaseStatus}');
    // 위 print는 콜백 로그 찍어보기용
  }

  void filterByCategory(BuildContext context, String value) async {
    await findAllPost(context);
    _model.setPosts(_model.posts.where((post) => post['category'] == value).toList());
    notifyListeners();
  }
}