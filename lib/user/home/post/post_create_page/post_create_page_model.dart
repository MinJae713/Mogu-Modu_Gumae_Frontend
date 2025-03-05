
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:intl/intl.dart';

import '../../../../service/location_service.dart';

class PostCreatePageModel {
  final int maxImages = 3;
  final List<Uint8List> selectedImages = [];
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

  final LocationService locationService = LocationService();
  NLatLng? selectedLocation;

  // FocusNodes 추가
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode contentFocusNode = FocusNode();
  final FocusNode priceFocusNode = FocusNode();
  final FocusNode customerPriceFocusNode = FocusNode();
  final FocusNode personFocusNode = FocusNode();
  PostCreatePageModel(VoidCallback calculateDiscount) {
    priceController.addListener(() {
      _updatePrice(calculateDiscount);
    });
    personController.addListener(() {
      _updatePerson(calculateDiscount);
    });
    customPriceController.addListener(() {
      _updateCustomPrice(calculateDiscount);
    });
  }
  void _updatePrice(VoidCallback calculateDiscount) {
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
    calculateDiscount();
  }

  void _updatePerson(VoidCallback calculateDiscount) {
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
    calculateDiscount();
  }

  void _updateCustomPrice(VoidCallback calculateDiscount) {
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
    calculateDiscount();
  }
  bool getShareConditionEqual() {
    return isShareConditionEqual;
  }

  void setCustomPriceError(bool value) {
    showCustomPriceError = value;
  }

  void setDiscountError(bool value) {
    showDiscountError = value;
  }

  void setDiscountValid(bool value) {
    isDiscountValid = value;
  }

  void setLocationValid(bool value) {
    isLocationValid = value;
  }

  void setCustomPriceValid(bool value) {
    isCustomPriceValid = value;
  }

  void setPersonValid(bool value) {
    isPersonValid = value;
  }

  void setPriceValid(bool value) {
    isPriceValid = value;
  }

  void setContentValid(bool value) {
    isContentValid = value;
  }

  void setTitleValid(bool value) {
    isTitleValid = value;
  }

  void setShareConditionEqual(bool value) {
    isShareConditionEqual = value;
  }

  void setPriceControllerValue(TextEditingValue value) {
    priceController.value = value;
  }

  void setPersonControllerValue(TextEditingValue value) {
    personController.value = value;
  }

  void setCustomPriceControllerValue(TextEditingValue value) {
    customPriceController.value = value;
  }

  void setChiefPrice(String chiefPrice) {
    this.chiefPrice = chiefPrice;
  }

  void setSelectedCategory(String selectedCategory) {
    this.selectedCategory = selectedCategory;
  }

  void setPurchaseStatus(String purchaseStatus) {
    this.purchaseStatus = purchaseStatus;
  }

  void setSelectedDate(DateTime selectedDate) {
    this.selectedDate = selectedDate;
  }

  void setMeetingPlace(String meetingPlace) {
    this.meetingPlace = meetingPlace;
  }

  void setMeetingPlaceRoadName(String meetingPlaceRoadName) {
    this.meetingPlaceRoadName = meetingPlaceRoadName;
  }

  void setSelectedLocation(NLatLng selectedLocation) {
    this.selectedLocation = selectedLocation;
  }
}