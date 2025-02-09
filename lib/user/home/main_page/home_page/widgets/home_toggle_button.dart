import 'package:flutter/material.dart';

class HomeToggleButton extends StatefulWidget {
  final String label;
  final String option1;
  final String option2;
  final String selectedValue;
  final ValueChanged<String> onChanged;
  const HomeToggleButton({super.key, required this.label,
    required this.option1, required this.option2,
    required this.selectedValue, required this.onChanged});

  @override
  State<StatefulWidget> createState() {
    return _HomeToggleButton();
  }
}

class _HomeToggleButton extends State<HomeToggleButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  widget.onChanged(widget.option1);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: widget.selectedValue == widget.option1 ? Colors.white : Colors.grey,
                  backgroundColor: widget.selectedValue == widget.option1 ? Color(0xFFB34FD1) : Colors.grey.shade200,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                ),
                child: Text(widget.option1),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  widget.onChanged(widget.option2);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: widget.selectedValue == widget.option2 ? Colors.white : Colors.grey,
                  backgroundColor: widget.selectedValue == widget.option2 ? Color(0xFFB34FD1) : Colors.grey.shade200,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                ),
                child: Text(widget.option2),
              ),
            ),
          ],
        ),
      ],
    );
  }
}