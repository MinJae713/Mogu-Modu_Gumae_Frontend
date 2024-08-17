import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
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

  String discountPrice = '0 원';
  String selectedCategory = '식료품';
  String purchaseStatus = '구매 예정';
  DateTime selectedDate = DateTime.now();
  String meetingPlace = '구매를 위해 모일 장소';

  bool isShareConditionEqual = true;

  final LocationService _locationService = LocationService(); // LocationService 인스턴스 생성
  NaverMapController? _mapController;
  NLatLng? currentPosition;

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
      currentPosition = await _locationService.initCurrentLocation();
      setState(() {}); // 위치 정보 업데이트
    } catch (e) {
      print('위치 정보를 초기화하는 중 오류 발생: $e');
    }
  }

  void _updatePrice() {
    final text = priceController.text.replaceAll(RegExp(r'[^\d]'), '');
    if (text.isNotEmpty) {
      priceController.value = priceController.value.copyWith(
        text: NumberFormat('#,###').format(int.parse(text)) + ' 원',
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
        text: NumberFormat('#,###').format(int.parse(text)) + ' 원',
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
          discountPrice = '${NumberFormat('#,###').format(discount)} 원';
        });
      } else {
        final calculatedDiscount = price - customPrice * (person - 1);
        if (calculatedDiscount >= 0) {
          setState(() {
            discountPrice = '${NumberFormat('#,###').format(calculatedDiscount)} 원';
          });
        } else {
          setState(() {
            discountPrice = '${NumberFormat('#,###').format(customPrice)} 원';
          });
        }
      }
    } else {
      setState(() {
        discountPrice = '0 원';
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
    final NLatLng? selectedLocation = await _locationService.openMapPage(context);
    if (selectedLocation != null) {
      String currentAddress = await _locationService.getAddressFromCoordinates(
          selectedLocation.latitude, selectedLocation.longitude);
      setState(() {
        meetingPlace = currentAddress;
      });
    }
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

  void _toggleShareCondition(bool isEqual) {
    setState(() {
      isShareConditionEqual = isEqual;
      _calculateDiscount();
    });
  }

  Future<void> _submitPost() async {
    final url = 'http://10.0.2.2:8080/post/${widget.userInfo['userId']}';
    final headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer ${widget.userInfo['token']}',
    };

    final request = http.MultipartRequest('POST', Uri.parse(url))
      ..headers.addAll(headers)
      ..fields['request'] = jsonEncode({
        "title": "abcdefg",
        "category": selectedCategory,
        "content": "1234",
        "discountPrice": discountPrice.replaceAll(RegExp(r'[^\d]'), ''),
        "originalPrice": priceController.text.replaceAll(RegExp(r'[^\d]'), ''),
        "purchaseDate": DateFormat('yyyy-MM-dd').format(selectedDate),
        "purchaseState": purchaseStatus == '구매 완료' ? 'true' : 'false',
        "userCount": personController.text.replaceAll(RegExp(r'[^\d]'), ''),
        "longitude": currentPosition?.longitude.toString() ?? '',
        "latitude": currentPosition?.latitude.toString() ?? '',
        "shareCondition": isShareConditionEqual.toString(),
        if (!isShareConditionEqual)
          "pricePerCount": customPriceController.text.replaceAll(RegExp(r'[^\d]'), ''),
      });

    if (_selectedImages.isNotEmpty) {
      for (var image in _selectedImages) {
        request.files.add(http.MultipartFile.fromBytes(
          'multipartFileList',
          image,
          filename: 'image.png',
          contentType: MediaType('image', 'png'),
        ));
      }
    }

    final response = await request.send();

    if (response.statusCode == 201) {
      _showSuccessDialog();
    } else {
      _showErrorDialog('등록 실패', '서버에서 오류가 발생했습니다.');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('성공'),
          content: Text('게시글을 성공적으로 등록했습니다.'),
          actions: [
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
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
          actions: [
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
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
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
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
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
            _buildPersonInputRow('모구 인원', personController),
            _buildShareConditionRow(),
            if (!isShareConditionEqual)
              _buildPriceInputRow('인당 가격 설정', customPriceController),
            _buildDetailRow('할인된 가격', discountPrice, null, false),
            _buildDetailRow('모임 장소', meetingPlace, _selectLocation),
            SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: Material(
        color: Colors.white,
        child: InkWell(
          onTap: _submitPost,
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
                  spreadRadius: 0,
                ),
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
                      onTap: _submitPost,
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
                              fontWeight: FontWeight.w500,
                            ),
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
                  SizedBox(width: 4), // Add space between icon and text
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

  Widget _buildPriceInputRow(
      String title, TextEditingController controller) {
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
              ),
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color(0xFFB34FD1),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonInputRow(
      String title, TextEditingController controller) {
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
              ),
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color(0xFFB34FD1),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
