import 'package:easy_localization/easy_localization.dart';
import 'package:fatora/core/constants/app_assets.dart';
import 'package:fatora/core/constants/app_strings.dart';
import 'package:fatora/core/constants/app_styles.dart';
import 'package:fatora/core/constants/helpers.dart';
import 'package:fatora/core/utils/navigation.dart';
import 'package:fatora/core/widgets/confirmation_popup.dart';
import 'package:fatora/features/login/domain/repository/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../features/client/data/models/user_information_response.dart';
import '../../features/client/domain/repository/client_repo.dart';
import '../../features/settings/domain/repository/settings_repo.dart';
import '../../features/settings/presentation/pages/personal_profile_page.dart';
import '../../features/settings/presentation/pages/setting_page.dart';
import '../boilerplate/get_model/widgets/get_model.dart';
import '../constants/app_colors.dart';
import '../utils/di.dart';
import '../utils/shared_perefrences/shared_perefrences_helper.dart';

class DrawerWidget extends StatefulWidget {
  static const routeName = '/LightDrawerPage';

  DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  bool disableLogout = false;
  bool disablePrivacy = false;

  @override
  Widget build(BuildContext context) {
    return _buildDrawer(context);
  }

  _buildDrawer(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: 250.0.w,
      child: Drawer(
        elevation: 0,
        child: Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  AppColors.secondary,
                  AppColors.primary,
            ],
              end: Alignment.center
            ),

            color: AppColors.primary.withOpacity(0.8),
          ),
          child: SafeArea(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: <Widget>[
                SizedBox(
                  height: 50.h,
                ),
                InkWell(
                  onTap: () {
                    Navigation.push(context, const PersonalProfilePage());
                  },
                  child: Hero(
                    transitionOnUserGestures: true,
                    tag: 'profileImage',
                    child: Row(
                      children: [
                        // Avatar
                        const CircularProfilePic(),

                        Width.v8,

                        _getUserInfo()
                      ],
                    ),
                  ),
                ),
                Height.v24,
                drawerItem(
                  Icons.settings,
                  "settings".tr(),
                  onTap: () {
                    Navigation.push(context, SettingsPage());
                  },
                ),
                const Divider(color: AppColors.midGray),
                disablePrivacy ? Container(
                    padding: const EdgeInsets.all(15),
                    child: Text('Loading...', style: AppStyles.title.copyWith(color: AppColors.white),)) : drawerItem(
                  Icons.lock,
                  "privacypolicy".tr(),
                  onTap: () async{
                    setState(() {
                      disablePrivacy = true;
                    });
                    final String? html = await SettingsRepository.getPrivacyPolicy(_appPreferences.getLanguage() == 'ar' ? 'ar' : 'en');
                    Dialogs.privacyPolicy(context: context, html: html ?? '');
                    setState(() {
                      disablePrivacy = false;
                    });
                  },
                ),
                const Divider(color: AppColors.midGray),


                disableLogout ? Container(
                    padding: const EdgeInsets.all(15),
                    child: Text('Logging Out...', style: AppStyles.title.copyWith(color: AppColors.white),)) :
                drawerItem(
                  Icons.logout,
                  "logout".tr(),
                  onTap: () async {
                    setState(() {
                      disableLogout = true;
                    });
                    await UserRepository.logout(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  final AppPreferences _appPreferences = instance<AppPreferences>();

  Widget _getUserInfo() {
    return _appPreferences.getName() != '' ?
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 150.0.w,
          child: Text(
            _appPreferences.getName(),
            maxLines: 1,
            style: AppStyles.title.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.white),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Height.v4,
        SizedBox(
          width: 150.0.w,
          child: Text(
            _appPreferences.getUsername(),
            maxLines: 1,
            style:
            AppStyles.body.copyWith(color: AppColors.white, overflow: TextOverflow.ellipsis),
          ),
        ),
      ],
    ) :
      GetModel<UserInformationResponse>(
        error: Text(
          'errorloadinginfo'.tr(),
          style: AppStyles.title.copyWith(color: AppColors.white),
        ),
        onSuccess: (model) {
          _appPreferences.setName('${model.user!.firstname!} ${model.user!.surname!}');
          _appPreferences.setUsername(model.user!.userName!);
        },
        loading: Text(AppStrings.loading, style: AppStyles.title.copyWith(
                      color: AppColors.white
                    ),),
                    repositoryCallBack: (data) => ClientRepository.getUserInformation(),
                    modelBuilder: (UserInformationResponse userInformationResponse) {
                      return FittedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: 150.0.w,
                                child: Text(
                                  '${userInformationResponse.user?.firstname ?? ''} ${userInformationResponse.user?.surname ?? ''}',
                                  style: AppStyles.title.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.white),
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            Height.v4,
                            SizedBox(
                              width: 150.0.w,
                              child: Text(
                                userInformationResponse.user?.userName ?? '',
                                style:
                                AppStyles.body.copyWith(color: AppColors.white, overflow: TextOverflow.fade),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    );
  }

  /// Building item  for drawer .
  Widget drawerItem(IconData icon, String title,
      {String? badgeCount, GestureTapCallback? onTap}) {
    return InkWell(
      highlightColor: AppColors.black,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: AppStyles.title
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}

class CircularProfilePic extends StatelessWidget {
  const CircularProfilePic({
    super.key, this.size = 45,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.h,
      width: size.w,
      decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.white,
          image: DecorationImage(
              image: AssetImage(AppAssets.userAvatar))),
    );
  }
}

class OvalRightBorderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(size.width - 40, 0);
    path.quadraticBezierTo(
        size.width + 40, size.height / 2, size.width - 40, size.height);
    // path.quadraticBezierTo(
    //     size.width, size.height - (size.height / 4), size.width-40, size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class OvalLeftBorderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(40, 0);
    path.quadraticBezierTo(-40, size.height / 2, 40, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(40, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
