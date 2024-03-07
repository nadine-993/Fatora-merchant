import 'package:fatora/core/constants/app_assets.dart';
import 'package:fatora/core/constants/app_strings.dart';
import 'package:fatora/core/constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class NoDataWidget extends StatefulWidget {
  const NoDataWidget({Key? key}) : super(key: key);

  @override
  State<NoDataWidget> createState() => _NoDataWidgetState();
}

class _NoDataWidgetState extends State<NoDataWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(bottom: 80.0.h),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
                AppAssets.noDataWidget,
                repeat: false,
                height: 150.h
            ),
            Text(AppStrings.noData, style: AppStyles.headline,)
          ],
        ),
      ),
    );
  }
}
