import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mogu_app/user/home/main_page/my_page/my_page_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../service/location_service.dart';
import '../common/common_methods.dart';

class MyPageViewModel extends ChangeNotifier {
  late Map<String, dynamic> userInfo;
  late MyPageModel _model;
  MyPageModel get model => _model;
  bool isInitialized = false;

  void initViewModel(BuildContext context) {
    _getUserInfo(context).then((value) {
      _initializeUserInfo();
      _getAddress();
      _findUserLevel(context);
      _findUserSavingCost(context);
      isInitialized = true;
      notifyListeners();
    });
  }

  Future<void> _getUserInfo(BuildContext context) async {
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
    notifyListeners();
  }

  void _initializeUserInfo() {
    _model = MyPageModel.fromJson(userInfo);
  }

  Future<void> getUpdatedUserInfo(BuildContext context) async {
    final updatedUserInfo = await fetchUpdatedUserInfo(context, model.userId, model.token);
    if (updatedUserInfo != null) {
      model.setNickname(updatedUserInfo['nickname'] ?? model.nickname);
      model.setProfileImage(updatedUserInfo['profileImage'] ?? model.profileImage);
      model.setLongitude(updatedUserInfo['longitude']?.toDouble() ?? model.longitude);
      model.setLatitude(updatedUserInfo['latitude']?.toDouble() ?? model.latitude);
      notifyListeners();
      await _getAddress();
    } else {
      CommonMethods.showErrorDialog(context, '오류', '사용자 정보를 불러올 수 없습니다.');
    }
  }

  Future<Map<String, dynamic>?> fetchUpdatedUserInfo(
      BuildContext context, String userId, String token) async {
    String url = 'http://${dotenv.env['SERVER_IP']}:${dotenv.env['SERVER_PORT']}/user/my';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        CommonMethods.showErrorDialog(context, '오류', '인증 오류: 로그인 정보가 유효하지 않습니다.');
        return null;
      } else {
        CommonMethods.showErrorDialog(context, '오류', '사용자 정보를 불러올 수 없습니다.');
        return null;
      }
    } catch (e) {
      CommonMethods.showErrorDialog(context, '오류', '서버와의 연결 오류가 발생했습니다: ${e.toString()}');
      return null;
    }
  }

  Future<void> _getAddress() async {
    try {
      String fetchedAddress = await LocationService().getAddressFromCoordinates(model.latitude, model.longitude);
      model.setAddress(fetchedAddress);
      notifyListeners();
    } catch (e) {
      model.setAddress("주소를 가져올 수 없습니다.");
      notifyListeners();
    }
  }

  Future<void> _findUserLevel(BuildContext context) async {
    String url = 'http://${dotenv.env['SERVER_IP']}:${dotenv.env['SERVER_PORT']}/user/level';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': model.token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        model.setLevel(data['level']);
        model.setCurrentPurchaseCount(data['currentPurchaseCount']);
        model.setNeedPurchaseCount(data['needPurchaseCount']);
      } else {
        CommonMethods.showErrorDialog(context, '오류', '서버에서 오류가 발생했습니다.');
      }
    } catch (e) {
      CommonMethods.showErrorDialog(context, '오류', '서버와의 연결 오류가 발생했습니다.');
    }
  }

  Future<void> _findUserSavingCost(BuildContext context) async {
    String url = 'http://${dotenv.env['SERVER_IP']}:${dotenv.env['SERVER_PORT']}/user/saving';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': model.token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        model.setSavingCost(data['savingCost']);
      } else {
        CommonMethods.showErrorDialog(context, '오류', '서버에서 오류가 발생했습니다.');
      }
    } catch (e) {
      CommonMethods.showErrorDialog(context, '오류', '서버와의 연결 오류가 발생했습니다.');
    }
  }

  String formatCurrency(int amount) {
    final formatter = NumberFormat('#,###');
    return formatter.format(amount);
  }
}