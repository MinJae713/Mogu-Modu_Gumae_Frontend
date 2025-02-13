import 'package:flutter/material.dart';

class CheckBoxOption extends StatefulWidget {
  final String title;
  final Function getSelectedReportType;
  final Function setSelectedReportType;
  const CheckBoxOption({
    super.key,
    required this.title,
    required this.getSelectedReportType,
    required this.setSelectedReportType
  });

  @override
  State<StatefulWidget> createState() {
    return _CheckBoxOption();
  }
}

class _CheckBoxOption extends State<CheckBoxOption> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.title),
      value: widget.getSelectedReportType() == widget.title,
      onChanged: (bool? value) {
        widget.setSelectedReportType(value! ? widget.title : null);
      },
      activeColor: Color(0xFFB34FD1),
      controlAffinity: ListTileControlAffinity.leading, // 체크박스를 왼쪽에 배치
    );
  }
}