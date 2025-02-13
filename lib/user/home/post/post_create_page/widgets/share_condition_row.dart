import 'package:flutter/material.dart';

class ShareConditionRow extends StatefulWidget{
  final Function getShareConditionEqual;
  final Function toggleShareCondition;
  const ShareConditionRow({
    super.key,
    required this.getShareConditionEqual,
    required this.toggleShareCondition
  });

  @override
  State<StatefulWidget> createState() {
    return _ShareConditionRow();
  }
}

class _ShareConditionRow extends State<ShareConditionRow>{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '분배 방식',
            style: TextStyle(fontSize: 16),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => widget.toggleShareCondition(true),
                child: Row(
                  children: [
                    Icon(
                      widget.getShareConditionEqual() ? Icons.check_box : Icons.check_box_outline_blank,
                      color: Color(0xFFB34FD1),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '균등',
                      style: TextStyle(fontSize: 16, color: Color(0xFFB34FD1)),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              GestureDetector(
                onTap: () => widget.toggleShareCondition(false),
                child: Row(
                  children: [
                    Icon(
                      !widget.getShareConditionEqual() ? Icons.check_box : Icons.check_box_outline_blank,
                      color: Color(0xFFB34FD1),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '커스텀',
                      style: TextStyle(fontSize: 16, color: Color(0xFFB34FD1)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}