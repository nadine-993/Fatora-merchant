import 'package:fatora/core/constants/app_styles.dart';
import 'package:fatora/core/constants/helpers.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class StatisticsCard extends StatelessWidget {
  const StatisticsCard({Key? key, required this.icon, required this.title, required this.body}) : super(key: key);

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 150,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        color: AppColors.lightGray
          ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          Icon(icon, color: AppColors.secondary,),
          Height.v12,
          Text(
            title,
            style: AppStyles.title,
          ),
          Text(
            body,
            style: AppStyles.headline.copyWith(
              color: AppColors.primary
            ),
          ),
        ],
      ),

      );
  }
}
