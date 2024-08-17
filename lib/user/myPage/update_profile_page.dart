import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../service/location_service.dart';

class UpdateProfilePage extends StatefulWidget {
  final String userId;
  final String nickname;
  final String profileImage;
  final double longitude;
  final double latitude;
  final String token;

  const UpdateProfilePage({
    super.key,
    required this.userId,
    required this.nickname,
    required this.profileImage,
    required this.longitude,
    required this.latitude,
    required this.token,
  });

  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  late String _nickname;
  late String _profileImageUrl;
  String? _address;
  late double _latitude;
  late double _longitude;
  File? _newProfileImage;

  @override
  void initState() {
    super.initState();
    _nickname = widget.nickname;
    _profileImageUrl = widget.profileImage;
    _latitude = widget.latitude;
    _longitude = widget.longitude;
    _loadAddress();
  }

  Future<void> _loadAddress() async {
    final address = await LocationService().getAddressFromCoordinates(_latitude, _longitude);
    setState(() {
      _address = address;
    });
  }

  Future<void> _openMapAndSelectLocation() async {
    final selectedLocation = await LocationService().openMapPage(context);
    if (selectedLocation != null) {
      setState(() {
        _latitude = selectedLocation.latitude;
        _longitude = selectedLocation.longitude;
      });
      _loadAddress(); // 새 위치에 대한 주소를 로드
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _newProfileImage = File(image.path);
      });
    }
  }

  Future<void> updateUserPassword(context) async {
    // 서버의 엔드포인트 URL을 정의합니다.
    final String url = 'http://10.0.2.2:8080/user/${widget.userId}/password';

    // 요청에 포함될 데이터(Map)를 생성합니다.
    final Map<String, String> requestData = {
      'password': "123123123",
    };

    // 요청 헤더를 정의합니다. JSON 형식을 사용한다고 설정합니다.
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    try {
      // PATCH 요청을 보냅니다.
      final http.Response response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(requestData),
      );

      // 서버 응답을 처리합니다.
      if (response.statusCode == 200) {
        print('Password updated successfully');
        // 성공적으로 업데이트된 경우 처리 로직을 여기에 추가합니다.
      } else {
        print('Failed to update password: ${response.statusCode}');
        // 실패한 경우 처리 로직을 여기에 추가합니다.
      }
    } catch (e) {
      print('Exception occurred: $e');
      // 예외 발생 시 처리 로직을 여기에 추가합니다.
    }
  }

  Future<void> _updateUser(BuildContext context) async {
    if (_nickname == widget.nickname &&
        _newProfileImage == null &&
        _latitude == widget.latitude &&
        _longitude == widget.longitude) {
      Navigator.pop(context);
      return;
    }

    String url = 'http://10.0.2.2:8080/user/${widget.userId}';
    var request = http.MultipartRequest('PATCH', Uri.parse(url));

    // JSON 데이터를 문자열로 변환하여 필드로 추가하고, Content-Type을 application/json으로 설정
    request.fields['request'] = jsonEncode({
      'nickname': _nickname,
      'longitude': _longitude.toString(),
      'latitude': _latitude.toString(),
    });
    request.headers['Content-Type'] = 'application/json';

    // 이미지 파일이 있는 경우 파일 파트로 추가
    if (_newProfileImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          _newProfileImage!.path,
          contentType: MediaType('image', 'jpeg'), // 파일은 기본적으로 multipart/form-data로 처리됨
        ),
      );
    }

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        await _showSuccessDialog('성공', '프로필을 수정하였습니다.').then((_) {
          Navigator.pop(context);
        });
      } else {
        print('Failed with status code: ${response.statusCode}');
        _showErrorDialog('오류', '서버에서 오류가 발생했습니다. 다시 시도해주세요.');
      }
    } catch (e) {
      print('Exception: $e');
      _showErrorDialog('오류', '서버와의 연결 오류가 발생했습니다. 다시 시도해주세요.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          color: Color(0xFFFFE9F8),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '프로필 수정',
          style: TextStyle(
            color: Color(0xFFFFE9F8),
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
              colors: const [Color(0xFFFFA7E1), Color(0xB29322CC)],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _address == null
            ? Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        color: Color(0xFFB34FD1),
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: _newProfileImage != null
                            ? FileImage(_newProfileImage!)
                            : (_profileImageUrl.isNotEmpty
                            ? NetworkImage(_profileImageUrl) as ImageProvider
                            : null),
                        child: _profileImageUrl.isEmpty && _newProfileImage == null
                            ? Icon(Icons.camera_alt, size: 40, color: Colors.white)
                            : null,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.edit,
                            size: 18,
                            color: Color(0xFFB34FD1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _editNickname();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                _nickname,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.edit,
                            color: Color(0xFFB34FD1),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: TextEditingController(text: _address),
              readOnly: true,
              decoration: InputDecoration(
                labelText: '주소',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.edit_location, color: Color(0xFFB34FD1)),
                  onPressed: _openMapAndSelectLocation,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // updateUserPassword(context);
                _updateUser(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 40),
                foregroundColor: Colors.black,
                backgroundColor: Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Text('수정 완료'),
            ),
          ],
        ),
      ),
    );
  }

  void _editNickname() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController(text: _nickname);
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
                setState(() {
                  _nickname = controller.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSuccessDialog(String title, String message) {
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

  Future<void> _showErrorDialog(String title, String message) {
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