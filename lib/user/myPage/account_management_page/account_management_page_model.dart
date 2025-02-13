
class AccountManagementPageModel {
  final String userId;
  final String password;
  final String name;
  final String phone;
  AccountManagementPageModel({
    required this.userId,
    required this.password,
    required this.name,
    required this.phone
  });
  factory AccountManagementPageModel.fromJson(Map<String, dynamic> userInfo) {
    return AccountManagementPageModel(
      userId: userInfo['userId'] ?? 'N/A',
      password: userInfo['password'] ?? '********',  // password는 보통 표시하지 않거나 암호화된 형태로 보입니다.,
      name: userInfo['name'] ?? 'N/A',
      phone: _formatPhoneNumber(userInfo['phone'] ?? 'N/A')
    );
  }
  static String _formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.length == 11) {
      return '${phoneNumber.substring(0, 3)}-${phoneNumber.substring(3, 7)}-${phoneNumber.substring(7)}';
    } else if (phoneNumber.length == 10) {
      return '${phoneNumber.substring(0, 3)}-${phoneNumber.substring(3, 6)}-${phoneNumber.substring(6)}';
    } else {
      return phoneNumber; // 포맷에 맞지 않는 경우 그대로 반환
    }
  }
}