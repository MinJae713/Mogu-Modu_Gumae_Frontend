import 'package:flutter/material.dart';

class PostReportPageViewModel extends ChangeNotifier {
  String? _selectedReportType; // 선택된 신고 유형을 저장하는 변수
  String? getSelectedReportType() {
    return _selectedReportType;
  }
  void setSelectedReportType(String value) {
    _selectedReportType = value;
    notifyListeners();
  }
}