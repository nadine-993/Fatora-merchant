import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../constants/app_styles.dart';
import '../constants/helpers.dart';

class ResendOtp extends StatelessWidget {
  const ResendOtp({
    super.key, required this.resendFunction,
  });

  final VoidCallback resendFunction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.didntReceive,
          style: AppStyles.body,
        ),

        Width.v4,

        TextButton(onPressed: resendFunction, child:  Text(AppStrings.resend))
      ],
    );
  }
}
