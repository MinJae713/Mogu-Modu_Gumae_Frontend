import 'package:flutter/material.dart';
import '../../../post/post_detail_page.dart';

class MoguHistoryCard extends StatefulWidget {
  final Map<String, dynamic> post;
  final int userUid;
  const MoguHistoryCard({
    super.key,
    required this.post,
    required this.userUid
  });

  @override
  State<StatefulWidget> createState() {
    return _MoguHistoryCard();
  }
}

class _MoguHistoryCard extends State<MoguHistoryCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                PostDetailPage(post: widget.post, userUid: widget.userUid),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.ease;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      },
      splashColor: Colors.purple.withOpacity(0.3),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.image, size: 60, color: Colors.grey),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.post['address'] ?? '주소 정보 없음'),
                        Text(
                          widget.post['title'] ?? '제목 없음',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text('모구가 : ${widget.post['pricePerCount']}원'),
                        Text('참여 인원 ${widget.post['currentUserCount']}/'
                            '${widget.post['userCount']}\n'
                            '모구 마감 ${widget.post['purchaseDate']}'),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '**신청 상태 : 승인',
                  style: TextStyle(color: Colors.purple),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}