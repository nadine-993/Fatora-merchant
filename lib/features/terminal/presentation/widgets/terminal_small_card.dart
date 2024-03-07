import 'package:cached_network_image/cached_network_image.dart';
import 'package:fatora/features/client/data/models/client_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/api/http/api_urls.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';

class TerminalSmallCard extends StatelessWidget {
  const TerminalSmallCard({
    Key? key,
    required this.client,
    required this.terminalId,
  }) : super(key: key);

  final Client client;
  final String terminalId;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      clipBehavior: Clip.none,
      fit: StackFit.passthrough,
      children: [
        Positioned(
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.only(right: 10, left: 40),
              width: MediaQuery.of(context).size.width - 55.h,
              height: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: AppColors.cardGradient),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      client.name! ?? '',
                      maxLines: 2,
                      style: AppStyles.title.copyWith(
                          color: AppColors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Flexible(
                    child: Text('#$terminalId',
                        maxLines: 2,
                        style: AppStyles.title.copyWith(
                          color: AppColors.white,
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          child: Container(
            padding: const EdgeInsets.all(20),
            height: 60.h,
            width: 60.h,
            decoration: BoxDecoration(
                border: Border.all(),
                shape: BoxShape.circle,
                color: AppColors.white,
                image: DecorationImage(
                    image: CachedNetworkImageProvider(
                        '${ApiURLs.getClientLogo}${client.image}'))),
          ),
        ),
      ],
    );
  }
}
