import 'package:flutter/material.dart';

class DetailRow extends StatefulWidget {
  final String title;
  final String value;
  final VoidCallback? onTap;
  final bool showArrow;
  DetailRow({
    super.key,
    required this.title,
    required this.value,
    required this.onTap,
    this.showArrow = true
  });

  @override
  State<StatefulWidget> createState() {
    return _DetailRow();
  }
}

class _DetailRow extends State<DetailRow> {
  @override
  Widget build(BuildContext context) {
    IconData? icon = widget.showArrow && widget.onTap != null ? Icons.arrow_drop_down : null;

    if (widget.title == '모임 장소') {
      icon = Icons.place;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: TextStyle(fontSize: 16),
          ),
          GestureDetector(
            onTap: widget.onTap,
            child: Row(
              children: [
                if (icon != null && widget.title == '모임 장소')
                  Icon(
                    icon,
                    color: Color(0xFFB34FD1),
                  ),
                if (widget.title == '모임 장소')
                  SizedBox(width: 4),
                Container(
                  constraints: BoxConstraints(maxWidth: 200),
                  child: Text(
                    widget.value,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFB34FD1),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                if (icon != null && widget.title != '모임 장소')
                  Icon(
                    icon,
                    color: Color(0xFFB34FD1),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}