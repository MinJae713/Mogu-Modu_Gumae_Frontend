
class MoguListPageModel {
  int userUid = 0;
  late String token;
  late double longitude;
  late double latitude;
  final List<Map<String, dynamic>> posts = []; // 게시글 리스트 초기화
  String selectedSortOption = '최신순';
  MoguListPageModel({
    required this.token,
    required this.longitude,
    required this.latitude
  });
  factory MoguListPageModel.fromJson(Map<String, dynamic> userInfo) {
    return MoguListPageModel(
      token: userInfo['token'] ?? '',
      longitude: userInfo['longitude']?.toDouble() ?? 0.0,
      latitude: userInfo['latitude']?.toDouble() ?? 0.0
    );
  }
  void setPostAddress(int index, String address) {
    posts[index]['address'] = address;
  }
  void addPost(Map<String, dynamic> post) {
    posts.add(post);
  }
}