import 'package:fatora/core/constants/app_colors.dart';
import 'package:fatora/core/constants/app_styles.dart';
import 'package:fatora/core/constants/helpers.dart';
import 'package:fatora/core/widgets/confirmation_popup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../constants/constants.dart';
import '../utils/navigation.dart';


class MultiDatePicker extends StatefulWidget {
  final String hintText;
  final String selectedValue;
  final IconData suffixIcon;
  final Function(Object?) onSubmit;
  DateTime startDate;
  DateTime endDate;

  MultiDatePicker(
      {Key? key,
        required this.hintText,
        required this.suffixIcon, required this.selectedValue, required this.onSubmit, required this.startDate, required this.endDate,
      })
      : super(key: key);

  @override
  _MultiDatePickerState createState() => _MultiDatePickerState();
}

class _MultiDatePickerState extends State<MultiDatePicker> {

  var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showDialog();
      },
      child: Container(
        height: 65,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.lightGray,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children:  [
            Width.v4,
            const Icon(Icons.date_range, color: AppColors.primary,),
            Width.v16,
            Flexible(child: Text(widget.hintText, style: AppStyles.title)),

          ],
        ),
      ),
    );
  }

  DateTime? _startDate = Constants.defaultStartDate;
  DateTime? _endDate = Constants.defaultEndDate;


  void _showDialog() {
    Dialogs.datePickerPopup(
        isEnabled: (widget.startDate != null && widget.endDate != null) ? true : false,
        context: context,
        content: Container(
          padding: const EdgeInsets.only(top: 6.0),
          // The Bottom margin is provided to align the popup above the system
          // navigation bar.
          margin: EdgeInsets.only(
            bottom: MediaQuery
                .of(context)
                .viewInsets
                .bottom,
          ),
          // Provide a background color for the popup.
          color: CupertinoColors.systemBackground.resolveFrom(context),
          // Use a SafeArea widget to avoid system overlaps.
          child: SfDateRangePicker(

            showActionButtons: true,
            view: DateRangePickerView.month,
            selectionMode: DateRangePickerSelectionMode.range,

            monthViewSettings: const DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
            initialSelectedRange: PickerDateRange(
              widget.startDate,
              widget.endDate
           ),

            onSubmit: widget.onSubmit,
            onCancel: () {
              Navigation.pop(context);
            },
            onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
              setState(() {
                widget.startDate = args.value.startDate;
                widget.endDate = args.value.endDate;
              });
            },
          ),
        ),
    );

  }
}