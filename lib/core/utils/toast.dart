import 'package:fatora/core/constants/app_colors.dart';
import 'package:fatora/core/constants/app_icons.dart';
import 'package:fatora/core/constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:m_toast/m_toast.dart';

enum ToastType {
  informative,
  success,
  error,
}

class Toasts {
  static void show(BuildContext context, String message, ToastType type) {
    ShowMToast toast = ShowMToast(context);

    const Alignment alignment = FractionalOffset(0.0, 0.95);

    switch (type) {
      case ToastType.informative:
        toast.successToast(
            elevation: context,
            icon: AppIcons.informative,
            iconColor: AppColors.secondary,
            backgroundColor: const Color(0xffc3e9f4),
            message: message,
            alignment: alignment,
            duration: 2500
        );
        break;
      case ToastType.success:
        toast.successToast(
            elevation: context,
            message: message,
            alignment: alignment,
            duration: 2500
        );
        break;
      case ToastType.error:
        toast.errorToast(
            elevation: context,
            icon: AppIcons.error,
            message: message,
            alignment: alignment,
            duration: 2500
        );
        break;
      default:
    }

  }



  static void showToast(String message, ToastType type) {
    Color backgroundColor;
    Color textColor;

    switch (type) {
      case ToastType.informative:
        backgroundColor = AppColors.secondary;
        textColor = Colors.white;
        break;
      case ToastType.success:
        backgroundColor = AppColors.approvedBg;
        textColor = Colors.white;
        break;
      case ToastType.error:
        backgroundColor = AppColors.failedBg;
        textColor = Colors.white;
        break;
      default:
        backgroundColor = Colors.grey;
        textColor = Colors.white;
    }

    Fluttertoast.showToast(
      msg: message.replaceAll('\n', ''),
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
    );
  }
}

