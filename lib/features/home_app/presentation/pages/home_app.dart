import 'package:fatora/core/constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/common_appbar.dart';
import '../../../../core/widgets/drawer_widget.dart';
import '../../../home/presentation/pages/home_page.dart';


class HomeApp extends StatefulWidget {
  const HomeApp({Key? key}) : super(key: key);

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {

  int _selectedIndex = 0;

  static  final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    HomePage(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: CommonAppBars.home(AppStrings.home),
      bottomNavigationBar: getBottomNav(),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }

  Widget getBottomNav() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 35),
      child: GNav(
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          rippleColor: AppColors.lightGray,
          hoverColor:  AppColors.lightGray,
          tabBackgroundColor: AppColors.midGray,
          activeColor:  AppColors.primary,
          gap: 8,
          iconSize: 20,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          duration: const Duration(milliseconds: 400),
          color: Colors.black,
          // navigation bar padding
          tabs:  [

          ]
      ),
    );
  }
}
