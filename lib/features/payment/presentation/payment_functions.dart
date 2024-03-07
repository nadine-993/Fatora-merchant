import 'package:easy_localization/easy_localization.dart';
import 'package:fatora/core/constants/app_assets.dart';
import 'package:fatora/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/constants/helpers.dart';

class PaymentFunctions {
  static Map<String, String> statuesLetters = {
    'Approved': 'A',
    'Pending': 'P',
    'Reversed': 'R',
    'Cancelled': 'C',
    'Failed': 'F',
  };


  static Map<String, String> statuesNames = {
     'A': 'Approved',
     'P': 'Pending',
     'R': 'Reversed',
     'C': 'Cancelled',
     'F': 'Failed',
  };

  static Map<String, Color> statuesTextColors = {
    'A' : AppColors.approvedBg,
    'P': AppColors.pendingBg,
    'R': AppColors.reversedBg,
    'C': AppColors.cancelledBg,
    'F': AppColors.failedBg,
  };

  static Map<String, Color> statuesBgColors = {
    'A' : AppColors.approved,
    'P': AppColors.pending,
    'R': AppColors.reversed,
    'C': AppColors.cancelled,
    'F': AppColors.failed,
  };

  static Map<String, String> statusIcons = {
    'A' : AppAssets.approved,
    'P': AppAssets.pending,
    'R': AppAssets.reversed,
    'C': AppAssets.cancelled,
    'F': AppAssets.failed,
  };

  static Map<String, List<PopupMenuEntry<int>>> statusMenu = {
    'A' : [
       PopupMenuItem(
        value: 1,
        child: Text(AppStrings.reverse),
      ),
    ],
    'P': [
       PopupMenuItem(
        value: 2,
        child: Text(AppStrings.cancelPayment),
      ),
    ],
    'R': [],
    'C': [],
    'F': [],
  };

  static List<String> getStatusLetter(List<String> statues) {
    List<String?> statuesWithNull = statues.map((status) => statuesLetters[status]).toList();
    List<String> listWithoutNulls = statuesWithNull.whereType<String>().toList();
    return listWithoutNulls;

  }

  static List<String> getStatusNames(List<String> statues) {
    List<String?> statuesWithNull = statues.map((status) => statuesNames[status]).toList();
    List<String> listWithoutNulls = statuesWithNull.whereType<String>().toList();
    return listWithoutNulls;
  }


  static Widget getStatusWidget(String status) {
    String statusText = statuesNames[status] ?? '';
    Color statusBgColor = statuesBgColors[status] ?? Colors.transparent;
    Color statusTextColor = statuesTextColors[status] ?? Colors.transparent;

    return Container(
      width: 110,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: statusBgColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
          statusIcons[status]!,
          semanticsLabel: '',
          color: statusTextColor,
            theme: SvgTheme(
              currentColor: statusTextColor
            ),
          ),

          Width.v8,

          Text(statusText, style: AppStyles.body.copyWith(
              color: statusTextColor,
              fontWeight: FontWeight.w600
          ),),
        ],
      ),
    );
  }



}