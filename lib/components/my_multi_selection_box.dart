import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class MyMultiSelectionBox extends StatefulWidget {
  final controller;
  final Map<String, String> items;
  const MyMultiSelectionBox(
      {super.key, required this.controller, required this.items});

  @override
  State<MyMultiSelectionBox> createState() {
    return _MyMultiSelectionBox();
  }
}

class _MyMultiSelectionBox extends State<MyMultiSelectionBox> {
  List<ValueItem> generateOptions() {
    List<ValueItem> options = [];
    widget.items.forEach((key, value) {
      options.add(ValueItem(label: key, value: value));
    });
    return options;
  }

  @override
  Widget build(BuildContext context) {
    return MultiSelectDropDown(
      onOptionSelected: (selectedOptions) {},
      options: generateOptions(),
      controller: widget.controller,
      selectionType: SelectionType.multi,
    );
  }
}
