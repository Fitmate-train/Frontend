import 'package:flutter/material.dart';

class QuestionStep extends StatelessWidget {
  final String title;
  final List<String> options;
  final List<String> selectedOptions;
  final ValueChanged<List<String>> onChanged;
  final bool isSingleChoice;

  const QuestionStep({
    required this.title,
    required this.options,
    required this.selectedOptions,
    required this.onChanged,
    this.isSingleChoice = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          options.map((opt) {
            final isSelected = selectedOptions.contains(opt);
            return ListTile(
              title: Text(opt),
              leading:
                  isSingleChoice
                      ? Radio<String>(
                        value: opt,
                        groupValue:
                            selectedOptions.isEmpty
                                ? null
                                : selectedOptions.first,
                        onChanged: (val) => onChanged([val!]),
                      )
                      : Checkbox(
                        value: isSelected,
                        onChanged: (val) {
                          final newSelection = List<String>.from(
                            selectedOptions,
                          );
                          val!
                              ? newSelection.add(opt)
                              : newSelection.remove(opt);
                          onChanged(newSelection);
                        },
                      ),
            );
          }).toList(),
    );
  }
}
