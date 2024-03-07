import 'package:fatora/core/constants/app_styles.dart';
import 'package:fatora/core/constants/helpers.dart';
import 'package:fatora/features/notification/data/model/notification_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/methods/methods.dart';
import '../../../../core/notification/domin/repository/notification_repository.dart';

class NotificationCard extends StatefulWidget {
  final NotificationModel notification;

  const NotificationCard({super.key,
    required this.notification,
  });

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  bool isExpanded = false;

  Color _getIconColor() {
    if (widget.notification.type == "A") {
      return AppColors.green;
    } else if (widget.notification.type == "F") {
      return AppColors.red;
    }
    return AppColors.darkGray;
  }

  IconData _getIcon() {
    if (widget.notification.type == "A") {
      return Icons.check_circle_rounded;
    } else if (widget.notification.type == "F") {
      return  Icons.cancel;
    }
    return Icons.check_circle_rounded;
  }

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
        NotificationRepository.readNotification(widget.notification.id ?? 0);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightGray,
          border: Border.all(color: AppColors.midGray),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration:  BoxDecoration(
                shape: BoxShape.circle,
                color: _getIconColor()
              ),
              child: Icon(
                _getIcon(),
                color: AppColors.white,
                size: 30,
              ),
            ),
            Width.v12,
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.notification.title ?? '',
                        style: AppStyles.title.copyWith(
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      Text(
                        Methods.getDate(widget.notification.sendDate),
                        style: AppStyles.body.copyWith(
                            color: AppColors.darkerGray
                        ),
                      ),
                    ],
                  ),
                  Text(
                    widget.notification.body ?? '',
                    maxLines: isExpanded == true ? 10 : 2,
                    style: AppStyles.title,
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
