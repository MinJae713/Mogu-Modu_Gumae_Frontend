// lib/authentication/signUp/sign_up_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:http/http.dart' as http;
import 'package:mogu_app/authentication/signIn/login_page.dart';
import 'package:mogu_app/service/location_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// 분리한 위젯 임포트
import 'widgets/user_id_field.dart';
import 'widgets/verification_code_field.dart';
import 'widgets/password_field.dart';
import 'widgets/confirm_password_field.dart';
import 'widgets/phone_number_field.dart';
import 'widgets/phone_verification_code_field.dart';
import 'widgets/location_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController verificationCodeController = TextEditingController();
  final TextEditingController phoneVerificationCodeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  NLatLng? selectedLocation;

  final _formKey = GlobalKey<FormState>();
  bool isVerificationFieldVisible = false;
  bool isPhoneVerificationFieldVisible = false;
  bool isEmailVerified = false;
  bool isPhoneVerified = false;

  final LocationService _locationService = LocationService();

  // FocusNodes
  final FocusNode _userIdFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _nicknameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initCurrentLocation();
  }

  Future<void> _initCurrentLocation() async {
    await _locationService.initCurrentLocation();
  }

  Future<void> postUser(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      if (!isEmailVerified) {
        _showErrorDialog('오류', '이메일 인증을 완료해주세요.');
        return;
      }

      if (!isPhoneVerified) {
        _showErrorDialog('오류', '핸드폰 인증을 완료해주세요.');
        return;
      }

      String userId = userIdController.text;
      String password = passwordController.text;
      String name = nameController.text;
      String nickname = nicknameController.text;
      String phone = phoneController.text.replaceAll('-', '');

      String url =
          'http://${dotenv.env['SERVER_IP']}:${dotenv.env['SERVER_PORT']}/user';

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "userId": userId,
            "password": password,
            "name": name,
            "nickname": nickname,
            "phone": phone,
            "role": "user",
            "longitude": selectedLocation?.longitude.toString() ?? '',
            "latitude": selectedLocation?.latitude.toString() ?? '',
          }),
        );

        if (response.statusCode == 201) {
          _showSignUpSuccessDialog();
        } else {
          _showErrorDialog('회원가입 실패', '서버에서 오류가 발생했습니다.');
        }
      } catch (e) {
        _showErrorDialog('오류', '서버와의 연결 오류가 발생했습니다.');
      }
    }
  }

  void _showSignUpSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('회원가입 완료'),
          content: Text('회원가입이 완료되었습니다!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('확인', style: TextStyle(color: Color(0xFFB34FD1))),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _verifyEmail() {
    final email = userIdController.text;
    final emailRegExp =
    RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

    if (email.isEmpty || !emailRegExp.hasMatch(email)) {
      _showErrorDialog('오류', '유효한 이메일 주소를 입력해주세요');
    } else {
      setState(() {
        isVerificationFieldVisible = true;
      });
      _showErrorDialog('인증번호 발송', '이메일 인증번호를 발송했습니다.');
    }
  }

  void _verifyPhoneNumber() {
    final phoneNumber = phoneController.text;
    final phoneRegExp = RegExp(r'^\d{3}-\d{4}-\d{4}$');

    if (phoneNumber.isEmpty || !phoneRegExp.hasMatch(phoneNumber)) {
      _showErrorDialog('오류', '유효한 핸드폰 번호를 입력해주세요');
    } else {
      setState(() {
        isPhoneVerificationFieldVisible = true;
      });
      _showErrorDialog('인증번호 발송', '핸드폰 인증번호를 발송했습니다.');
    }
  }

  void _confirmVerificationCode() {
    setState(() {
      isEmailVerified = true;
    });
    _showErrorDialog('인증 성공', '이메일 인증이 완료되었습니다.');
  }

  void _confirmPhoneVerificationCode() {
    setState(() {
      isPhoneVerified = true;
    });
    _showErrorDialog('인증 성공', '핸드폰 인증이 완료되었습니다.');
  }

  Future<void> _onLocationIconPressed() async {
    selectedLocation = await _locationService.openMapPage(context);

    if (selectedLocation != null) {
      String currentAddress = await _locationService.getAddressFromCoordinates(
          selectedLocation!.latitude, selectedLocation!.longitude);
      setState(() {
        addressController.text = currentAddress;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFFB34FD1)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '회원가입',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 24),
                // 기존 _buildUserIdField() 대신 분리한 위젯 사용
                UserIdField(
                  controller: userIdController,
                  focusNode: _userIdFocusNode,
                  onVerify: _verifyEmail,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                  },
                ),
                if (isVerificationFieldVisible) ...[
                  SizedBox(height: 16),
                  VerificationCodeField(
                    controller: verificationCodeController,
                    onConfirm: _confirmVerificationCode,
                  ),
                ],
                SizedBox(height: 16),
                PasswordField(
                  controller: passwordController,
                  focusNode: _passwordFocusNode,
                  nextFocusNode: _confirmPasswordFocusNode,
                ),
                SizedBox(height: 16),
                ConfirmPasswordField(
                  controller: confirmPasswordController,
                  passwordController: passwordController,
                  focusNode: _confirmPasswordFocusNode,
                  nextFocusNode: _nameFocusNode,
                ),
                SizedBox(height: 16),
                // 이름과 닉네임은 기존 _buildTextFieldWithLabel 사용 (코드 분리하지 않음)
                _buildTextFieldWithLabel(
                  "이름",
                  true,
                  "이름을 입력하세요",
                  nameController,
                  focusNode: _nameFocusNode,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_nicknameFocusNode);
                  },
                ),
                SizedBox(height: 16),
                _buildTextFieldWithLabel(
                  "닉네임",
                  true,
                  "닉네임을 입력하세요",
                  nicknameController,
                  focusNode: _nicknameFocusNode,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_phoneFocusNode);
                  },
                ),
                SizedBox(height: 16),
                PhoneNumberField(
                  controller: phoneController,
                  focusNode: _phoneFocusNode,
                  onVerify: _verifyPhoneNumber,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_addressFocusNode);
                  },
                ),
                if (isPhoneVerificationFieldVisible) ...[
                  SizedBox(height: 16),
                  // 분리한 핸드폰 인증번호 위젯 사용
                  PhoneVerificationCodeField(
                    controller: phoneVerificationCodeController,
                    onConfirm: _confirmPhoneVerificationCode,
                  ),
                ],
                SizedBox(height: 16),
                LocationField(
                  controller: addressController,
                  onLocationSelect: _onLocationIconPressed,
                  focusNode: _addressFocusNode,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 58,
          child: ElevatedButton(
            onPressed: () {
              postUser(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFB34FD1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              '확인',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 기존 _buildTextFieldWithLabel 메서드는 그대로 둡니다.
  Widget _buildTextFieldWithLabel(
      String labelText,
      bool isRequired,
      String hintText,
      TextEditingController controller, {
        TextInputType? keyboardType,
        List<TextInputFormatter>? inputFormatters,
        Widget? suffixIcon,
        bool readOnly = false,
        bool obscureText = false,
        FocusNode? focusNode,
        Function(String)? onFieldSubmitted,
        String? Function(String?)? validator,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: labelText,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            children: isRequired
                ? [
              TextSpan(
                text: ' *',
                style: TextStyle(
                  color: Color(0xFFB34FD1),
                  fontSize: 16,
                ),
              ),
            ]
                : [],
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          obscureText: obscureText,
          focusNode: focusNode,
          onFieldSubmitted: onFieldSubmitted,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 10),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFB34FD1)),
            ),
            errorStyle: TextStyle(color: Colors.red),
            suffixIcon: suffixIcon,
          ),
          readOnly: readOnly,
          validator: validator ??
                  (value) {
                if (value == null || value.isEmpty) {
                  return '$labelText를 입력해주세요';
                }
                if (labelText == "아이디 (이메일주소)") {
                  final emailRegExp =
                  RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
                  if (!emailRegExp.hasMatch(value)) {
                    return '유효한 이메일 주소를 입력해주세요';
                  }
                } else if (labelText == "패스워드") {
                  if (value.length < 8 || value.length > 16) {
                    return '패스워드는 8자에서 16자 사이여야 합니다';
                  }
                  final passwordRegExp = RegExp(
                      r'^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*?_]).{8,16}$');
                  if (!passwordRegExp.hasMatch(value)) {
                    return '비밀번호는 숫자, 영문, 특수문자 조합이어야 합니다.';
                  }
                } else if (labelText == "이름" || labelText == "닉네임") {
                  if (value.length > 12) {
                    return '$labelText는 최대 12자까지 입력할 수 있습니다';
                  }
                } else if (labelText == "핸드폰번호") {
                  if (value.length != 13) {
                    return '핸드폰 번호는 11자리여야 합니다';
                  }
                  final phoneRegExp = RegExp(r'^\d{3}-\d{4}-\d{4}$');
                  if (!phoneRegExp.hasMatch(value)) {
                    return '유효한 핸드폰 번호를 입력해주세요';
                  }
                }
                return null;
              },
        ),
      ],
    );
  }
}
