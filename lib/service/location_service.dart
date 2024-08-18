import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LocationService {
  NaverMapController? _mapController;
  NLatLng? currentPosition;
  NLatLng? selectedPosition;

  Future<NLatLng> initCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied');
      throw Exception('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    currentPosition = NLatLng(position.latitude, position.longitude);
    return currentPosition!;
  }

  // 위치 정보를 가지고 네이버 지도를 이동
  Future<void> moveToLocation(NaverMapController controller, double latitude, double longitude) async {
    NCameraUpdate cameraUpdate = NCameraUpdate.fromCameraPosition(
        NCameraPosition(target: NLatLng(latitude, longitude), zoom: 15)
    );
    await controller.updateCamera(cameraUpdate);
  }

  // 좌표를 도로명 주소로 변환
  Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
    String apiKey = dotenv.env['VWORLD_API_KEY'] ?? 'API_KEY_NOT_FOUND';

    for (int precision = 6; precision >= 3; precision--) {
      String address = await _tryGetAddress(latitude, longitude, apiKey, precision);
      if (address.isNotEmpty && address != '알 수 없는 위치') {
        return address;
      }
    }

    // 소수점 3자리에서 0.001씩 추가하며 검색
    for (int i = 0; i < 10; i++) {
      String address = await _tryGetAddress(latitude, longitude, apiKey, 3);
      if (address.isNotEmpty && address != '알 수 없는 위치') {
        return address;
      }

      latitude += 0.001;
      longitude += 0.001;
    }

    return '알 수 없는 위치';
  }

  // 지정된 소수점 이하 자리수로 좌표를 줄이고, 주소 검색을 시도하는 내부 함수
  Future<String> _tryGetAddress(double latitude, double longitude, String apiKey, int precision) async {
    String baseUrl =
        'https://api.vworld.kr/req/address?service=address&request=getAddress&key=$apiKey&point=';

    latitude = truncateCoordinate(latitude, precision: precision);
    longitude = truncateCoordinate(longitude, precision: precision);

    String url = '$baseUrl$longitude,$latitude&type=ROAD';
    print('Sending request to: $url');

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['response'] != null && jsonResponse['response']['status'] == 'OK') {
          var results = jsonResponse['response']['result'];
          if (results != null && results.isNotEmpty) {
            var address = results[0]['text'];
            print('Address found: $address');
            return address;
          }
        }
      }
    } catch (e) {
      print('Exception caught: $e');
      return '네트워크 오류가 발생했습니다';
    }

    return '알 수 없는 위치';
  }

  // 좌표 값을 지정된 소수점 이하 자리수로 줄이는 함수
  double truncateCoordinate(double coord, {int precision = 3}) {
    double mod = pow(10.0, precision).toDouble();
    return ((coord * mod).round().toDouble() / mod);
  }

  // 지도 페이지를 생성하는 메서드
  Future<NLatLng?> openMapPage(BuildContext context) async {
    // 현재 위치 초기화
    await initCurrentLocation();

    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('위치 선택'),
          ),
          body: NaverMap(
            onMapReady: (controller) async {
              _mapController = controller;

              if (currentPosition != null) {
                await moveToLocation(_mapController!, currentPosition!.latitude, currentPosition!.longitude);

                final marker = NMarker(id: 'currentPosition_marker', position: currentPosition!);
                final onMarkerInfoWindow = NInfoWindow.onMarker(id: 'currentPosition_marker_info', text: "내 위치");
                _mapController!.addOverlay(marker);
                marker.openInfoWindow(onMarkerInfoWindow);
              } else {
                print('Current position is null');
              }
            },
            onMapTapped: (point, latLng) {
              selectedPosition = latLng;
              Navigator.pop(context, latLng);
            },
            onSymbolTapped: (symbol) {
              selectedPosition = symbol.position;
              Navigator.pop(context, symbol.position);
            },
          ),
        ),
      ),
    );
  }
}