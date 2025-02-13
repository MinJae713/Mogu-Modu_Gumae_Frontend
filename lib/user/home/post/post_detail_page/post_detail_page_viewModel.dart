import 'package:flutter/material.dart';
import 'package:mogu_app/user/home/post/post_detail_page/post_detail_page_model.dart';

import '../post_report_page/post_report_page.dart';

class PostDetailPageViewModel extends ChangeNotifier {
  PostDetailPageModel? _model;

  PostDetailPageModel? get model => _model;

  void initViewModel(Map<String, dynamic> post) {
    _model = PostDetailPageModel.fromJson(post);
  }

  void toggleHeart() {
    model!.toggleHeart();
    notifyListeners();
  }

  void onParticipateRequest(int userUid) {
    // 참여요청 버튼 눌렀을 때 동작을 여기에 정의합니다.
    print('User UID: ${userUid}'); // userUid를 출력하여 확인
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('게시글 신고하기'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PostReportPage()),
                  );
                },
              ),
              ListTile(
                title: Text('게시글 숨기기'),
                onTap: () {
                  Navigator.pop(context);
                  // 게시글 숨기기 동작 추가
                },
              ),
              ListTile(
                title: Text('취소'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}