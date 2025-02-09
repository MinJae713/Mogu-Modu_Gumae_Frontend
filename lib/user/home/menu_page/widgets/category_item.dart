import 'package:flutter/material.dart';

class CategoryItem extends StatefulWidget {
  final IconData iconData;
  final String label;
  const CategoryItem({
    super.key,
    required this.iconData,
    required this.label
  });

  @override
  State<StatefulWidget> createState() {
    return _CategoryItem();
  }
}

class _CategoryItem extends State<CategoryItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: Ink(
            decoration: BoxDecoration(
              color: Color(0xFFEDEDED),
              shape: BoxShape.circle,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(32),
              splashColor: Colors.purple.withOpacity(0.2),
              onTap: () {
                Navigator.pop(context, widget.label);
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(
                  widget.iconData,
                  color: Color(0xFFB34FD1),
                  size: 28,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 4),
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}