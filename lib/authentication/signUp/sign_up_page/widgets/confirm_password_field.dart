// lib/authentication/signUp/widgets/confirm_password_field.dart
import 'package:flutter/material.dart';
import 'text_field_with_label.dart';

class ConfirmPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController passwordController;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final Function(String)? onFieldSubmitted;

  const ConfirmPasswordField({
    Key? key,
    required this.controller,
    required this.passwordController,
    required this.focusNode,
    this.nextFocusNode,
    this.onFieldSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldWithLabel(
      labelText: "패스워드 확인",
      isRequired: true,
      hintText: "패스워드를 다시 입력하세요",
      controller: controller,
      obscureText: true,
      focusNode: focusNode,
      onFieldSubmitted: (value) {
        if (nextFocusNode != null) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        }
        if (onFieldSubmitted != null) onFieldSubmitted!(value);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '패스워드 확인을 입력해주세요';
        }
        if (value != passwordController.text) {
          return '서로 다른 비밀번호가 입력되었습니다';
        }
        return null;
      },
    );
  }
}
