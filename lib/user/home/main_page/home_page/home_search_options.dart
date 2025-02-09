import 'package:flutter/material.dart';

import 'widgets/home_toggle_button.dart';

class HomeSearchOptions {
  final Function applySearchOptions;
  double _currentDistanceValue = 2.0;
  String _selectedRecruitmentStatus = '모집중';
  String _selectedPurchaseRoute = '오프라인';
  String _selectedPurchaseStatus = '미구입';
  HomeSearchOptions({required this.applySearchOptions});

  void showSearchOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '검색 옵션',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text('나와의 거리'),
                  Slider(
                    value: _currentDistanceValue,
                    min: 0.5,  // 500미터를 기본값으로 설정
                    max: 3,    // 최대 거리를 3km로 설정
                    divisions: 5,  // 500미터 단위로 슬라이더 구분
                    label: '${_currentDistanceValue.toStringAsFixed(1)} km',
                    onChanged: (value) {
                      setModalState(() {
                        _currentDistanceValue = value;
                      });
                    },
                    activeColor: Color(0xFFB34FD1),
                    inactiveColor: Colors.grey,
                  ),
                  Text(
                    '~ ${_currentDistanceValue.toStringAsFixed(1)} km',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  HomeToggleButton(
                    label: '모집 상태',
                    option1: '모집중',
                    option2: '마감',
                    selectedValue: _selectedRecruitmentStatus,
                    onChanged: (newValue) {
                      setModalState(() {
                        _selectedRecruitmentStatus = newValue;
                      });
                    }
                  ),
                  SizedBox(height: 16),
                  HomeToggleButton(
                    label: '구매 경로',
                    option1: '오프라인',
                    option2: '온라인',
                    selectedValue: _selectedPurchaseRoute,
                    onChanged: (newValue) {
                      setModalState(() {
                        _selectedPurchaseRoute = newValue;
                      });
                    }
                  ),
                  SizedBox(height: 16),
                  HomeToggleButton(
                    label: '구매 상태',
                    option1: '미구입',
                    option2: '구입완료',
                    selectedValue: _selectedPurchaseStatus,
                    onChanged: (newValue) {
                      setModalState(() {
                        _selectedPurchaseStatus = newValue;
                      });
                    }
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey,
                          backgroundColor: Colors.grey.shade200,
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('초기화'),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Map<String, dynamic> options = {
                              'currentDistanceValue': _currentDistanceValue,
                              'selectedRecruitmentStatus': _selectedRecruitmentStatus,
                              'selectedPurchaseRoute': _selectedPurchaseRoute,
                              'selectedPurchaseStatus': _selectedPurchaseStatus
                            };
                            applySearchOptions(options);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Color(0xFFB34FD1),
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text('적용하기'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}