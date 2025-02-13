// lib/authentication/signUp/widgets/location_field.dart
import 'package:flutter/material.dart';
import 'text_field_with_label.dart';

class LocationField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onLocationSelect;
  final FocusNode? focusNode;

  const LocationField({
    Key? key,
    required this.controller,
    required this.onLocationSelect,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldWithLabel(
      labelText: "주소",
      isRequired: true,
      hintText: "주소를 선택해주세요",
      controller: controller,
      suffixIcon: IconButton(
        icon: Icon(Icons.location_on, color: Color(0xFFB34FD1)),
        onPressed: onLocationSelect,
      ),
      focusNode: focusNode,
      readOnly: true,
    );
  }
}
