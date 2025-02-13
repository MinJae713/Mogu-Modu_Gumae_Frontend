// lib/authentication/signUp/widgets/phone_verification_code_field.dart
import 'package:flutter/material.dart';
import 'text_field_with_label.dart';

class PhoneVerificationCodeField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onConfirm;

  const PhoneVerificationCodeField({
    Key? key,
    required this.controller,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFieldWithLabel(
            labelText: "핸드폰 인증번호 입력",
            isRequired: true,
            hintText: "핸드폰 인증번호를 입력하세요",
            controller: controller,
          ),
        ),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: onConfirm,
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
}
