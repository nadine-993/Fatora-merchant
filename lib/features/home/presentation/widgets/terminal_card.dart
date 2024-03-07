import 'package:fatora/core/api/http/api_urls.dart';
import 'package:fatora/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:fatora/core/constants/app_colors.dart';
import 'package:fatora/core/constants/app_icons.dart';
import 'package:fatora/core/constants/helpers.dart';
import 'package:fatora/features/payment/presentation/views/add_payment_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/notification/data/get_unread_notifications_response.dart';
import '../../../../core/notification/domin/repository/notification_repository.dart';
import '../../../../core/utils/di.dart';
import '../../../../core/utils/navigation.dart';
import '../../../../core/utils/shared_perefrences/shared_perefrences_helper.dart';
import '../../../client/data/models/client_model.dart';
import '../../../terminal/presentation/views/terminal_page.dart';



class TerminalCard extends StatefulWidget {
  const TerminalCard({Key? key, required this.client ,required this.terminal,required this.size}) : super(key: key);

  final double size;
  final Client client;
  final String terminal;

  @override
  State<TerminalCard> createState() => _TerminalCardState();
}

class _TerminalCardState extends State<TerminalCard> {
  static final AppPreferences _appPreferences = instance<AppPreferences>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        getTerminalCard(context),

        _getAddButton(context),

        NotificationBadge(terminal: widget.terminal,)
      ],
    );
  }

  Positioned _getAddButton(BuildContext context) {
    return Positioned(
        right: _appPreferences.getLanguage() == 'en' ? 0 : null,
        left: _appPreferences.getLanguage() == 'ar' ? 0 : null,
        child: GestureDetector(
          onTap: () {
            Navigation.push(context,  AddPaymentPage(
              fromHomePage: true,
              client: widget.client,
              terminal: widget.terminal,
            ));
          },
          child: Container(
            height: 55,
            width: 55,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary
            ),
            child: const Icon(AppIcons.payment, color: AppColors.white, size: 30,),
          ),
        ),
      );
  }

  Align getTerminalCard(BuildContext context) {
    return Align(
      alignment: _appPreferences.getLanguage() == 'ar' ? Alignment.centerRight :Alignment.centerLeft,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
          onTap: () {
            Navigation.push(context, TerminalPage(
              clearFilter: true,
              client: widget.client,
              terminalId: widget.terminal,
            ));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.centerLeft,
            height: 112,
            width: widget.size - 50,
            decoration: _getCardStyle(),
            child: Row(
              children: [

                _getMerchantLogo(),

                Width.v10,

                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Merchant Name
                      Text(
                        widget.client.name ?? '',
                        maxLines: 2,
                        style: AppStyles.title.copyWith(
                            color: AppColors.white, fontWeight: FontWeight.w600),
                      ),
                      Height.v8,
                      // Merchant Terminal number
                      Text(
                        '#${widget.terminal}',
                        style: AppStyles.title.copyWith(
                            color: AppColors.white, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }

  BoxDecoration _getCardStyle() {
    return BoxDecoration(
             image:  DecorationImage(
                  fit: BoxFit.contain,
                  alignment:  _appPreferences.getLanguage() == 'ar' ? Alignment.centerLeft : Alignment.centerRight,
                  image: const AssetImage(
                      AppAssets.pos,
                  )
              ),
              borderRadius: BorderRadius.circular(20),
              gradient: _appPreferences.getLanguage() == 'ar' ? AppColors.cardGradientReversed : AppColors.cardGradient
          );
  }

  Container _getMerchantLogo() {
    return Container(
                height: 70.h,
                width: 70.h,
                decoration:  BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white,
                    image: DecorationImage(
                        image: NetworkImage('${ApiURLs.getClientLogo}${widget.client.image}')
                    )
                ),
              );
  }
}

class NotificationBadge extends StatefulWidget {
  const NotificationBadge({Key? key, required this.terminal}) : super(key: key);
  final String terminal;
  @override
  State<NotificationBadge> createState() => _NotificationBadgeState();
}

class _NotificationBadgeState extends State<NotificationBadge> {
  double badgeSize = 27;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -10,
      left: 0,
      child: GetModel<GetUnreadNotificationsResponse>(
        repositoryCallBack: (data) => NotificationRepository.getUnreadNotifications(widget.terminal),
        loading: const SizedBox.shrink(),
        modelBuilder: (model) {
          return
            model.count == 0 ?
            const SizedBox.shrink() :
            Container(
                alignment: Alignment.center,
                height: badgeSize,
                width: badgeSize,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.failedBg
                ),
                child: Text(model.count.toString() ?? '', style: AppStyles.title.copyWith(
                    color: AppColors.white
                )));
        },
      ),
    );
  }
}

