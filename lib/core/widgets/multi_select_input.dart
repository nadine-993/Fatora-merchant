import 'package:fatora/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';

import '../constants/app_input_style.dart';
import '../constants/app_styles.dart';

class MultiSelectInput extends StatefulWidget {
  const MultiSelectInput({Key? key, required this.onChanged, this.hint, required this.statusList, required this.selectedStatus}) : super(key: key);

  final void Function(List<String>) onChanged;
  final String? hint;
  final List<String> statusList;
  final List<String> selectedStatus;

  @override
  State<MultiSelectInput> createState() => _MultiSelectInputState();
}

class _MultiSelectInputState extends State<MultiSelectInput> {
  @override
  Widget build(BuildContext context) {
    return DropDownMultiSelect(
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      hintStyle: AppStyles.title.copyWith(color: AppColors.black),
      selected_values_style: AppStyles.title,
      decoration: AppInputStyle.getInputDecoration(hint:''),
      onChanged: widget.onChanged,
      options: widget.statusList,
      selectedValues: widget.selectedStatus,
      whenEmpty: widget.hint ?? '',
    );
  }
}
