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

class PostCreatePage extends StatefulWidget {
  final Map<String, dynamic> userInfo;

  const PostCreatePage({super.key, required this.userInfo});

  @override
  _PostCreatePageState createState() => _PostCreatePageState();
}

class _PostCreatePageState extends State<PostCreatePage> {
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

  @override
  void initState() {
    super.initState();
    priceController.addListener(_updatePrice);
    personController.addListener(_updatePerson);
    customPriceController.addListener(_updateCustomPrice);
    _initCurrentLocation();
  }

  Future<void> _initCurrentLocation() async {
    try {
      await _locationService.initCurrentLocation();
      setState(() {});
    } catch (e) {
      print('위치 정보를 초기화하는 중 오류 발생: $e');
    }
  }

  Future<void> _submitPost(BuildContext context) async {
    if (_validateInputs()) {
      String url = 'http://${dotenv.env['SERVER_IP']}:${dotenv.env['SERVER_PORT']}/post/${widget.userInfo['userId']}';
      var request = http.MultipartRequest('POST', Uri.parse(url));

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

      print(request.fields);
      print(request.files);
      try {
        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);
        if (response.statusCode == 201) {
          final responseData = jsonDecode(response.body);

          await _showSuccessDialog('성공', '게시글을 성공적으로 등록했습니다.').then((_) {
            Navigator.pop(context, responseData);
          });
        } else {
          print(response.body);
          print('Failed with status code: ${response.statusCode}');
          _showErrorDialog('등록 실패', '서버에서 오류가 발생했습니다.');
        }
      } catch (e) {
        print('Exception: $e');
        _showErrorDialog('오류', '서버와의 연결 오류가 발생했습니다. 다시 시도해주세요.');
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

    setState(() {
      isTitleValid = titleController.text.isNotEmpty;
      isContentValid = contentController.text.isNotEmpty;
      isPriceValid = priceController.text.isNotEmpty;
      isPersonValid = personController.text.isNotEmpty;
      isCustomPriceValid = isShareConditionEqual || customPriceController.text.isNotEmpty;
      isLocationValid = meetingPlace.isNotEmpty;
      isDiscountValid = originalPrice > discountPrice;
      showDiscountError = originalPrice > 0 && discountPrice > 0 && !isDiscountValid;
      showCustomPriceError = !isShareConditionEqual && !isCustomPriceValid; // 커스텀 가격 오류 메시지를 등록할 때만 표시
    });

    return isTitleValid &&
        isContentValid &&
        isPriceValid &&
        isPersonValid &&
        isLocationValid &&
        (isShareConditionEqual || isCustomPriceValid) &&
        isDiscountValid;
  }

  Future<void> _showSuccessDialog(String title, String message) async {
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
        setState(() {
          chiefPrice = '${NumberFormat('#,###').format(discount)} 원';
        });
      } else {
        final calculatedDiscount = price - customPrice * (person - 1);
        if (calculatedDiscount >= 0) {
          setState(() {
            chiefPrice = '${NumberFormat('#,###').format(calculatedDiscount)} 원';
          });
        } else {
          setState(() {
            chiefPrice = '${NumberFormat('#,###').format(customPrice)} 원';
          });
        }
      }
    } else {
      setState(() {
        chiefPrice = '0 원';
      });
    }
  }

  Future<void> _pickImage() async {
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

      setState(() {
        _selectedImages.add(fileBytes);
      });
    }
  }

  void _selectCategory() async {
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
      setState(() {
        selectedCategory = category;
      });
    }
  }

  void _selectPurchaseStatus() async {
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
      setState(() {
        purchaseStatus = status;
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectLocation() async {
    final NLatLng? location = await _locationService.openMapPage(context);
    if (location != null) {
      String selectedAddress = await _locationService.getAddressFromCoordinates(
          location.latitude, location.longitude);
      setState(() {
        meetingPlace = selectedAddress;
        meetingPlaceRoadName = selectedAddress;
        selectedLocation = location;
        isLocationValid = true; // 위치가 선택되었으므로 유효성 검사를 통과
      });
    }
  }

  void _toggleShareCondition(bool isEqual) {
    setState(() {
      isShareConditionEqual = isEqual;
      showCustomPriceError = false; // 상태 변경 시 오류 메시지를 숨김
      _calculateDiscount();
    });
  }

  Widget _buildShareConditionRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '분배 방식',
            style: TextStyle(fontSize: 16),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => _toggleShareCondition(true),
                child: Row(
                  children: [
                    Icon(
                      isShareConditionEqual ? Icons.check_box : Icons.check_box_outline_blank,
                      color: Color(0xFFB34FD1),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '균등',
                      style: TextStyle(fontSize: 16, color: Color(0xFFB34FD1)),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              GestureDetector(
                onTap: () => _toggleShareCondition(false),
                child: Row(
                  children: [
                    Icon(
                      !isShareConditionEqual ? Icons.check_box : Icons.check_box_outline_blank,
                      color: Color(0xFFB34FD1),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '커스텀',
                      style: TextStyle(fontSize: 16, color: Color(0xFFB34FD1)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          color: Color(0xFFFFD3F0),
          onPressed: () {
            Navigator.pop(context);
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '제목',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    errorText: isTitleValid ? null : "제목을 입력하세요",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFB34FD1)),
                    ),
                  ),
                  cursorColor: Color(0xFFB34FD1),
                ),
              ],
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '내용',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: contentController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    errorText: isContentValid ? null : "내용을 입력하세요",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFB34FD1)),
                    ),
                  ),
                  cursorColor: Color(0xFFB34FD1),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text('사진등록', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt, size: 40),
                        SizedBox(height: 4),
                        Text('${_selectedImages.length}/$maxImages'),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _selectedImages
                          .map((imageData) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.memory(
                            imageData,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildDetailRow('상품 카테고리', selectedCategory, _selectCategory),
            _buildDetailRow('상품 구매', purchaseStatus, _selectPurchaseStatus),
            _buildDetailRow('마감 기한',
                DateFormat('yyyy/MM/dd').format(selectedDate), _selectDate),
            _buildPriceInputRow('상품 구매 가격', priceController),
            if (!isPriceValid)
              Row(
                children: [
                  Expanded(child: Container()), // To push the error text to the right
                  Text(
                    "가격을 입력하세요",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ],
              ),
            _buildPersonInputRow('모구 인원', personController),
            if (!isPersonValid)
              Row(
                children: [
                  Expanded(child: Container()), // To push the error text to the right
                  Text(
                    "인원을 입력하세요",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ],
              ),
            _buildShareConditionRow(),
            if (!isShareConditionEqual)
              _buildPriceInputRow('인당 가격 설정', customPriceController),
            if (!isCustomPriceValid && showCustomPriceError)
              Row(
                children: [
                  Expanded(child: Container()), // To push the error text to the right
                  Text(
                    "인당 가격을 입력하세요",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ],
              ),
            _buildDetailRow('할인된 가격', chiefPrice, null, false),
            if (showDiscountError)
              Row(
                children: [
                  Expanded(child: Container()), // To push the error text to the right
                  Text(
                    "할인된 가격은 상품 구매 가격보다 낮아야 합니다",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ],
              ),
            _buildDetailRow('모임 장소', meetingPlace.isNotEmpty ? meetingPlace : "구매를 위한 모임 장소", _selectLocation),
            if (!isLocationValid)
              Row(
                children: [
                  Expanded(child: Container()), // To push the error text to the right
                  Text(
                    "모임 장소를 설정하세요",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ],
              ),
            SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () => _submitPost(context), // 여기에 context를 전달
          child: Container(
            width: double.infinity,
            height: 70,
            padding: const EdgeInsets.only(top: 9, left: 11, right: 12, bottom: 9),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                    color: Color(0x14737373),
                    blurRadius: 4,
                    offset: Offset(0, -4),
                    spreadRadius: 0),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Material(
                    color: Color(0xFFB34FD1),
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => _submitPost(context), // 여기에 context를 전달
                      child: Container(
                        height: double.infinity,
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: Text(
                            '등록하기',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value,
      [VoidCallback? onTap, bool showArrow = true]) {
    IconData? icon = showArrow && onTap != null ? Icons.arrow_drop_down : null;

    if (title == '모임 장소') {
      icon = Icons.place;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                if (icon != null && title == '모임 장소')
                  Icon(
                    icon,
                    color: Color(0xFFB34FD1),
                  ),
                if (title == '모임 장소')
                  SizedBox(width: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFB34FD1),
                  ),
                ),
                if (icon != null && title != '모임 장소')
                  Icon(
                    icon,
                    color: Color(0xFFB34FD1),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceInputRow(String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            width: 150,
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: '0 원',
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFB34FD1)),
                ),
              ),
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: Color(0xFFB34FD1),
                  fontSize: 16),
              cursorColor: Color(0xFFB34FD1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonInputRow(String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            width: 150,
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter.allow(RegExp(r'^[1-9]\d*$')),
              ],
              decoration: InputDecoration(
                hintText: '0 명',
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFB34FD1)),
                ),
              ),
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: Color(0xFFB34FD1),
                  fontSize: 16),
              cursorColor: Color(0xFFB34FD1),
            ),
          ),
        ],
      ),
    );
  }
}