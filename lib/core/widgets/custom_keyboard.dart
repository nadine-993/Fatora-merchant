import 'package:easy_localization/easy_localization.dart';
import 'package:fatora/core/constants/app_colors.dart';
import 'package:fatora/core/constants/app_styles.dart';
import 'package:fatora/core/constants/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomKeyboard extends StatelessWidget {
  final Function(String) onKeyPressed;
  final VoidCallback onSuccess;
  final VoidCallback onClear;
  final VoidCallback onBackspace;

  const CustomKeyboard({super.key, required this.onKeyPressed, required this.onSuccess, required this.onClear, required this.onBackspace});

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) {
          EasyLocalization.of(context)?.fallbackLocale;
          return Container(
            padding: const EdgeInsets.all(15.0),
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    KeyButton('1', onKeyPressed),
                    KeyButton('2', onKeyPressed),
                    KeyButton('3', onKeyPressed),
                    ActionKeyboardButton(iconData: Icons.check_circle_rounded, color: AppColors.transparent, onKeyPressed: () {}, iconColor: Colors.transparent,),
                  ],
                ),
                Height.v8,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    KeyButton('4', onKeyPressed),
                    KeyButton('5', onKeyPressed),
                    KeyButton('6', onKeyPressed),
                    ActionKeyboardButton(iconData: Icons.clear, color: AppColors.red, onKeyPressed: onClear,),
                  ],
                ),
                Height.v8,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    KeyButton('7', onKeyPressed),
                    KeyButton('8', onKeyPressed),
                    KeyButton('9', onKeyPressed),
                    ActionKeyboardButton(iconData: Icons.backspace, color: AppColors.yellow, onKeyPressed: onBackspace,),
                  ],
                ),
                Height.v8,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    KeyButton('00', onKeyPressed),
                    KeyButton('0', onKeyPressed),
                    KeyButton('000', onKeyPressed),
                    ActionKeyboardButton(iconData: Icons.check_circle_rounded, color: AppColors.green, onKeyPressed: onSuccess,),
                  ],
                ),
              ],
            ),
          );
        }
    );
  }
}

class ActionKeyboardButton extends StatelessWidget {
  final VoidCallback onKeyPressed;
  final Color color;
  final Color iconColor;
  final IconData iconData;

  const ActionKeyboardButton({super.key, required this.onKeyPressed, this.color = AppColors.primary, this.iconColor = Colors.white, required this.iconData, });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onKeyPressed,
      child: Container(
        width: 60.w,
        height: 45.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: color,
        ),
        child: Center(
          child: Icon(
            iconData,
            color: iconColor,
            size: 30,
            ),
          ),
        ),
    );
  }
}

class KeyButton extends StatelessWidget {
  final String text;
  final Function(String) onKeyPressed;
  final Color color;

  const KeyButton(this.text, this.onKeyPressed, {super.key, this.color = AppColors.primary});

  @override
  Widget build(BuildContext context) {
    return InkWell(

      onTap: () => onKeyPressed(text),
      child: Container(
        width: 65.w,
        height: 45.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: color,
        ),
        child: Center(
          child: Text(
            text,
            style: AppStyles.headline.copyWith(
              color: AppColors.white,
              fontSize: 22
            ),
          ),
        ),
      ),
    );
  }
}
