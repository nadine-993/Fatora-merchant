import 'package:fatora/core/utils/navigation.dart';
import 'package:fatora/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../constants/app_styles.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Future.delayed(Duration.zero, () {
            Navigation.pushReplacement(context, HomePage());
          });

        },
        child: Padding(
          padding:  EdgeInsets.only(bottom: 60.0.h),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                    AppAssets.errorWidget,
                    repeat: false,
                    height: 75.h
                ),
                Text(AppStrings.wentWrong, style: AppStyles.headline.copyWith(
                    color: AppColors.black
                ),),

                Icon(Icons.refresh_outlined, size: 30.h, color: AppColors.black,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
