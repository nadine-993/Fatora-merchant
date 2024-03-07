import 'package:easy_localization/easy_localization.dart';
import 'package:fatora/core/constants/app_styles.dart';
import 'package:fatora/core/widgets/titled_widget.dart';
import 'package:flutter/material.dart';
import 'package:fatora/core/utils/extentions.dart';
import 'package:flutter/services.dart';


import '../constants/app_colors.dart';
import '../constants/app_input_style.dart';
import '../constants/app_values.dart';
import '../constants/helpers.dart';
import '../utils/validators/validators.dart';

enum InputSize { small, large }

enum ValidationType {
  none,
  empty,
  email,
  password,
}

class FatoraInput extends StatefulWidget {
  final String hint;
  final String? label;
  final Widget? labelWidget;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String errorText;
  final TextInputType inputType;
  final bool obscureText;
  final InputSize size;
  final int? maxLength;
  final bool isLast;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final void Function()? onEditingComplete;
  final TextEditingController textEditingController;
  final ValidationType validationType;
  final List<TextInputFormatter>? formatters;
  bool readOnly;
  late dynamic formValue;

  FatoraInput({
    Key? key,
    required this.textEditingController,
    this.inputType = TextInputType.text,
    this.errorText = "",
    this.hint = "",
    this.obscureText = false,
    this.size = InputSize.large,
    this.isLast = false,
    this.formValue,
    required this.prefixIcon,
    required this.validationType,
    this.suffixIcon,
    this.readOnly = false, this.onChanged, this.label, this.onFieldSubmitted, this.labelWidget, this.formatters, this.maxLength, this.onEditingComplete,
  }) : super(key: key);

  @override
  State<FatoraInput> createState() => _FatoraInputState();
}

class _FatoraInputState extends State<FatoraInput> {
  _getInputWidth(InputSize size, context) {
    switch (size) {
      case InputSize.small:
        return 160.0;
      case InputSize.large:
        return MediaQuery.of(context).size.width;
    }
  }

  _getValidation(BuildContext context, ValidationType type, String? input) {
    switch(type) {
      case ValidationType.email:
        return input.isValidEmail() ? null : "Incorrect Email Format.";

      case ValidationType.empty:
        return Validators.isEmptyValidator(input!) ? null : "emptyfieldError".tr();

      case ValidationType.password:
        if(input!.isEmpty) {
          return 'emptyfieldError'.tr();
        } else {
          return Validators.isPasswordValid(input!) ? null : "weakError".tr();
        }

      case ValidationType.none:
        return null;
    }
  }



@override
Widget build(BuildContext context) {
  return SizedBox(
    width: _getInputWidth(widget.size, context),
    child: widget.label != null ?
    TitledWidget(
      title: widget.labelWidget ?? Text(widget.label!, style: AppStyles.title,),
      child: TextFormField(
        onEditingComplete: widget.onEditingComplete,
        maxLength: widget.maxLength,
        maxLengthEnforcement: widget.maxLength != null ? MaxLengthEnforcement.enforced : null,
        validator: (input) => _getValidation(context, widget.validationType, input!),
        controller: widget.textEditingController,
        onSaved: (value) {
          widget.formValue = value;
        },
        inputFormatters: widget.formatters ?? [],
        onChanged: widget.onChanged != null ? widget.onChanged!(widget.textEditingController.text) : null,
        textInputAction:
        widget.isLast ? TextInputAction.done : TextInputAction.next,
        obscureText: widget.obscureText,
        keyboardType: widget.inputType,
        readOnly: widget.readOnly,
        onFieldSubmitted: widget.onFieldSubmitted ?? (value) {},
        decoration: AppInputStyle.getInputDecoration(
            hint: widget.hint,
            prefix:  widget.prefixIcon,
            suffix: widget.suffixIcon),
      ),
    )

        :
    TextFormField(
      onEditingComplete: widget.onEditingComplete,
      inputFormatters: widget.formatters ?? [],
      maxLength: widget.maxLength,
      validator: (input) => _getValidation(context, widget.validationType, input!),
      controller: widget.textEditingController,
      onSaved: (value) {
        widget.formValue = value;
      },
      onChanged: widget.onChanged != null ? widget.onChanged!(widget.textEditingController.text) : null,
      textInputAction:
      widget.isLast ? TextInputAction.done : TextInputAction.next,
      obscureText: widget.obscureText,
      keyboardType: widget.inputType,
      readOnly: widget.readOnly,
      decoration: AppInputStyle.getInputDecoration(
          hint: widget.hint,
          prefix: widget.prefixIcon,
          suffix: widget.suffixIcon),
    )

    ,
  );
}
}


class FatoraDesInput extends StatefulWidget {
  final String hint;
  final String? label;
  final Widget? labelWidget;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String errorText;
  final TextInputType inputType;
  final bool obscureText;
  final InputSize size;
  final int? maxLength;
  final bool isLast;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final void Function()? onEditingComplete;
  final TextEditingController textEditingController;
  final ValidationType validationType;
  final List<TextInputFormatter>? formatters;
  bool readOnly;
  late dynamic formValue;

  FatoraDesInput({
    Key? key,
    required this.textEditingController,
    this.inputType = TextInputType.text,
    this.errorText = "",
    this.hint = "",
    this.obscureText = false,
    this.size = InputSize.large,
    this.isLast = false,
    this.formValue,
    required this.prefixIcon,
    required this.validationType,
    this.suffixIcon,
    this.readOnly = false, this.onChanged, this.label, this.onFieldSubmitted, this.labelWidget, this.formatters, this.maxLength, this.onEditingComplete,
  }) : super(key: key);

  @override
  State<FatoraDesInput> createState() => _FatoraDesInputState();
}

class _FatoraDesInputState extends State<FatoraDesInput> {
  _getInputWidth(InputSize size, context) {
    switch (size) {
      case InputSize.small:
        return 160.0;
      case InputSize.large:
        return MediaQuery.of(context).size.width;
    }
  }

  _getValidation(BuildContext context, ValidationType type, String? input) {
    switch(type) {
      case ValidationType.email:
        return input.isValidEmail() ? null : "Incorrect Email Format.";

      case ValidationType.empty:
        return Validators.isEmptyValidator(input!) ? null : "emptyfieldError".tr();

      case ValidationType.password:
        if(input!.isEmpty) {
          return 'emptyfieldError'.tr();
        } else {
          return Validators.isPasswordValid(input!) ? null : "weakError".tr();
        }

      case ValidationType.none:
        return null;
    }
  }



@override
Widget build(BuildContext context) {
  return SizedBox(
    width: _getInputWidth(widget.size, context),
    child: widget.label != null ?
    TitledWidget(
      title: widget.labelWidget ?? Text(widget.label!, style: AppStyles.title,),
      child: TextFormField(
        onEditingComplete: widget.onEditingComplete,
        maxLength: widget.maxLength,
        maxLengthEnforcement: widget.maxLength != null ? MaxLengthEnforcement.enforced : null,
        validator: (input) => _getValidation(context, widget.validationType, input!),
        controller: widget.textEditingController,
        onSaved: (value) {
          widget.formValue = value;
        },
        inputFormatters: widget.formatters ?? [],
        onChanged: widget.onChanged != null ? widget.onChanged!(widget.textEditingController.text) : null,
        textInputAction:
        widget.isLast ? TextInputAction.done : TextInputAction.next,
        obscureText: widget.obscureText,
        keyboardType: widget.inputType,
        readOnly: widget.readOnly,
        onFieldSubmitted: widget.onFieldSubmitted ?? (value) {},
        maxLines: 4,
        textAlignVertical: TextAlignVertical.center,
        decoration: AppInputStyle.getInputDesDecoration(

            hint: widget.hint,
            prefix:  widget.prefixIcon,
            suffix: widget.suffixIcon),
      ),
    )

        :
    TextFormField(
      onEditingComplete: widget.onEditingComplete,
      inputFormatters: widget.formatters ?? [],
      maxLength: widget.maxLength,
      validator: (input) => _getValidation(context, widget.validationType, input!),
      controller: widget.textEditingController,
      onSaved: (value) {
        widget.formValue = value;
      },
      onChanged: widget.onChanged != null ? widget.onChanged!(widget.textEditingController.text) : null,
      textInputAction:
      widget.isLast ? TextInputAction.done : TextInputAction.next,
      obscureText: widget.obscureText,
      keyboardType: widget.inputType,
      readOnly: widget.readOnly,
      decoration: AppInputStyle.getInputDecoration(
          hint: widget.hint,
          prefix: widget.prefixIcon,
          suffix: widget.suffixIcon),
    )

    ,
  );
}
}