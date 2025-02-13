import 'package:flutter/material.dart';

class ChatFilterButton extends StatefulWidget {
  final String label;
  final Function getChatFilter;
  final Function setChatFilter;
  ChatFilterButton({
    super.key,
    required this.label,
    required this.getChatFilter,
    required this.setChatFilter
  });

  @override
  State<StatefulWidget> createState() {
    return _ChatFilterButton();
  }
}

class _ChatFilterButton extends State<ChatFilterButton> {
  @override
  Widget build(BuildContext context) {
    String selectedChatFilter = widget.getChatFilter();
    return OutlinedButton(
      onPressed: () {
        widget.setChatFilter(widget.label);
      },
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        backgroundColor: selectedChatFilter == widget.label ? Colors.grey.shade200 : Colors.white,
        side: BorderSide(
          color: selectedChatFilter == widget.label ? Colors.black : Colors.grey,
        ),
      ),
      child: Text(widget.label, style: TextStyle(fontSize: 14)),
    );
  }
}