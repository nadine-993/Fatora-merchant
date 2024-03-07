import 'package:fatora/core/constants/app_assets.dart';
import 'package:fatora/core/constants/app_colors.dart';
import 'package:fatora/core/constants/app_strings.dart';
import 'package:fatora/core/constants/helpers.dart';
import 'package:fatora/core/utils/navigation.dart';
import 'package:fatora/core/widgets/padding_widget.dart';
import 'package:fatora/features/login/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/constants/app_styles.dart';
import '../../../../core/utils/di.dart';
import '../../../../core/utils/shared_perefrences/shared_perefrences_helper.dart';

class OnBoardingPages extends StatefulWidget {
  const OnBoardingPages({super.key});

  @override
  _OnBoardingPagesState createState() => _OnBoardingPagesState();
}

class _OnBoardingPagesState extends State<OnBoardingPages> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  final int _pageCount = 3;

  static final AppPreferences _appPreferences = instance<AppPreferences>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
        appBar: AppBar(
          actions: [
            TextButton(
              child: Text(AppStrings.skip, style: AppStyles.title,),
              onPressed: () {
                _appPreferences.setOnBoardingScreenViewed();
                Navigation.pushReplacement(
                    context, const LoginPage());
              },
            ),
          ]
        ),
        body: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                for(int i = 0; i < _pageCount; i++)
                  OnBoardingSlide(
                    image: AppAssets.cards,
                    title: _getTitle(i),
                    description: _getDescription(i),
                    index: i,
                  )
              ],
            ),
            Positioned(
              bottom: 40,
              right: 20,
              child: InkWell(
                onTap: () {
                  if (_currentPage == 2) {
                    _appPreferences.setOnBoardingScreenViewed();
                    Navigation.pushReplacement(
                        context, const LoginPage());
                  }
                  else {
                    _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                  }
                },
                child: Container(
                    height: 55.h,
                    width: 55.h,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary
                    ),
                    child: Icon(
                      _currentPage == 2 ? Icons.done_rounded :
                      Icons.navigate_next_rounded,
                      color: AppColors.white,)
                ),
              ),
            ),


            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: PaddingWidget(
                child: SmoothPageIndicator(
                    controller: _pageController,
                    count: 3,
                    effect: const ExpandingDotsEffect(
                        dotHeight: 10,
                        dotWidth: 10,
                        dotColor: AppColors.midGray,
                        activeDotColor: AppColors.primary
                    ), // your preferred effect
                    onDotClicked: (index) {
                      _currentPage = index;
                    }
                ),
              ),
            ),
          ],
        )
    );
  }
}

String _getTitle(int index) {
  switch (index) {
    case 0:
      return AppStrings.onBoardingTitle1;
    case 1:
      return AppStrings.onBoardingTitle2;
    case 2:
      return AppStrings.onBoardingTitle3;
    default:
      return '';
  }
}

String _getDescription(int index) {
  switch (index) {
    case 0:
      return AppStrings.onBoardingBody1;
    case 1:
      return AppStrings.onBoardingBody2;
    case 2:
      return AppStrings.onBoardingBody3;
    default:
      return '';
  }
}

String _getImage(int index) {
  switch (index) {
    case 0:
      return AppAssets.onBoardingOne;
    case 1:
      return AppAssets.onBoardingTwo;
    case 2:
      return AppAssets.onBoardingThree;

    default:
      return '';
  }
}



class OnBoardingSlide extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final int index;

  const OnBoardingSlide(
      {super.key, required this.image, required this.title, required this.description, required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            width: double.infinity,
            height: 300.0.h,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(120),
                  bottomRight: Radius.circular(120),
                ),
                color: AppColors.lightGray.withOpacity(0.5)
            ),
            child: Lottie.asset(
                _getImage(index),
                repeat: false
            )
        ),
        PaddingWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Height.v48,
              Text(title, textAlign: TextAlign.center,
                  style: AppStyles.headline),
              Height.v12,
              Text(description, textAlign: TextAlign.center,
                  style: AppStyles.title.copyWith(
                      overflow: TextOverflow.visible
                  )),
            ],
          ),
        ),
      ],
    );
  }
}