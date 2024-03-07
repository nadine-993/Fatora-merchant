import 'package:flutter/material.dart';

import '../constants/app_colors.dart';


class CustomDropDown extends StatefulWidget {
  final List<dynamic> listItems;

  const CustomDropDown({
    Key? key,
    required this.listItems,
  }) : super(key: key);

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  late String? _dropDownValue = widget.listItems[0];

  void selection(dynamic selectedValue) {
    setState(() {
      _dropDownValue = selectedValue!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: MediaQuery.of(context).size.width / 2 - 40,
          decoration: BoxDecoration(
            color: AppColors.lightGray,
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButton(
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
            ),
            underline: Container(),
            value: _dropDownValue,
            items: widget.listItems
                .map((e) => DropdownMenuItem(
                      child: Text(e),
                      value: e,
                    ))
                .toList(),
            onChanged: selection,
            isExpanded: true,
          ),
        );
  }
}
