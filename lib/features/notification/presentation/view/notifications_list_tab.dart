import 'package:flutter/material.dart';

import '../../../../core/boilerplate/pagination/widgets/pagination_list.dart';
import '../../../../core/constants/helpers.dart';
import '../../data/model/notification_model.dart';
import '../../data/model/notifications_request_model.dart';
import '../../domain/repository/notifications_repo.dart';
import '../widget/notification_card.dart';

class NotificationsListTab extends StatelessWidget {
  const NotificationsListTab({Key? key, required this.terminalId}) : super(key: key);

  final String? terminalId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Height.v16,
        Expanded(
          child: PaginationList<NotificationModel>(
            repositoryCallBack: (data) =>
                NotificationsRepo.getNotifications(
                  data,
                  NotificationsRequestModel(
                    terminalId: terminalId,
                  ),
                ),
            listBuilder: (List<NotificationModel> notifications) {
              return  ListView.separated(
                  separatorBuilder: (context, number) => Height.v8,
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    return NotificationCard(
                      notification: notifications[index]
                    );
                  }
              );
            },
          ),
        ),
      ],
    );
  }
}
