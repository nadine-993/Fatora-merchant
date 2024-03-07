import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/fatora_input.dart';

class CallbackInput extends StatelessWidget {
  const CallbackInput({
    super.key,
    required TextEditingController callbackController, this.isLast,
  }) : _callbackController = callbackController;

  final TextEditingController _callbackController;
  final bool? isLast;

  @override
  Widget build(BuildContext context) {
    return FatoraInput(
        label: AppStrings.callback,
        hint: AppStrings.callbackHint,
        isLast: isLast ?? false,
        textEditingController: _callbackController,
        prefixIcon: const Icon(Icons.link, color: AppColors.primary) ,
        inputType: TextInputType.url,
        validationType: ValidationType.empty
    );
  }
}