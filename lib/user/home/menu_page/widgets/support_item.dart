import 'package:flutter/material.dart';

class SupportItem extends StatefulWidget {
  final int index;
  final IconData iconData;
  final String label;
  const SupportItem({
    super.key,
    required this.index,
    required this.iconData,
    required this.label
  });

  @override
  State<StatefulWidget> createState() {
    return _SupportItem();
  }
}

class _SupportItem extends State<SupportItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // 여기에 아이콘 클릭 시 동작할 코드 작성
        print('${widget.label} 클릭됨');
      },
      borderRadius: BorderRadius.circular(32), // 물결 효과가 텍스트를 감싸도록 경계 설정
      splashColor: Colors.purple.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              widget.iconData,
              color: widget.index == 0 ? Colors.red : Colors.blue, // 첫 번째는 빨간색, 두 번째는 파란색
            ),
            SizedBox(width: 8),
            Text(widget.label),
          ],
        ),
      ),
    );
  }
}