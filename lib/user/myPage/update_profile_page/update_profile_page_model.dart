import 'dart:io';

class UpdateProfilePageModel {
  late String nickname;
  late String profileImageUrl;
  String? address;
  late double latitude;
  late double longitude;
  File? newProfileImage;

  UpdateProfilePageModel({
    required this.nickname,
    required this.profileImageUrl,
    required this.latitude,
    required this.longitude
  });

  factory UpdateProfilePageModel.from(
      String nickname,
      String profileImageUrl,
      double latitude,
      double longitude) {
    return UpdateProfilePageModel(
      nickname: nickname,
      profileImageUrl: profileImageUrl,
      latitude: latitude,
      longitude: longitude
    );
  }

  void setNickname(String nickname) {
    this.nickname = nickname;
  }
  void setProfileImageUrl(String profileImageUrl) {
    this.profileImageUrl = profileImageUrl;
  }
  void setAddress(String address) {
    this.address = address;
  }
  void setLatitude(double latitude) {
    this.latitude = latitude;
  }
  void setLongitude(double longitude) {
    this.longitude = longitude;
  }
  void setNewProfileImage(File newProfileImage) {
    this.newProfileImage = newProfileImage;
  }
}