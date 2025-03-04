
class MyPageModel {
  late String userId;
  late String name;
  late String nickname;
  late String phone;
  late int level;
  late String manner;
  late double longitude;
  late double latitude;
  late int distanceMeters;
  late DateTime registerDate;
  late String profileImage;
  late String address = "Loading location...";
  late String token;

  int currentPurchaseCount = 0;
  int needPurchaseCount = 0;
  int savingCost = 0;
  MyPageModel({
    required this.userId,
    required this.token,
    required this.name,
    required this.nickname,
    required this.phone,
    required this.level,
    required this.manner,
    required this.longitude,
    required this.latitude,
    required this.distanceMeters,
    required this.registerDate,
    required this.profileImage,
  });
  factory MyPageModel.fromJson(Map<String, dynamic> userInfo) {
    return MyPageModel(
      userId: userInfo['userId'] ?? '',
      token: userInfo['token'] ?? '',
      name: userInfo['name'] ?? '',
      nickname: userInfo['nickname'] ?? '',
      phone: userInfo['phone'] ?? '',
      level: userInfo['level'] ?? 0,
      manner: userInfo['manner'] ?? '',
      longitude: userInfo['longitude']?.toDouble() ?? 0.0,
      latitude: userInfo['latitude']?.toDouble() ?? 0.0,
      distanceMeters: userInfo['distanceMeters'] ?? 0,
      registerDate: DateTime.parse(userInfo['registerDate'] ?? DateTime.now().toIso8601String()),
      profileImage: userInfo['profileImage'] ?? ''
    );
  }
  void setNickname(String nickname) {
    this.nickname = nickname;
  }
  void setProfileImage(String profileImage) {
    this.profileImage = profileImage;
  }
  void setLongitude(double longitude) {
    this.longitude = longitude;
  }
  void setLatitude(double latitude) {
    this.latitude = latitude;
  }
  void setAddress(String address) {
    this.address = address;
  }
  void setLevel(int level) {
    this.level = level;
  }
  void setCurrentPurchaseCount(int currentPurchaseCount) {
    this.currentPurchaseCount = currentPurchaseCount;
  }
  void setNeedPurchaseCount(int needPurchaseCount) {
    this.needPurchaseCount = needPurchaseCount;
  }
  void setSavingCost(int savingCost) {
    this.savingCost = savingCost;
  }
}