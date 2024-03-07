import 'package:fatora/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../constants/app_values.dart';


class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(AppPadding.p12),
        decoration: const BoxDecoration(
          color: AppColors.midGray,
          shape: BoxShape.circle,
        ),
        child: LoadingAnimationWidget.flickr(
            leftDotColor: AppColors.primary,
            rightDotColor: AppColors.secondary,
            size: 45
        ),
      ),
    );
  }
}
