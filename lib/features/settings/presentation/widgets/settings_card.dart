import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/constants/app_values.dart';
import '../../../../core/constants/helpers.dart';

class SettingsCard extends StatelessWidget {
  const SettingsCard({Key? key, required this.onTap, required this.title, required this.description}) : super(key: key);

  final VoidCallback onTap;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppPadding.p14),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Amount and status
                  Text(title,
                      style: AppStyles.title
                  ),

                  Height.v8,

                  // Date and time
                  FittedBox(
                    child: Text(description,
                      maxLines: 2,
                      style: AppStyles.title.copyWith(
                          overflow: TextOverflow.visible,
                          color: AppColors.darkGray
                      ),
                        ),
                  ),
                    ],
                  )
              ),

            // Arrow
            const Expanded(
                flex: 1,
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 15.0),
                  child: Icon(
                    Icons.navigate_next,
                    color: AppColors.secondary,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
