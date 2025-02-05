import 'package:flutter/material.dart';

class PostCard extends StatefulWidget{
  final String profileName;
  final String distance;
  final String description;
  final String price;
  final String imagePath;
  final String endDate;
  final String views;
  const PostCard({super.key,
    required this.profileName,
    required this.distance,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.endDate,
    required this.views
  });
  
  @override
  State<StatefulWidget> createState() {
    return _PostCard();
  }
}

class _PostCard extends State<PostCard>{
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //todo:포스트 디테일에 포스트 정보 주기
        // print('$profileName 게시글 클릭됨');
        // Navigator.push(
        //   context,
        //   PageRouteBuilder(
        //     pageBuilder: (context, animation, secondaryAnimation) =>
        //         PostDetailPage(),
        //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
        //       const begin = Offset(1.0, 0.0); // 오른쪽에서 시작
        //       const end = Offset.zero;
        //       const curve = Curves.ease;
        //
        //       var tween = Tween(begin: begin, end: end)
        //           .chain(CurveTween(curve: curve));
        //
        //       return SlideTransition(
        //         position: animation.drive(tween),
        //         child: child,
        //       );
        //     },
        //   ),
        // );
      },
      splashColor: Colors.purple.withOpacity(0.3), // 물결 효과 색상
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    child: Icon(Icons.person), // 프로필 이미지를 여기에 추가할 수 있음
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.profileName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        widget.distance,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text(widget.description, style: TextStyle(fontSize: 14)),
              SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.pinkAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('모구카', style: TextStyle(color: Colors.pink)),
                  ),
                  SizedBox(width: 8),
                  Text(
                    widget.price,
                    style: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Spacer(),
                  Column(
                    children: const [
                      Icon(Icons.image, size: 56), // 임시 아이콘 사용
                      SizedBox(height: 4),
                      Text(
                        '10% 더 싸요',
                        style: TextStyle(color: Colors.purple, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.grey, size: 16),
                  SizedBox(width: 4),
                  Text(widget.endDate, style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Spacer(),
                  Icon(Icons.comment, color: Colors.grey, size: 16),
                  SizedBox(width: 4),
                  Text('2/3', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  SizedBox(width: 8),
                  Icon(Icons.remove_red_eye, color: Colors.grey, size: 16),
                  SizedBox(width: 4),
                  Text(widget.views, style: TextStyle(color: Colors.grey, fontSize: 12)),
                  SizedBox(width: 8),
                  Icon(Icons.favorite_border, color: Colors.grey, size: 16),
                  SizedBox(width: 4),
                  Text('23', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}