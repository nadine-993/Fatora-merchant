import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';

class PaymentRow extends StatelessWidget {
  const PaymentRow({Key? key, this.title, this.value, this.widget, this.color, this.isFlexible = true}) : super(key: key);

  final String? title;
  final Widget? widget;
  final String? value;
  final Color? color;
  final bool isFlexible;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Text(title! ?? '',
                maxLines: 4,
                style: AppStyles.title.copyWith(
                    color: color ?? AppColors.darkGray
                )),
          ),

          widget != null ? widget! :
          isFlexible ?
          Flexible(
            child: Text(value! ?? '',
                textAlign: TextAlign.end,
                maxLines: 4,
                style: AppStyles.title
            ),
          ) :
          Text(value! ?? '',
              textAlign: TextAlign.end,
              style: AppStyles.title
          ),
        ],
      ),
    );
  }
}
