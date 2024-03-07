import 'package:easy_localization/easy_localization.dart';
import 'package:fatora/core/widgets/common_appbar.dart';
import 'package:fatora/core/widgets/padding_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/boilerplate/get_model/widgets/get_model.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/constants/helpers.dart';
import '../../../../core/utils/launchers.dart';
import '../../../splash/presentation/pages/splash_screen.dart';
import '../../data/models/check_update_response_model.dart';
import '../../domain/repository/settings_repo.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBars.inner('about'.tr()),
        body: GetModel<CheckUpdateResponseModel>(
          repositoryCallBack: (_) => SettingsRepository.checkUpdate(Constants.APP_VERSION),
          modelBuilder: (model) {
            return PaddingWidget(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Height.v24,

                    Row(
                      children: [
                        MerchantLogo(
                          height: 40.h,
                          width: 40.h,
                        ),
                        Width.v8,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(Constants.APP_NAME,
                                style: AppStyles.title
                                    .copyWith(fontWeight: FontWeight.bold)),
                            Text(Constants.APP_VERSION, style: AppStyles.title),
                          ],
                        )
                      ],
                    ),

                    Height.v24,

                    model.availableUpdate! ?
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Height.v12,

                        Text('System update available', style: AppStyles.title.copyWith(
                          fontWeight: FontWeight.bold
                        ),),
                        Height.v8,

                        Text(
                          model.isMajor! ? 'Your current version of Fatora Merchant App is expired' :
                          'A newer Version of Fatora Merchant App (v${model.version}) is available',
                          style: AppStyles.body.copyWith(
                            overflow: TextOverflow.visible,
                          ),
                        ),
                        Height.v12,

                        Text("What's New?", style: AppStyles.title.copyWith(
                            fontWeight: FontWeight.bold
                        ),),
                        Height.v8,

                        Text(
                          model.description ?? '',
                          style: AppStyles.body.copyWith(
                            overflow: TextOverflow.visible,
                          ),
                        ),

                        Height.v12,

                        InkWell(
                          onTap: () {
                            Launchers.launchWebUrl(model.url ?? 'fatora.com');
                          },
                          child: Column(
                            children: [
                              const Divider(),
                              Height.v8,

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.download, size: 20,),
                                  Width.v12,
                                  Text('Download and install', style: AppStyles.title,),
                                ],
                              ),
                              Height.v8,

                              const Divider(),
                            ],
                          ),
                        ),
                      ],
                    ) :  Text('thelatestversion'.tr(), style: AppStyles.title.copyWith(
                        overflow: TextOverflow.visible
                    ),),


                  ],
                ));
          }
        ));
  }
}
