import 'package:flutter/material.dart';

class TapToEditText extends StatefulWidget {
  const TapToEditText({
    Key? key,
    required this.initialText,
    required this.onSubmitted,
    this.style,
  }) : super(key: key);

  final String initialText;
  final ValueChanged<String> onSubmitted;
  final TextStyle? style;

  @override
  State<TapToEditText> createState() => _TapToEditTextState();
}

class _TapToEditTextState extends State<TapToEditText> {
  bool _isEditingText = false;
  late TextEditingController _editingController;
  late String text;

  @override
  void initState() {
    super.initState();
    text = widget.initialText;
    _editingController = TextEditingController(text: text);
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  void _stopEditing() {
    setState(() {
      text = _editingController.text;
      _isEditingText = false;
    });

    widget.onSubmitted(text);
  }

  @override
  Widget build(BuildContext context) {
    if (_isEditingText) {
      return InkWell(
        onFocusChange: (bool hasFocus) {
          if (!hasFocus) {
            _stopEditing();
          }
        },
        child: TextField(
          style: widget.style,
          onSubmitted: (newValue) {
            _stopEditing();
          },
          autofocus: true,
          controller: _editingController,
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          setState(() {
            _isEditingText = true;
          });
        },
        child: Text(
          text,
          style: widget.style,
        ),
      );
    }
  }
}
