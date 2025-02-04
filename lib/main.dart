import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mogu_app/firstStep/loading_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mogu_app/user/home/main_page/chatting_page/chatting_page.dart';
import 'package:mogu_app/user/home/main_page/home_page/home_page.dart';
import 'package:mogu_app/user/home/main_page/mogulist_page/mogulist_page.dart';
import 'package:mogu_app/user/home/main_page/my_page/my_page.dart';

Future<void> main() async {
  await initialize();
  runApp(const MoguApp());
}

Future<void> initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  NaverMapSdk.instance.initialize(
    clientId: dotenv.env['NAVER_MAP_API_KEY'] ?? 'API_KEY_NOT_FOUND',
  );
  await MobileAds.instance.initialize();
}

class MoguApp extends StatelessWidget {
  const MoguApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/user/homeMainPage': (context) => HomeMainPage(),
        '/user/chattingPage': (context) => ChattingPage(),
        '/user/moguListPage': (context) => MoguListPage(),
        '/user/myPage': (context) => MyPage(),
      },
      home: LoadingPage(),
    );
  }
}

