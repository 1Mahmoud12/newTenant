import 'package:flutter/material.dart';

class LabeledCheckButton extends StatefulWidget {
  final String label;
  final bool initialValue;
  final ValueChanged<bool>? onChanged;

  const LabeledCheckButton({
    Key? key,
    this.label = 'Make this as a default address',
    this.initialValue = false,
    this.onChanged,
  }) : super(key: key);

  @override
  State<LabeledCheckButton> createState() => _LabeledCheckButtonState();
}

class _LabeledCheckButtonState extends State<LabeledCheckButton> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Custom checkbox
        GestureDetector(
          onTap: () {
            setState(() {
              _isChecked = !_isChecked;
              if (widget.onChanged != null) {
                widget.onChanged!(_isChecked);
              }
            });
          },
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: _isChecked ? Colors.blue : Colors.grey.shade300,
              ),
              color: _isChecked ? Colors.blue : Colors.white,
            ),
            child: _isChecked
                ? const Icon(
                    Icons.check,
                    size: 16,
                    color: Colors.white,
                  )
                : null,
          ),
        ),
        const SizedBox(width: 8),
        // Label
        Text(
          widget.label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
