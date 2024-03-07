import 'package:fatora/core/constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

import '../constants/app_colors.dart';

class OtpWidget extends StatefulWidget {
  const OtpWidget({
    super.key,
    required this.onCompleted, this.focusNode, this.textEditingController,
  });

  final void Function(String)? onCompleted;
  final FocusNode? focusNode;
  final TextEditingController? textEditingController;

  @override
  State<OtpWidget> createState() => _OtpWidgetState();
}

class _OtpWidgetState extends State<OtpWidget> {

  @override
  Widget build(BuildContext context) {
    return Pinput(
      controller: widget.textEditingController,
        keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        ],
        //autofocus: true,
        autofocus: true,
        defaultPinTheme: PinTheme(
          width: 56,
          height: 56,
          textStyle: AppStyles.headline.copyWith(color: AppColors.primary),
          decoration: BoxDecoration(
            color: AppColors.lightGray,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        enabled: true,
        length: 5,
        scrollPadding: EdgeInsets.zero,
        androidSmsAutofillMethod:
        AndroidSmsAutofillMethod.smsRetrieverApi,
        smsCodeMatcher: PinputConstants.defaultSmsCodeMatcher,
        onCompleted: widget.onCompleted
      /*(value) {
          _autoFocus = false;
          widget.onCompleted;
        }*/
    );
  }
}
