import 'package:flutter/material.dart';
import 'package:mogu_app/user/home/post/report/post_report_page.dart';

class PostDetailPage extends StatefulWidget {
  final Map<String, dynamic> post; // 포스트 데이터를 받을 수 있도록 생성자에 추가

  const PostDetailPage({Key? key, required this.post}) : super(key: key);

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  bool _isHeartFilled = false; // 하트 아이콘의 상태를 저장하는 변수
  late int _likeCount; // 좋아요 수를 저장하는 변수
  late int _viewCount; // 조회수를 저장하는 변수

  @override
  void initState() {
    super.initState();
    // widget.post 데이터를 이용하여 초기 좋아요 및 조회수 값을 설정
    _likeCount = widget.post['heartCount'] ?? 0;
    _viewCount = widget.post['viewCount'] ?? 0;
  }

  void _toggleHeart() {
    setState(() {
      _isHeartFilled = !_isHeartFilled; // 하트 아이콘의 상태를 토글
      _isHeartFilled ? _likeCount++ : _likeCount--; // 좋아요 수 증가/감소
    });
  }

  void _onParticipateRequest() {
    // 참여요청 버튼 눌렀을 때 동작을 여기에 정의합니다.
    print('참여요청 버튼 눌림');
  }

  void _showBottomSheet(BuildContext context) {
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
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              _showBottomSheet(context);
            },
            color: Color(0xFFFFD3F0),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지 섹션
            Stack(
              children: [
                Container(
                  color: Colors.grey.shade300,
                  width: double.infinity,
                  height: 200,
                  child: widget.post['thumbnail'] != null && widget.post['thumbnail'].isNotEmpty
                      ? Image.network(
                    widget.post['thumbnail'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                  )
                      : Icon(
                    Icons.image,
                    size: 100,
                    color: Colors.grey,
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Row(
                    children: [
                      Icon(Icons.visibility, color: Colors.white),
                      SizedBox(width: 4),
                      Text('$_viewCount', style: TextStyle(color: Colors.white)),
                      SizedBox(width: 16),
                      Icon(
                        _isHeartFilled ? Icons.favorite : Icons.favorite_border,
                        color: Colors.white,
                      ),
                      SizedBox(width: 4),
                      Text('$_likeCount', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              color: Color(0xFFB34FD1),
              padding: EdgeInsets.symmetric(vertical: 4),
              width: double.infinity,
              child: Center(
                child: Text(
                  '10% 더 싸요',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 제목 및 거리 정보
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.post['title'] ?? '제목 없음',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text('${widget.post['distance']}km', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  SizedBox(height: 8),
                  // 사용자 정보
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      SizedBox(width: 8),
                      Text(widget.post['userNickname'] ?? '알 수 없음', style: TextStyle(fontWeight: FontWeight.bold)),
                      Spacer(),
                      Icon(Icons.location_on, color: Colors.purple),
                      SizedBox(width: 4),
                      Text(widget.post['address'] ?? '주소를 불러오는 중...', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  SizedBox(height: 16),
                  // 설명
                  Text(
                    widget.post['description'] ?? '내용 없음',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  // 추가 정보
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('마감 기한'),
                      Text(widget.post['endDate'] ?? '알 수 없음'),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('모구 인원'),
                      Row(
                        children: [
                          Text('${widget.post['currentUserCount']}/${widget.post['userCount']}'),
                          SizedBox(width: 8),
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.person, size: 12, color: Colors.white),
                          ),
                          SizedBox(width: 4),
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.person, size: 12, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  // 가격 정보
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('상품 구매 가격'),
                      Text('${widget.post['originalPrice']}원', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('할인 가격'),
                      Text('${widget.post['discountPrice']}원', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('모구 인원'),
                      Text('${widget.post['userCount']}명', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('모구가 (인당 가격)'),
                      Text('${widget.post['pricePerCount']}원', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 70,
        padding: const EdgeInsets.only(top: 9, left: 19, right: 12, bottom: 9),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color(0x14737373),
              blurRadius: 4,
              offset: Offset(0, -4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                _isHeartFilled ? Icons.favorite : Icons.favorite_border,
                color: _isHeartFilled ? Colors.red : Color(0xFFFFD3F0),
              ),
              onPressed: _toggleHeart,
            ),
            SizedBox(width: 10), // 하트 아이콘과 버튼 사이의 여백 추가
            Expanded(
              child: Material(
                color: Color(0xFFB34FD1),
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: _onParticipateRequest,
                  borderRadius: BorderRadius.circular(10),
                  splashColor: Colors.white.withOpacity(0.3),
                  child: Container(
                    height: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        '참여요청',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
