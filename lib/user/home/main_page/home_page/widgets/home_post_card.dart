import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../post/post_detail_page.dart';

class HomePostCard extends StatefulWidget {
  final Map<String, dynamic> post;
  final int userUid;
  const HomePostCard({super.key, required this.post, required this.userUid});

  @override
  State<StatefulWidget> createState() {
    return _HomePostCard();
  }
}

class _HomePostCard extends State<HomePostCard> {
  int heartCount = 0;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    heartCount = widget.post['heartCount'];
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
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
          splashColor: Color(0xFFB34FD1).withOpacity(0.2),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: (widget.post['userProfiles'] is List && (widget.post['userProfiles'] as List).isNotEmpty)
                            ? NetworkImage((widget.post['userProfiles'] as List).first)
                            : null,
                        child: (widget.post['userProfiles'] is List && (widget.post['userProfiles'] as List).isNotEmpty)
                            ? null
                            : Icon(Icons.person, size: 20, color: Colors.white),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.post['userNickname'],
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.place, color: Color(0xFFB34FD1), size: 16),
                          SizedBox(width: 4),
                          Text(
                            widget.post['address'] ?? '주소를 불러오는 중...',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.post['title'],
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFD3F0),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    widget.post['category'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFFB34FD1),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '${widget.post['pricePerCount']}원',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFFB34FD1),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      if (widget.post['thumbnail'] != null && widget.post['thumbnail'].isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            widget.post['thumbnail'],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.image,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${widget.post['currentUserCount']}/${widget.post['userCount']}',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          SizedBox(width: 8),
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.grey.shade300,
                                child: Icon(
                                  Icons.person,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                              Positioned(
                                left: 16,
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.grey.shade300,
                                  child: Icon(
                                    Icons.person,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 20),
                          Text(
                            '모구 마감',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          SizedBox(width: 4),
                          Text(
                            widget.post['purchaseDate'],
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isLiked = !isLiked;
                                heartCount += isLiked ? 1 : -1;
                              });
                            },
                            child: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              size: 20,
                              color: Color(0xFFB34FD1),
                            ),
                          ),
                          SizedBox(width: 4),
                          Text('$heartCount', style: TextStyle(color: Color(0xFFB34FD1))),
                          SizedBox(width: 16),
                          SvgPicture.asset(
                            'assets/icons/views.svg',
                            width: 16,
                            height: 16,
                          ),
                          SizedBox(width: 4),
                          Text('${widget.post['viewCount']}', style: TextStyle(color: Color(0xFFB34FD1))),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}