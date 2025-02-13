// lib/authentication/signUp/widgets/text_field_with_label.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWithLabel extends StatelessWidget {
  final String labelText;
  final bool isRequired;
  final String hintText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final bool readOnly;
  final bool obscureText;
  final FocusNode? focusNode;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;

  const TextFieldWithLabel({
    Key? key,
    required this.labelText,
    required this.isRequired,
    required this.hintText,
    required this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.suffixIcon,
    this.readOnly = false,
    this.obscureText = false,
    this.focusNode,
    this.onFieldSubmitted,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
