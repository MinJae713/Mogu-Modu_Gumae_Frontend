// lib/authentication/signUp/widgets/phone_number_field.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'text_field_with_label.dart';

class PhoneNumberField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onVerify;
  final Function(String)? onFieldSubmitted;

  const PhoneNumberField({
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
            labelText: "핸드폰번호",
            isRequired: true,
            hintText: "핸드폰 번호를 입력하세요",
            controller: controller,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
              PhoneNumberFormatter(),
            ],
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
            '인증하기',
            style: TextStyle(color: Colors.white),
          ),
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
