import 'package:easy_localization/easy_localization.dart';
import 'package:fatora/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:fatora/core/constants/app_colors.dart';
import 'package:fatora/core/constants/constants.dart';
import 'package:fatora/core/utils/navigation.dart';
import 'package:fatora/core/widgets/padding_widget.dart';
import 'package:flutter/services.dart';
import 'package:fatora/core/constants/app_strings.dart';
import 'package:fatora/core/constants/app_styles.dart';
import 'package:fatora/core/constants/app_values.dart';
import 'package:fatora/core/constants/helpers.dart';
import 'package:fatora/core/utils/launchers.dart';
import 'package:fatora/core/widgets/custom_button.dart';
import 'package:fatora/core/widgets/loading_widget.dart';
import 'package:fatora/features/settings/domain/repository/settings_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:social_share/social_share.dart';

import '../../features/settings/data/models/check_update_response_model.dart';
import '../constants/app_assets.dart';
import '../constants/app_icons.dart';
import 'html_viewer.dart';

class Dialogs {
  static Future<void> confirmationPopup({
    required BuildContext context,
    required String confirmation,
    required VoidCallback onTap,
    Widget? confirmationButton,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: RichText(
            text: TextSpan(
              text: '${AppStrings.confirmation} ',
              style: AppStyles.title.copyWith(
                  overflow: TextOverflow.visible, color: AppColors.black),
              children: <TextSpan>[
                TextSpan(
                    text: confirmation,
                    style: AppStyles.title.copyWith(
                        overflow: TextOverflow.visible,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black)),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: const EdgeInsets.only(bottom: 25),
          actions: <Widget>[
            confirmationButton ??
                CustomButton(
                  text: 'yes'.tr(),
                  height: AppSize.s45,
                  onTap: onTap,
                  size: ButtonSize.small,
                  buttonColor: AppColors.secondary,
                  enabled: true,
                  hasLoading: true,
                ),
            CustomButton(
              type: ButtonType.bordered,
              height: AppSize.s45,
              text: 'cancel'.tr(),
              onTap: () {
                Navigator.pop(context);
              },
              size: ButtonSize.small,
              enabled: true,
              buttonColor: Colors.transparent,
              textColor: AppColors.red,
            ),
          ],
        );
      },
    );
  }


  static Future<void> createPaymentPopup({
    required BuildContext context,
    required Function onGenerateLinkTap,
    required Function onFlash,
    required Widget qrWidget,
  }) async {
    bool isEnabled = true;
    bool isFlashOn = false;
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                      child: Text(
                        'scanQR'.tr(),
                        style: AppStyles.title,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: StatefulBuilder(
                        builder: (stfContext, stfSetState) {
                          return IconButton(
                              padding: EdgeInsets.zero,
                              alignment: Alignment.centerRight,
                              onPressed: () {
                                stfSetState(() {
                                  onFlash();
                                  isFlashOn = !isFlashOn;
                                });
                              },
                              icon: Icon(isFlashOn ? Icons.flash_on : Icons.flash_off, color: isFlashOn ? Colors.orangeAccent : AppColors.darkGray));
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 200.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          height: 200.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: qrWidget),
                    ],
                  ),
                ),
                Height.v12,

                Center(
                  child: Text(
                    'Or',
                    style: AppStyles.title.copyWith(color: AppColors.darkGray),
                  ),
                ),
                Height.v12,
                GenerateLinkButton(
                  onTap: () {
                    onGenerateLinkTap();
                    isEnabled = false;
                  },
                ),
                Height.v12,
              ]
            ),
          ),
        );
      },
    );
  }

  static void _getQRPopup(
      BuildContext context, Widget qrWidget, Function onFlash, bool isFlashOn) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'QR Scan',
                      style: AppStyles.headline,
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            onFlash();
                            isFlashOn = !isFlashOn;
                          });
                        },
                        icon: Icon(isFlashOn ? Icons.flash_on : Icons.flash_off))
                  ],
                )),
                content: SizedBox(
                  height: 250.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          height: 200.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: qrWidget),
                      Height.v12,
                      Text(
                        'Place the camera on the QR to be scanned automatically',
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        style: AppStyles.title,
                      )
                    ],
                  ),
                ),
              );
            }
          );
        });
  }

  static Future<void> datePickerPopup({
    required BuildContext context,
    required Widget content,
    bool isEnabled = false,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: SizedBox(height: 360, width: 240, child: content),
        );
      },
    );
  }

  static Future<void> updateApp({
    required BuildContext context,
    required bool isMajor,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return GetModel<CheckUpdateResponseModel>(
          repositoryCallBack: (_) => SettingsRepository.checkUpdate(Constants.APP_VERSION),
          onSuccess: (model){
            if(!model.availableUpdate!) {
              Navigation.pop(context);
            }
          },
          modelBuilder: (model) {
            return
              WillPopScope(
              onWillPop: () async {
                return isMajor;
              },
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Height.v12,
                      model.availableUpdate! ?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model.isMajor! ? 'Your current version of Fatora Merchant App is expired' :
                            'A newer Version of Fatora Merchant App (v${model.version}) is available',
                            style: AppStyles.title.copyWith(
                            overflow: TextOverflow.visible,
                          ),),
                          Height.v24,
                          Center(
                            child: Wrap(
                              runSpacing: 8,
                              children: [
                                CustomButton(text: 'Update',
                                  width: 100.w,
                                  iconData: AppIcons.update,
                                  onTap: () {
                                  Launchers.launchWebUrl(model.url ?? 'fatora.com');
                                }, enabled: true,),

                                Width.v12,

                                CustomButton(text: 'Close',
                                  width: 100.w,
                                  type: ButtonType.bordered,
                                  textColor: AppColors.red,
                                  buttonColor: AppColors.transparent,
                                  iconData: AppIcons.close,
                                  onTap: () {
                                  if(model.isMajor!) {
                                    SystemNavigator.pop();
                                  }
                                  else {
                                    Navigation.pop(context);
                                  }
                                  }, enabled: true,),
                              ],
                            ),
                          )
                        ],
                      )
                      : const SizedBox.shrink(),

                    ],
                  ),
                ),
              ),
            );
          }
        );
      },
    );
  }

  static Future<void> loading({
    required BuildContext context,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            // Return true to allow the user to close the dialog
            // Return false to prevent the user from closing the dialog
            return false;
          },
          child:  Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: SizedBox(
                height: 100.h,
                width: 50.w,
                child: const LoadingWidget()),
          ),
        );
      },
    );
  }

  static Future<void> success({
    required BuildContext context,
    String? message,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            // Return true to allow the user to close the dialog
            // Return false to prevent the user from closing the dialog
            return false;
          },
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Height.v16,
                  Lottie.asset(AppAssets.success,
                      repeat: false,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover),
                  Height.v8,
                  Center(
                      child: Text(
                    message ?? 'Success!',
                    style: AppStyles.headline,
                  )),
                  Height.v16,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<void> paymentSuccess({
    required BuildContext context,
    String? message,
    VoidCallback? onPressed,
    String? paymentId,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Dialog(
            //insetPadding: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Height.v16,

                      Lottie.asset(AppAssets.success,
                          width: 100,
                          height: 100,
                          repeat: false,
                          fit: BoxFit.cover),
                      Height.v8,
                      Center(
                          child: Text(
                            message ?? 'Successful Payment',
                            style: AppStyles.headline,
                          )),
                      Height.v16,
                      PaddingWidget(
                        child: Wrap(
                          runSpacing: 8,
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomButton(
                              iconData: Icons.search,
                              text: 'View Receipt',
                              onTap: () {
                                onPressed!();
                                Launchers.launchWebUrl('https://fmp-t.fatora.me/receipt?paymentId=$paymentId');
                              },
                              width: 140.w,
                              buttonColor: AppColors.secondary,
                              enabled: true,
                              hasLoading: true,
                            ),
                            Width.v4,
                            Container(
                              width: 50,
                              height: 55,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.primary
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.share, color: AppColors.white, size: 20,),
                                onPressed: () async{
                                  await SocialShare.shareOptions('https://fmp-t.fatora.me/receipt?paymentId=$paymentId');
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Height.v16
                    ],
                  ),
                  Positioned(
                      top: 0.0,
                      right: 0.0,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: AppColors.black,),
                        onPressed: () {
                          Navigation.pop(context);
                          onPressed!();
                        },
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  static Future<void> privacyPolicy({
    required BuildContext context,
    required String html,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: HtmlViewer(
                html: html ?? '',),
            ),
          ),
        );
      },
    );
  }
}




class GenerateLinkButton extends StatefulWidget {
  const GenerateLinkButton({
    super.key,
    required this.onTap,
  });

  final Function onTap;

  @override
  State<GenerateLinkButton> createState() => _GenerateLinkButtonState();
}

class _GenerateLinkButtonState extends State<GenerateLinkButton> {
  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'generateLink'.tr(),
      iconData: Icons.link,
      hasLoading: true,
      onTap: () {
        setState(() {
          widget.onTap();
        });
      },
      enabled: true,
      buttonColor: AppColors.primary,
    );
  }
}
