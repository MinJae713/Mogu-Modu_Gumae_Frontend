import 'package:flutter/material.dart';

class InfoRow extends StatefulWidget {
  final String title;
  final String value;
  final bool hasButton;
  final VoidCallback showPasswordChangeDialog;
  InfoRow({
    super.key,
    required this.title,
    required this.value,
    required this.showPasswordChangeDialog,
    this.hasButton = false,
  });

  @override
  State<StatefulWidget> createState() {
    return _InfoRow();
  }
}

class _InfoRow extends State<InfoRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Text(
                  widget.value,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                if (widget.hasButton)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: ElevatedButton(
                      onPressed: widget.showPasswordChangeDialog,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFF5F5F5F),
                        minimumSize: Size(35, 25),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text('변경', style: TextStyle(fontSize: 12)),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}