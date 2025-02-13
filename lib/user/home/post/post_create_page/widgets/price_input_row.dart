import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PriceInputRow extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isProductPrice;
  final FocusNode personFocusNode;
  const PriceInputRow({
    super.key,
    required this.title,
    required this.controller,
    required this.focusNode,
    required this.isProductPrice,
    required this.personFocusNode
  });

  @override
  State<StatefulWidget> createState() {
    return _PriceInputRow();
  }
}

class _PriceInputRow extends State<PriceInputRow> {
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
              focusNode: widget.focusNode,
              onFieldSubmitted: (value) {
                if (widget.isProductPrice)
                  FocusScope.of(context).requestFocus(widget.personFocusNode);
              },
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: '0 원',
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