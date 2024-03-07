import 'package:easy_localization/easy_localization.dart';
import 'package:fatora/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:fatora/core/constants/app_colors.dart';
import 'package:fatora/core/constants/app_strings.dart';
import 'package:fatora/core/constants/helpers.dart';
import 'package:fatora/core/widgets/common_appbar.dart';
import 'package:fatora/core/widgets/custom_button.dart';
import 'package:fatora/core/widgets/padding_widget.dart';
import 'package:fatora/features/payment/presentation/widgets/payment_row.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/utils/navigation.dart';
import '../../../../core/widgets/drawer_widget.dart';
import '../../../client/data/models/user_information_response.dart';
import '../../../client/domain/repository/client_repo.dart';
import 'change_password_page.dart';

class PersonalProfilePage extends StatelessWidget {
  const PersonalProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBars.inner(AppStrings.personalProfile),
        body: PaddingWidget(
          child: Center(
            child: GetModel<UserInformationResponse>(
                repositoryCallBack: (data) =>
                    ClientRepository.getUserInformation(),
                modelBuilder:
                    (UserInformationResponse res) {
                  return ListView(
                    children: [
                      Height.v16,
                      const CircularProfilePic(size: 80),
                      Height.v16,
                      Center(
                        child: Text(res.user?.userName ?? '', style: AppStyles.headline.copyWith(
                          fontWeight: FontWeight.normal,
                        ),),
                      ),
                      Height.v32,
                      PaymentRow(
                        title: 'name'.tr(),
                        value: "${res.user?.firstname ?? ''} ${res.user?.surname ?? ''}",
                        color: AppColors.primary,
                      ),

                      PaymentRow(
                        title: 'mobilenumber'.tr(),
                        value: res.user?.mobileNumber ?? '',
                        color: AppColors.primary,
                      ),
                      PaymentRow(
                        title: 'email'.tr(),
                        value: res.user?.emailAddress ?? 'No Email Address',
                        color: AppColors.primary,
                      ),

                      Height.v8,

                      CustomButton(text: 'changepassword'.tr(),
                          iconData: AppIcons.password,
                          enabled: true,
                          onTap: () {
                            Navigation.push(context, const ChangePasswordPage());

                          }),
                    ],
                  );
                }),
          ),
        ));
  }
}
