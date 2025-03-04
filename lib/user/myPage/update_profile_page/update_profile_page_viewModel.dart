import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mogu_app/user/myPage/update_profile_page/update_profile_page_model.dart';

import '../../../service/location_service.dart';

class UpdateProfilePageViewModel extends ChangeNotifier {
  late UpdateProfilePageModel _model;
  UpdateProfilePageModel get model => _model;
  bool isInitialized = false;

  void initViewModel(
      String nickname,
      String profileImageUrl,
      double latitude,
      double longitude) {
    _model = UpdateProfilePageModel.from(
      nickname,
      profileImageUrl,
      latitude,
      longitude
    );
    _loadAddress().then((value) {
      isInitialized = true;
      notifyListeners();
    });
  }

  Future<void> _loadAddress() async {
    final address = await LocationService().getAddressFromCoordinates(_model!.latitude, _model!.longitude);
    _model.setAddress(address);
    notifyListeners();
  }

  Future<void> openMapAndSelectLocation(BuildContext context) async {
    final selectedLocation = await LocationService().openMapPage(context);
    if (selectedLocation != null) {
      _model.setLatitude(selectedLocation.latitude);
      _model.setLongitude(selectedLocation.longitude);
      notifyListeners();
      _loadAddress(); // 새 위치에 대한 주소를 로드
    }
  }

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      _model.setNewProfileImage(File(image.path));
      notifyListeners();
    }
  }

  Future<void> updateUser(
      BuildContext context,
      String nickname,
      double latitude,
      double longitude,
      String token) async {
    if (_model.nickname == nickname &&
        _model.newProfileImage == null &&
        _model.latitude == latitude &&
        _model.longitude == longitude) {
      Navigator.pop(context);
      return;
    }

    String url = 'http://${dotenv.env['SERVER_IP']}:${dotenv.env['SERVER_PORT']}/user';
    var request = http.MultipartRequest('PATCH', Uri.parse(url));

    // Authorization 헤더에 토큰 추가
    request.headers['Authorization'] = token;

    // JSON 데이터를 문자열로 변환하여 필드로 추가하고, Content-Type을 application/json으로 설정
    request.fields['request'] = jsonEncode({
      'nickname': _model.nickname,
      'longitude': _model.longitude.toString(),
      'latitude': _model.latitude.toString(),
    });
    request.headers['Content-Type'] = 'application/json';

    // 이미지 파일이 있는 경우 파일 파트로 추가
    if (_model.newProfileImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          _model.newProfileImage!.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // 서버로부터 새로운 프로필 이미지 URL을 받았다고 가정
        final newProfileImageUrl = responseData['profileImageUrl'];
        final newAddress = responseData['address'];

        await _showSuccessDialog('성공', '프로필을 수정하였습니다.', context).then((_) {
          Navigator.pop(context, {
            'nickname': _model.nickname,
            'profileImage': newProfileImageUrl,
            'longitude': _model.longitude,
            'latitude': _model.latitude,
            'address': newAddress,
          });
        });
      } else {
        print('Failed with status code: ${response.statusCode}');
        _showErrorDialog('오류', '서버에서 오류가 발생했습니다. 다시 시도해주세요.', context);
      }
    } catch (e) {
      print('Exception: $e');
      _showErrorDialog('오류', '서버와의 연결 오류가 발생했습니다. 다시 시도해주세요.', context);
    }
  }

  void editNickname(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController(text: _model!.nickname);
        return AlertDialog(
          title: Text('닉네임 변경'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "새 닉네임을 입력하세요"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                _model.setNickname(controller.text);
                notifyListeners();
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSuccessDialog(
      String title, String message,
      BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그를 닫습니다.
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showErrorDialog(
      String title, String message,
      BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그를 닫습니다.
              },
            ),
          ],
        );
      },
    );
  }
}