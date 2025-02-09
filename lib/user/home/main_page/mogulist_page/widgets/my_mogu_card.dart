import 'package:flutter/material.dart';
import '../../../post/post_detail_page.dart';

class MyMoguCard extends StatefulWidget {
  final Map<String, dynamic> post;
  final int userUid;
  const MyMoguCard({
    super.key,
    required this.post,
    required this.userUid
  });

  @override
  State<StatefulWidget> createState() {
    return _MyMoguCard();
  }
}

class _MyMoguCard extends State<MyMoguCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => PostDetailPage(post: widget.post, userUid: widget.userUid),
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.image, size: 60, color: Colors.grey),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post['title'] ?? '제목 없음',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('모구가 : ${widget.post['pricePerCount']}원'),
                    Text('모구 마감: ${widget.post['purchaseDate']}'),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text('${widget.post['currentUserCount']}/${widget.post['userCount']}'),
                        SizedBox(width: 8),
                        Stack(
                          clipBehavior: Clip.none,
                          children: const [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.grey,
                            ),
                            Positioned(
                              left: 12,
                              child: CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}