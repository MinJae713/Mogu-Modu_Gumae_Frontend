import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:mogu_app/service/location_service.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class PostCreatePageViewModel extends ChangeNotifier {
  final int maxImages = 3;
  final List<Uint8List> _selectedImages = [];
  final TextEditingController priceController = TextEditingController();
  final TextEditingController personController = TextEditingController();
  final TextEditingController customPriceController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  String chiefPrice = '0 원';
  String selectedCategory = '식료품';
  String purchaseStatus = '구매 예정';
  DateTime selectedDate = DateTime.now();
  String meetingPlace = '';
  String meetingPlaceRoadName = '';

  bool isShareConditionEqual = true;
  bool isTitleValid = true;
  bool isContentValid = true;
  bool isPriceValid = true;
  bool isPersonValid = true;
  bool isCustomPriceValid = true;
  bool isLocationValid = true;
  bool isDiscountValid = true;
  bool showDiscountError = false;
  bool showCustomPriceError = false;

  final LocationService _locationService = LocationService();
  NLatLng? selectedLocation;

  // FocusNodes 추가
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _contentFocusNode = FocusNode();
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _customerPriceFocusNode = FocusNode();
  final FocusNode _personFocusNode = FocusNode();

  List<Uint8List> get selectedImages => _selectedImages;
  FocusNode get titleFocusNode => _titleFocusNode;
  FocusNode get contentFocusNode => _contentFocusNode;
  FocusNode get priceFocusNode => _priceFocusNode;
  FocusNode get customerPriceFocusNode => _customerPriceFocusNode;
  FocusNode get personFocusNode => _personFocusNode;

  void initViewModel() {
    priceController.addListener(_updatePrice);
    personController.addListener(_updatePerson);
    customPriceController.addListener(_updateCustomPrice);
    _initCurrentLocation();
  }

  Future<void> _initCurrentLocation() async {
    try {
      await _locationService.initCurrentLocation();
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
        "title": titleController.text,
        "category": _getCategoryRequestValue(selectedCategory),
        "content": contentController.text,
        "chiefPrice": chiefPrice.replaceAll(RegExp(r'[^\d]'), ''),
        "originalPrice": priceController.text.replaceAll(RegExp(r'[^\d]'), ''),
        "purchaseDate": DateFormat('yyyy-MM-dd').format(selectedDate),
        "purchaseState": (purchaseStatus == '구매 완료').toString(),
        "userCount": personController.text.replaceAll(RegExp(r'[^\d]'), ''),
        "longitude": selectedLocation?.longitude.toString() ?? '0.0',
        "latitude": selectedLocation?.latitude.toString() ?? '0.0',
        "shareCondition": isShareConditionEqual.toString(),
        if (!isShareConditionEqual)
          "perPrice": customPriceController.text.replaceAll(RegExp(r'[^\d]'), ''),
      });

      if (_selectedImages.isNotEmpty) {
        for (var image in _selectedImages) {
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
    final originalPrice = int.tryParse(priceController.text.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
    final discountPrice = int.tryParse(chiefPrice.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;

    isTitleValid = titleController.text.isNotEmpty;
    isContentValid = contentController.text.isNotEmpty;
    isPriceValid = priceController.text.isNotEmpty;
    isPersonValid = personController.text.isNotEmpty;
    isCustomPriceValid = isShareConditionEqual || customPriceController.text.isNotEmpty;
    isLocationValid = meetingPlace.isNotEmpty;
    isDiscountValid = originalPrice > discountPrice;
    showDiscountError = originalPrice > 0 && discountPrice > 0 && !isDiscountValid;
    showCustomPriceError = !isShareConditionEqual && !isCustomPriceValid;
    notifyListeners();

    return isTitleValid &&
        isContentValid &&
        isPriceValid &&
        isPersonValid &&
        isLocationValid &&
        (isShareConditionEqual || isCustomPriceValid) &&
        isDiscountValid;
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

  void _updatePrice() {
    final text = priceController.text.replaceAll(RegExp(r'[^\d]'), '');
    if (text.isNotEmpty) {
      priceController.value = priceController.value.copyWith(
        text: '${NumberFormat('#,###').format(int.parse(text))} 원',
        selection: TextSelection.collapsed(offset: priceController.text.length - 2),
      );
    } else {
      priceController.value = priceController.value.copyWith(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }
    _calculateDiscount();
  }

  void _updatePerson() {
    final text = personController.text.replaceAll(RegExp(r'[^\d]'), '');
    if (text.isNotEmpty) {
      personController.value = personController.value.copyWith(
        text: '$text 명',
        selection: TextSelection.collapsed(offset: personController.text.length - 2),
      );
    } else {
      personController.value = personController.value.copyWith(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }
    _calculateDiscount();
  }

  void _updateCustomPrice() {
    final text = customPriceController.text.replaceAll(RegExp(r'[^\d]'), '');
    if (text.isNotEmpty) {
      customPriceController.value = customPriceController.value.copyWith(
        text: '${NumberFormat('#,###').format(int.parse(text))} 원',
        selection: TextSelection.collapsed(offset: customPriceController.text.length - 2),
      );
    } else {
      customPriceController.value = customPriceController.value.copyWith(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }
    _calculateDiscount();
  }

  void _calculateDiscount() {
    final priceText = priceController.text.replaceAll(RegExp(r'[^\d]'), '');
    final personText = personController.text.replaceAll(RegExp(r'[^\d]'), '');
    final customPriceText = customPriceController.text.replaceAll(RegExp(r'[^\d]'), '');

    if (priceText.isNotEmpty && personText.isNotEmpty) {
      final price = int.tryParse(priceText) ?? 0;
      final person = int.tryParse(personText) ?? 1;
      final customPrice = int.tryParse(customPriceText) ?? 0;

      if (isShareConditionEqual) {
        final discount = person > 0 ? (price / person).floor() : 0;
        chiefPrice = '${NumberFormat('#,###').format(discount)} 원';
        notifyListeners();
      } else {
        final calculatedDiscount = price - customPrice * (person - 1);
        if (calculatedDiscount >= 0) {
          chiefPrice = '${NumberFormat('#,###').format(calculatedDiscount)} 원';
          notifyListeners();
        } else {
          chiefPrice = '${NumberFormat('#,###').format(customPrice)} 원';
          notifyListeners();
        }
      }
    } else {
      chiefPrice = '0 원';
      notifyListeners();
    }
  }

  Future<void> pickImage(BuildContext context) async {
    if (_selectedImages.length >= maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('최대 $maxImages개의 이미지만 업로드할 수 있습니다.')),
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

      _selectedImages.add(fileBytes);
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
      selectedCategory = category;
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
      purchaseStatus = status;
      notifyListeners();
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      notifyListeners();
    }
  }

  Future<void> selectLocation(BuildContext context) async {
    final NLatLng? location = await _locationService.openMapPage(context);
    if (location != null) {
      String selectedAddress = await _locationService.getAddressFromCoordinates(
          location.latitude, location.longitude);
      meetingPlace = selectedAddress;
      meetingPlaceRoadName = selectedAddress;
      selectedLocation = location;
      isLocationValid = true;
      notifyListeners();
    }
  }

  void toggleShareCondition(bool isEqual) {
    // true는 균등, false는 커스텀
    isShareConditionEqual = isEqual;
    showCustomPriceError = false;
    _calculateDiscount();
    notifyListeners();
  }
  bool getShareConditionEqual() {
    return isShareConditionEqual;
  }
}