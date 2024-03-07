import 'package:easy_localization/easy_localization.dart';
import 'package:fatora/core/widgets/padding_widget.dart';
import 'package:fatora/features/settings/presentation/pages/personal_profile_page.dart';
import 'package:fatora/features/settings/presentation/pages/security_methods_page.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/constants/helpers.dart';
import '../../../../core/utils/navigation.dart';
import '../../../../core/widgets/common_appbar.dart';
import '../../../../core/widgets/modals/modals.dart';
import '../widgets/language_selector.dart';
import '../widgets/settings_card.dart';
import 'about_us_page.dart';
import 'default_parameters_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBars.inner(
       AppStrings.settings,
      ),
      body: _buildBody(context),
    );
  }


  _buildBody(context) {
    return PaddingWidget(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            SettingsCard(
              title: AppStrings.personalProfile,
              onTap: () {
                Navigation.push(context, const PersonalProfilePage());
              },
              description: AppStrings.personalProfileBody,
            ),

            SettingsCard(
              title: AppStrings.security,
              onTap: ()  {
                Navigation.push(context, const SecurityMethodsPage());
              },
              description: AppStrings.securityBody,

            ),


            SettingsCard(
              title: AppStrings.language,
              onTap: ()  {
                showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25),
                      ),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return SmallModal(
                        confirm: () {
                          Navigator.of(context).maybePop();
                        },
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                          Text(AppStrings.language, style: AppStyles.headline.copyWith(
                            color: AppColors.secondary
                          ),),

                            Height.v12,
                             LanguageSelector(),
                            Height.v12,
                          ],
                        ),
                      );
                    }
                );
              },
              description: "LanguageBody".tr(),

            ),


            SettingsCard(
              title: AppStrings.defaultParams,
              onTap: () {
                Navigation.push(context, const DefaultParametersPage());
              },
              description: AppStrings.defaultParamsBody,

            ),

            SettingsCard(
              title: AppStrings.update,
              onTap: () {
                Navigation.push(context, const AboutUsPage());
              },
              description: AppStrings.updateBody,

            ),
          ],
        ),
      ),
    );
  }

}
