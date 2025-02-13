import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PersonInputRow extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final FocusNode personFocusNode;
  const PersonInputRow({
    super.key,
    required this.title,
    required this.controller,
    required this.personFocusNode
  });

  @override
  State<StatefulWidget> createState() {
    return _PersonInputRow();
  }
}

class _PersonInputRow extends State<PersonInputRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            width: 150,
            child: TextFormField(
              controller: widget.controller,
              focusNode: widget.personFocusNode,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter.allow(RegExp(r'^[1-9]\d*$')),
              ],
              decoration: InputDecoration(
                hintText: '0 명',
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFB34FD1)),
                ),
              ),
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: Color(0xFFB34FD1),
                  fontSize: 16),
              cursorColor: Color(0xFFB34FD1),
            ),
          ),
        ],
      ),
    );
  }
}