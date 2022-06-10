import 'package:flutter/material.dart';

class TextDropdown extends StatefulWidget {
  const TextDropdown({
    Key? key,
    required this.options,
    required this.selectedOption,
    required this.onChanged,
    this.textStyle,
  }) : super(key: key);

  final List<String> options;
  final String selectedOption;
  final ValueChanged<String?> onChanged;
  final TextStyle? textStyle;

  @override
  State<TextDropdown> createState() => _TextDropdownState();
}

class _TextDropdownState extends State<TextDropdown> {
  late String selectedOption;
  List<String> options = [];

  @override
  void initState() {
    super.initState();

    selectedOption = widget.selectedOption;

    options = widget.options;
    if (!options.contains(selectedOption)) {
      options.add(selectedOption);
    }
  }

  void onChanged(String? value) async {
    setState(() {
      selectedOption = value ?? widget.selectedOption;
    });

    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        alignment: AlignmentDirectional.topStart,
        value: selectedOption,
        items: options
            .map((e) => DropdownMenuItem(
                key: UniqueKey(),
                value: e,
                child: Text(
                  e,
                  style: widget.textStyle,
                )))
            .toList(),
        onChanged: onChanged);
  }
}
