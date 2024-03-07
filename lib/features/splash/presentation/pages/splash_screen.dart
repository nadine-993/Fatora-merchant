import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:fatora/core/constants/helpers.dart';
import 'package:fatora/features/home/presentation/pages/home_page.dart';
import 'package:fatora/features/login/domain/repository/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local_auth/local_auth.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/pages/authentication_page.dart';
import '../../../../core/utils/di.dart';
import '../../../../core/utils/shared_perefrences/shared_perefrences_helper.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SplashScreen();
  }
}

class _SplashScreen extends State<SplashScreen> {
  // duration of splash screen on second
  int splashTime = 3;


  final AppPreferences _appPreferences = instance<AppPreferences>();
  final LocalAuthentication auth = LocalAuthentication();
  final String _authorized = 'notauthorized'.tr();


  @override
  void initState() {
    if(_authorized != 'Authorized') {
      if(!_appPreferences.getSavePassword()) {
        UserRepository.logout(context);
      }
      else if(_appPreferences.getFingerprint()) {
        Future.delayed(const Duration(seconds: 0), () async{
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return const AuthenticationPage();
              }));
        });
      }
      else {
        Future.delayed(const Duration(seconds: 0), () async{
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return HomePage();
              }));
        });
      }
    }
/*      Future.delayed(Duration(seconds: splashTime), () async {
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return HomePage();
            }));
      });*/
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:  [
            const MerchantLogo(),
            Height.v12,
            Text(Constants.APP_NAME, style: AppStyles.headline.copyWith(
              color: AppColors.primary
            ),)
          ],
        ),
      )
    );
  }
}

class MerchantLogo extends StatelessWidget {
  const MerchantLogo({
    super.key, this.height, this.width,
  });

  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: height ?? 120.w,
        height: width ?? 100.h,
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Image(image: const AssetImage(AppAssets.merchantLogo), height: 150.h));
  }
}
