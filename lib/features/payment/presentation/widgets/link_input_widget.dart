import 'package:fatora/core/constants/app_assets.dart';
import 'package:fatora/core/constants/app_icons.dart';
import 'package:fatora/core/constants/app_strings.dart';
import 'package:fatora/core/constants/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_share/social_share.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/utils/toast.dart';
import '../../../../core/widgets/fatora_input.dart';
import '../../../../core/widgets/titled_widget.dart';

class LinkWidget extends StatefulWidget {
  const LinkWidget({
    super.key, required this.title, required this.value,
  });

  final String title;
  final String value;

  @override
  State<LinkWidget> createState() => _LinkWidgetState();
}

class _LinkWidgetState extends State<LinkWidget> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FatoraInput(
          label: widget.title,
          textEditingController: TextEditingController.fromValue(
              TextEditingValue(
                  text: widget.value ?? '')),
          readOnly: true,
          validationType: ValidationType.empty,
          prefixIcon: const Icon(Icons.link, color: AppColors.primary) ,
          suffixIcon: IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: widget.value,));
                Toasts.showToast(AppStrings.copied, ToastType.informative);
              },
              icon: const Icon(Icons.copy)
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(onPressed: () async{
              await SocialShare.shareTelegram(widget.value);
            }, icon: const Icon(Icons.telegram, color: AppColors.secondary, size: 25,)),

            IconButton(onPressed: () async{
              await SocialShare.shareWhatsapp(widget.value);
            }, icon: const Image(image: AssetImage(AppAssets.whatsapp,),
              height: 22,
              width: 22,
            )
            ),

            Width.v12,

            GestureDetector(
              onTap: () async{
                await SocialShare.shareOptions(widget.value);
              },
              child: Row(
                  children:  [
                    const Icon(AppIcons.share, color: AppColors.secondary, size: 20,),
                    Width.v4,
                    Text(AppStrings.share, style: AppStyles.body.copyWith(
                        color: AppColors.secondary
                    ),),
                  ]
              ),

            ),
          ],
        )
      ],
    );
  }
}