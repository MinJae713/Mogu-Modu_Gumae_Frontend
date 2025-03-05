
class HomePageModel {
  // BannerAd? bannerAd;
  bool isAdLoaded = false;
  String selectedSortOption = '최신순';
  final List<String> sortOptions = ['최신순', '가까운 순'];

  late double longitude;
  late double latitude;
  late String token;
  int userUid = 0;
  List<Map<String, dynamic>> posts = []; // 게시글 리스트 초기화

  HomePageModel({
    required this.token,
    required this.longitude,
    required this.latitude
  });

  factory HomePageModel.fromJson(Map<String, dynamic> userInfo) {
    return HomePageModel(
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

  void setUserUid(int userUid) {
    this.userUid = userUid;
  }
  // void setBannerAd(BannerAd bannerAd) {
  //   this.bannerAd = bannerAd;
  // }
  void setAdLoaded(bool isAdLoaded) {
    this.isAdLoaded = isAdLoaded;
  }
  void setPosts(List<Map<String, dynamic>> posts) {
    this.posts = posts;
  }
}