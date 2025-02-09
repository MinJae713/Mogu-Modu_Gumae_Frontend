import 'package:flutter/material.dart';

class IntroPageButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const IntroPageButton({
    super.key,
    required this.text,
    required this.onPressed
  });

  @override
  State<StatefulWidget> createState() {
    return _IntroPageButton();
  }
}

class _IntroPageButton extends State<IntroPageButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.onPressed,
      style: TextButton.styleFrom(
        backgroundColor: Color(0xFFFFD3F0),
        minimumSize: Size(double.infinity, 58),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        widget.text,
        style: TextStyle(
          color: Color(0xFFB34FD1),
          fontSize: 18,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}