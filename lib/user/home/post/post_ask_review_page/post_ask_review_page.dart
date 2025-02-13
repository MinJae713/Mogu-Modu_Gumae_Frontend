import 'package:flutter/material.dart';
import 'package:mogu_app/user/home/post/post_ask_review_page/widgets/request_card.dart';

import '../post_detail_page/post_detail_page.dart';

class PostAskReviewPage extends StatelessWidget {
  const PostAskReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Color(0xFFE9F8FF),
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
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: const [
          RequestCard(
            name: '김찬',
            status: '매너인^^',
            history: 60,
            distance: '1~2km',
            description: '방금 구매한 계란 5개씩 나누실 분...'
          ),
          RequestCard(
            name: '모땡땡',
            status: '매너인^^',
            history: 60,
            distance: '1~2km',
            description: '방금 구매한 계란 5개씩 나누실 분...'
          ),
          RequestCard(
            name: '모땡땡',
            status: '매너인^^',
            history: 60,
            distance: '1~2km',
            description: '방금 구매한 계란 5개씩 나누실 분...'
          ),
        ],
      ),
    );
  }
}