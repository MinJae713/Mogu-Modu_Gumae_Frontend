// lib/authentication/signUp/widgets/user_id_field.dart
import 'package:flutter/material.dart';
import 'text_field_with_label.dart';

class UserIdField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onVerify;
  final Function(String)? onFieldSubmitted;

  const UserIdField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.onVerify,
    this.onFieldSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFieldWithLabel(
            labelText: "아이디 (이메일주소)",
            isRequired: true,
            hintText: "이메일을 입력하세요",
            controller: controller,
            focusNode: focusNode,
            onFieldSubmitted: onFieldSubmitted,
          ),
        ),
        SizedBox(width: 8),
        ElevatedButton(
          onPressed: onVerify,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFB34FD1),
            minimumSize: Size(150, 50),
          ),
          child: Text(
            '이메일 인증하기',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
