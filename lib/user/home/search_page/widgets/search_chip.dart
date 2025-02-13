import 'package:flutter/material.dart';

class SearchChip extends StatefulWidget {
  final String label;
  const SearchChip({super.key, required this.label});

  @override
  State<StatefulWidget> createState() {
    return _SearchChip();
  }
}

class _SearchChip extends State<SearchChip> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          print('${widget.label} 클릭됨');
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Chip(
            label: Text(widget.label),
            backgroundColor: Colors.grey.shade200,
          ),
        ),
      ),
    );
  }
}