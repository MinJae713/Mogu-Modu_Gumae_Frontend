
class PostDetailPageModel {
  bool isHeartFilled = false; // 하트 아이콘의 상태를 저장하는 변수
  late int likeCount; // 좋아요 수를 저장하는 변수
  late int viewCount; // 조회수를 저장하는 변수
  PostDetailPageModel({
    required this.likeCount,
    required this.viewCount,
  });
  factory PostDetailPageModel.fromJson(Map<String, dynamic> post) {
    // post_report_page.post 데이터를 이용하여 초기 좋아요 및 조회수 값을 설정
    return PostDetailPageModel(
      likeCount: post['heartCount'] ?? 0,
      viewCount: post['viewCount'] ?? 0
    );
  }
  void toggleHeart() {
    // 하트 -1 되는거 확인 필요
    isHeartFilled = !isHeartFilled; // 하트 아이콘의 상태를 토글
    isHeartFilled ? likeCount++ : likeCount--; // 좋아요 수 증가/감소
  }
}