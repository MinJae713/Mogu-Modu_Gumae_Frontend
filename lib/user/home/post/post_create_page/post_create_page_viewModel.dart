import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mogu_app/user/home/post/post_create_page/post_create_page_model.dart';

class PostCreatePageViewModel extends ChangeNotifier {

  late PostCreatePageModel _model;
  PostCreatePageModel get model => _model;
  bool isInitialized = false;

  void initViewModel() {
    _model = PostCreatePageModel(_calculateDiscount);
    _initCurrentLocation().then((value) {
      isInitialized = true;
      notifyListeners();
    });
  }

  Future<void> _initCurrentLocation() async {
    try {
      await _model.locationService.initCurrentLocation();
      notifyListeners();
    } catch (e) {
      print('위치 정보를 초기화하는 중 오류 발생: $e');
    }
  }

  Future<void> submitPost(BuildContext context, Map<String, dynamic> userInfo) async {
    if (_validateInputs()) {
      String url = 'http://${dotenv.env['SERVER_IP']}:${dotenv.env['SERVER_PORT']}/post';
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.headers['Authorization'] = userInfo['token'];

      request.fields['request'] = jsonEncode({
        "title": _model.titleController.text,
        "category": _getCategoryRequestValue(_model.selectedCategory),
        "content": _model.contentController.text,
        "chiefPrice": _model.chiefPrice.replaceAll(RegExp(r'[^\d]'), ''),
        "originalPrice": _model.priceController.text.replaceAll(RegExp(r'[^\d]'), ''),
        "purchaseDate": DateFormat('yyyy-MM-dd').format(_model.selectedDate),
        "purchaseState": (_model.purchaseStatus == '구매 완료').toString(),
        "userCount": _model.personController.text.replaceAll(RegExp(r'[^\d]'), ''),
        "longitude": _model.selectedLocation?.longitude.toString() ?? '0.0',
        "latitude": _model.selectedLocation?.latitude.toString() ?? '0.0',
        "shareCondition": _model.isShareConditionEqual.toString(),
        if (!_model.isShareConditionEqual)
          "perPrice": _model.customPriceController.text.replaceAll(RegExp(r'[^\d]'), ''),
      });

      if (_model.selectedImages.isNotEmpty) {
        for (var image in _model.selectedImages) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'multipartFileList',
              image,
              filename: 'image.png',
              contentType: MediaType('image', 'png'),
            ),
          );
        }
      }

      try {
        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);
        if (response.statusCode == 201) {
          await _showSuccessDialog(context, '성공', '게시글을 성공적으로 등록했습니다.').then((_) {
            Navigator.pop(context, true);
          });
        } else {
          String decodedBody = utf8.decode(response.bodyBytes);
          _showErrorDialog(context, '등록 실패', decodedBody.substring(2, decodedBody.length - 2));
        }
      } catch (e) {
        print('Exception: $e');
        _showErrorDialog(context, '오류', '서버와의 연결 오류가 발생했습니다. 다시 시도해주세요.');
      }
    }
  }

  String _getCategoryRequestValue(String selectedCategory) {
    switch (selectedCategory) {
      case '식료품':
        return 'food';
      case '일회용품':
        return 'disposable';
      case '청소용품':
        return 'cleaning';
      case '뷰티/미용':
        return 'beauty';
      case '취미/게임':
        return 'hobby';
      case '생활/주방':
        return 'life';
      case '육아용품':
        return 'child';
      case '기타':
        return 'other';
      case '무료 나눔':
        return 'free';
      default:
        throw Exception('Invalid Category');
    }
  }

  bool _validateInputs() {
    final originalPrice = int.tryParse(_model.priceController.text.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
    final discountPrice = int.tryParse(_model.chiefPrice.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;

    _model.setTitleValid(_model.titleController.text.isNotEmpty);
    _model.setContentValid(_model.contentController.text.isNotEmpty);
    _model.setPriceValid(_model.priceController.text.isNotEmpty);
    _model.setPersonValid(_model.personController.text.isNotEmpty);
    _model.setCustomPriceValid(_model.isShareConditionEqual || _model.customPriceController.text.isNotEmpty);
    _model.setLocationValid(_model.meetingPlace.isNotEmpty);
    _model.setDiscountValid(originalPrice > discountPrice);
    _model.setDiscountError(originalPrice > 0 && discountPrice > 0 && !_model.isDiscountValid);
    _model.setCustomPriceError(!_model.isShareConditionEqual && !_model.isCustomPriceValid);
    notifyListeners();

    return _model.isTitleValid &&
        _model.isContentValid &&
        _model.isPriceValid &&
        _model.isPersonValid &&
        _model.isLocationValid &&
        (_model.isShareConditionEqual || _model.isCustomPriceValid) &&
        _model.isDiscountValid;
  }

  Future<void> _showSuccessDialog(BuildContext context,
      String title, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
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

  void _calculateDiscount() {
    final priceText = _model.priceController.text.replaceAll(RegExp(r'[^\d]'), '');
    final personText = _model.personController.text.replaceAll(RegExp(r'[^\d]'), '');
    final customPriceText = _model.customPriceController.text.replaceAll(RegExp(r'[^\d]'), '');

    if (priceText.isNotEmpty && personText.isNotEmpty) {
      final price = int.tryParse(priceText) ?? 0;
      final person = int.tryParse(personText) ?? 1;
      final customPrice = int.tryParse(customPriceText) ?? 0;

      if (_model.isShareConditionEqual) {
        final discount = person > 0 ? (price / person).floor() : 0;
        _model.setChiefPrice('${NumberFormat('#,###').format(discount)} 원');
        notifyListeners();
      } else {
        final calculatedDiscount = price - customPrice * (person - 1);
        if (calculatedDiscount >= 0) {
          _model.setChiefPrice('${NumberFormat('#,###').format(calculatedDiscount)} 원');
          notifyListeners();
        } else {
          _model.setChiefPrice('${NumberFormat('#,###').format(customPrice)} 원');
          notifyListeners();
        }
      }
    } else {
      _model.setChiefPrice('0 원');
      notifyListeners();
    }
  }

  Future<void> pickImage(BuildContext context) async {
    if (_model.selectedImages.length >= _model.maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('최대 ${_model.maxImages}개의 이미지만 업로드할 수 있습니다.')),
      );
      return;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      Uint8List fileBytes = await file.readAsBytes();

      _model.selectedImages.add(fileBytes);
      notifyListeners();
    }
  }

  void selectCategory(BuildContext context) async {
    final category = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: [
            ListTile(
              title: Text('식료품'),
              onTap: () => Navigator.pop(context, '식료품'),
            ),
            ListTile(
              title: Text('일회용품'),
              onTap: () => Navigator.pop(context, '일회용품'),
            ),
            ListTile(
              title: Text('청소용품'),
              onTap: () => Navigator.pop(context, '청소용품'),
            ),
            ListTile(
              title: Text('뷰티/미용'),
              onTap: () => Navigator.pop(context, '뷰티/미용'),
            ),
            ListTile(
              title: Text('취미/게임'),
              onTap: () => Navigator.pop(context, '취미/게임'),
            ),
            ListTile(
              title: Text('생활/주방'),
              onTap: () => Navigator.pop(context, '생활/주방'),
            ),
            ListTile(
              title: Text('육아용품'),
              onTap: () => Navigator.pop(context, '육아용품'),
            ),
            ListTile(
              title: Text('기타'),
              onTap: () => Navigator.pop(context, '기타'),
            ),
            ListTile(
              title: Text('무료 나눔'),
              onTap: () => Navigator.pop(context, '무료 나눔'),
            ),
          ],
        );
      },
    );

    if (category != null) {
      _model.setSelectedCategory(category);
      notifyListeners();
    }
  }

  void selectPurchaseStatus(BuildContext context) async {
    final status = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: [
            ListTile(
              title: Text('구매 예정'),
              onTap: () => Navigator.pop(context, '구매 예정'),
            ),
            ListTile(
              title: Text('구매 완료'),
              onTap: () => Navigator.pop(context, '구매 완료'),
            ),
          ],
        );
      },
    );

    if (status != null) {
      _model.setPurchaseStatus(status);
      notifyListeners();
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _model.selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _model.selectedDate) {
      _model.setSelectedDate(picked);
      notifyListeners();
    }
  }

  Future<void> selectLocation(BuildContext context) async {
    final NLatLng? location = await _model.locationService.openMapPage(context);
    if (location != null) {
      String selectedAddress = await _model.locationService.getAddressFromCoordinates(
          location.latitude, location.longitude);
      _model.setMeetingPlace(selectedAddress);
      _model.setMeetingPlaceRoadName(selectedAddress);
      _model.setSelectedLocation(location);
      _model.setLocationValid(true);
      notifyListeners();
    }
  }

  void toggleShareCondition(bool isEqual) {
    // true는 균등, false는 커스텀
    _model.setShareConditionEqual(isEqual);
    _model.setCustomPriceError(false);
    _calculateDiscount();
    notifyListeners();
  }
}