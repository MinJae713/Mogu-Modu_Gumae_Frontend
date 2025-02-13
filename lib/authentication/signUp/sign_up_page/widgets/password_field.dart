// lib/authentication/signUp/widgets/password_field.dart
import 'package:flutter/material.dart';
import 'text_field_with_label.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final Function(String)? onFieldSubmitted;

  const PasswordField({
    Key? key,
    required this.controller,
    required this.focusNode,
    this.nextFocusNode,
    this.onFieldSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldWithLabel(
      labelText: "패스워드",
      isRequired: true,
      hintText: "패스워드를 입력하세요",
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
          return '패스워드를 입력해주세요';
        }
        if (value.length < 8 || value.length > 16) {
          return '패스워드는 8자에서 16자 사이여야 합니다';
        }
        final passwordRegExp = RegExp(r'^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*?_]).{8,16}$');
        if (!passwordRegExp.hasMatch(value)) {
          return '비밀번호는 숫자, 영문, 특수문자 조합이어야 합니다.';
        }
        return null;
      },
    );
  }
}
