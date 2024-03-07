import 'package:fatora/core/constants/app_assets.dart';
import 'package:fatora/core/constants/app_colors.dart';
import 'package:fatora/core/constants/app_strings.dart';
import 'package:fatora/core/constants/app_styles.dart';
import 'package:fatora/core/constants/app_values.dart';
import 'package:fatora/core/constants/helpers.dart';
import 'package:fatora/core/utils/navigation.dart';
import 'package:fatora/core/widgets/custom_button.dart';
import 'package:fatora/features/login/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/di.dart';
import '../../../../core/utils/shared_perefrences/shared_perefrences_helper.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  static final AppPreferences _appPreferences = instance<AppPreferences>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppStrings.onBoardingTitle1,
            style: AppStyles.headline.copyWith(color: AppColors.white),
          )),
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 30.0, right: 15.0, left: 15.0),
        child: CustomButton(
          isBold: true,
          buttonColor: AppColors.white,
          textColor: AppColors.black,
          onTap: () {
            _appPreferences.setOnBoardingScreenViewed();
            Navigation.pushReplacement(
              context,
              const LoginPage(),
            );
          },
          text: AppStrings.onBoardingButton,
          enabled: true,
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.bottomCenter, colors: [
          Color(0xff111B36),
          Color(0xff263F83),
        ])),
        child: Padding(
          padding: AppPadding.pagesPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Height.v64,
              // Cards Image
              const Expanded(
                flex: 2,
                  child: Image(
                    image: AssetImage(AppAssets.cards),
                  )),

              // Slogan
              Expanded(
                  child: Text(
                    AppStrings.slogan,
                    style: AppStyles.headline
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 32, color: AppColors.white),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
