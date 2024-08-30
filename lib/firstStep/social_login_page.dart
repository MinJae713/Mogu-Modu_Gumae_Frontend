import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SocialLoginPage extends StatefulWidget {
  const SocialLoginPage({super.key});

  @override
  State<SocialLoginPage> createState() => _SocialLoginPageState();
}

class _SocialLoginPageState extends State<SocialLoginPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController phoneVerificationCodeController = TextEditingController();

  bool isPhoneVerificationFieldVisible = false;
  bool isPhoneVerified = false;

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

  void _confirmPhoneVerificationCode() {
    setState(() {
      isPhoneVerified = true;
    });
    _showErrorDialog('인증 성공', '핸드폰 인증이 완료되었습니다.');
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '핸드폰 인증',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 24),
            _buildPhoneNumberField(),
            if (isPhoneVerificationFieldVisible) ...[
              SizedBox(height: 16),
              _buildPhoneVerificationCodeField(),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 58,
          child: ElevatedButton(
            onPressed: () {
              if (isPhoneVerified) {
                _showErrorDialog('인증 완료', '핸드폰 인증이 완료되었습니다.');
              } else {
                _showErrorDialog('인증 미완료', '핸드폰 인증을 완료해주세요.');
              }
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

  Widget _buildPhoneNumberField() {
    return Row(
      children: [
        Expanded(
          child: _buildTextFieldWithLabel(
            "핸드폰번호",
            true,
            "핸드폰 번호를 입력하세요",
            phoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
              PhoneNumberFormatter(),
            ],
          ),
        ),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: _verifyPhoneNumber,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFB34FD1),
            minimumSize: Size(150, 50),
          ),
          child: Text(
            '인증하기',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneVerificationCodeField() {
    return Row(
      children: [
        Expanded(
          child: _buildTextFieldWithLabel(
            "핸드폰 인증번호 입력",
            true,
            "핸드폰 인증번호를 입력하세요",
            phoneVerificationCodeController,
          ),
        ),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: _confirmPhoneVerificationCode,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFB34FD1),
            minimumSize: Size(150, 50),
          ),
          child: Text(
            '인증번호 확인',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

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
                if (labelText == "핸드폰번호") {
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

// 전화번호 형식 맞춤 포맷터
class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (text.length > 3 && text.length <= 7) {
      final formattedText = '${text.substring(0, 3)}-${text.substring(3)}';
      return newValue.copyWith(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    } else if (text.length > 7 && text.length <= 11) {
      final formattedText = '${text.substring(0, 3)}-${text.substring(3, 7)}-${text.substring(7)}';
      return newValue.copyWith(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length),
      );
    }
    return newValue;
  }
}