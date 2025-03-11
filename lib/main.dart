import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mogu_app/admin/home/main_page/complaint_management_page/complaint_management_page.dart';
import 'package:mogu_app/admin/home/main_page/home_page/home_page_FA.dart';
import 'package:mogu_app/admin/home/main_page/member_management_page/member_management_page.dart';
import 'package:mogu_app/intro/loading_page/loading_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mogu_app/intro/loading_page/loading_page_viewModel.dart';
import 'package:mogu_app/user/chat/chat_room_page_viewModel.dart';
import 'package:mogu_app/user/home/main_page/chatting_page/chatting_page.dart';
import 'package:mogu_app/user/home/main_page/chatting_page/chatting_page_viewModel.dart';
import 'package:mogu_app/user/home/main_page/home_page/home_page.dart';
import 'package:mogu_app/user/home/main_page/home_page/home_page_viewModel.dart';
import 'package:mogu_app/user/home/main_page/mogulist_page/mogulist_page.dart';
import 'package:mogu_app/user/home/main_page/mogulist_page/mogulist_page_viewModel.dart';
import 'package:mogu_app/user/home/main_page/my_page/my_page.dart';
import 'package:mogu_app/user/home/main_page/my_page/my_page_viewModel.dart';
import 'package:mogu_app/user/home/notification_page/notification_page_viewModel.dart';
import 'package:mogu_app/user/home/post/post_create_page/post_create_page_viewModel.dart';
import 'package:mogu_app/user/home/post/post_detail_page/post_detail_page_viewModel.dart';
import 'package:mogu_app/user/home/post/post_report_page/post_report_page_viewModel.dart';
import 'package:mogu_app/user/myPage/account_management_page/account_management_page_viewModel.dart';
import 'package:mogu_app/user/myPage/update_profile_page/update_profile_page_viewModel.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await initialize();
  // runApp(const MoguApp());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LoadingPageViewModel()
        ),
        ChangeNotifierProvider(
          create: (context) => ChatRoomPageViewModel()
        ),
        ChangeNotifierProvider(
          create: (context) => AccountManagementPageViewModel()
        ),
        ChangeNotifierProvider(
          create: (context) => PostReportPageViewModel()
        ),
        ChangeNotifierProvider(
          create: (context) => PostDetailPageViewModel()
        ),
        ChangeNotifierProvider(
          create: (context) => PostCreatePageViewModel()
        ),
        ChangeNotifierProvider(
          create: (context) => PostCreatePageViewModel()
        ),
        ChangeNotifierProvider(
          create: (context) => NotificationPageViewModel()
        ),
        ChangeNotifierProvider(
          create: (context) => MyPageViewModel()
        ),
        ChangeNotifierProvider(
          create: (context) => MoguListPageViewModel()
        ),
        ChangeNotifierProvider(
          create: (context) => ChattingPageViewModel()
        ),
        ChangeNotifierProvider(
          create: (context) => UpdateProfilePageViewModel()
        ),
        ChangeNotifierProvider(
          create: (context) => HomeMainPageViewModel()
        ),
      ],
      child: const MoguApp(),
    ));
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
        // '/user/homeMainPage': (context) => HomePage(),
        // '/user/chattingPage': (context) => ChattingPage(),
        // '/user/moguListPage': (context) => MoguListPage(),
        // '/user/myPage': (context) => MyPage(),
        // '/admin/homeMainPageFA': (context) => HomeMainPageFA(),
        // '/admin/memberManagementPage': (context) => MemberManagementPage(),
        // '/admin/complaintManagementPage': (context) => ComplaintManagementPage()
      },
      home: LoadingPage(),
    );
  }
}

