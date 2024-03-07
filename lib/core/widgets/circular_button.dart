import 'package:fatora/core/constants/app_colors.dart';
import 'package:fatora/core/constants/app_icons.dart';
import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  const CircularButton({Key? key, required this.onPressed}) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: AppColors.primary,
      child: const Icon(AppIcons.payment, size: 30,),
    );
  }
}
