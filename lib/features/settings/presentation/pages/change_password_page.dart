import 'package:easy_localization/easy_localization.dart';
import 'package:el_tooltip/el_tooltip.dart';
import 'package:fatora/core/api/core_models/empty_model.dart';
import 'package:fatora/core/boilerplate/create_model/cubits/create_model_cubit.dart';
import 'package:fatora/core/constants/app_colors.dart';
import 'package:fatora/core/constants/app_styles.dart';
import 'package:fatora/core/constants/helpers.dart';
import 'package:fatora/core/utils/navigation.dart';
import 'package:fatora/core/utils/toast.dart';
import 'package:fatora/core/widgets/common_appbar.dart';
import 'package:fatora/core/widgets/fatora_input.dart';
import 'package:fatora/core/widgets/padding_widget.dart';
import 'package:fatora/features/settings/data/models/change_password_request_model.dart';
import 'package:fatora/features/settings/domain/repository/settings_repo.dart';
import 'package:flutter/material.dart';
import 'package:password_strength_checker/password_strength_checker.dart';

import '../../../../core/boilerplate/create_model/widgets/create_model.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_input_style.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/titled_widget.dart';
import '../../../login/presentation/pages/password_page.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isObscure = true;

  IconData _getObscureIcon() {
    return isObscure ? Icons.visibility : Icons.visibility_off;
  }

  final passNotifier = ValueNotifier<PasswordStrength?>(null);

  bool isFilled = false;

  late CreateModelCubit changePasswordCubit;

  final focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBars.inner('changepassword'.tr()),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(15),
          child: CreateModel<EmptyModel>(
              onSuccess: (model) {
                Toasts.showToast(
                    'Changed Password Successfully', ToastType.success);
                Navigation.pop(context);
              },
              onCubitCreated: (cubit) {
                changePasswordCubit = cubit;
              },
              repositoryCallBack: (json) =>
                  SettingsRepository.changePassword(json),
              child: CustomButton(
                iconData: AppIcons.password,
                text: 'changepassword'.tr(),
                onTap: () {
                  if (_formKey.currentState!.validate()) {

                      changePasswordCubit.createModel(ChangePasswordRequest(
                          currentPassword: _oldPasswordController.text,
                          newPassword: _confirmPasswordController.text));
                  }
                },
                enabled: true,
              )),
        ),
        body: PaddingWidget(
          child: Form(
            key: _formKey,
            onChanged: () {
              setState(() {

              });
            },
            child: ListView(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PasswordInput(
                  isLast: false,
                  label: 'currentpassword'.tr(),
                  hint: 'currentpasswordHint'.tr(),
                  textEditingController: _oldPasswordController,
                ),
                Height.v12,
                PasswordInput(
                  labelWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('newpassword'.tr(), style: AppStyles.title,),

                      const ElTooltip(
                        content: Text("Password must contain:\n- At least 8 characters\n- At least 1 small letter\n- At least 1 capital letter\n- At least 1 special character"),
                        child: Icon(AppIcons.informative, color: AppColors.darkerGray, size: 20,),
                      ),

                    ],
                  ),
                  validationType: ValidationType.password,
                  isLast: false,
                  label: 'newpassword'.tr(),
                  hint: 'newpasswordHint'.tr(),
                  textEditingController: _newPasswordController,
                  onChanged: (value) {
                    passNotifier.value =
                        PasswordStrength.calculate(text: value);
                  },
                ),
                Height.v12,
                TitledWidget(
                  title: Text('confirmpassword'.tr(), style: AppStyles.title,),
                  child: TextFormField(
                    focusNode: focus,
                    onEditingComplete: () {
                      // Remove focus from the text field
                      focus.unfocus();

                      // Hide the keyboard
                      FocusScope.of(context).requestFocus(FocusNode());
                      if (_formKey.currentState!.validate()) {
                        changePasswordCubit.createModel(ChangePasswordRequest(
                            currentPassword: _oldPasswordController.text,
                            newPassword: _confirmPasswordController.text));
                      }
                    },
                    validator: (input) {
                      if(input!.isEmpty) {
                        return 'emptyfieldError'.tr();
                      }
                      else if(input! != _newPasswordController.text) {
                        return 'confirmpasswordError'.tr();
                      }
                      else {
                        return null;
                      }
                    },
                    controller: _confirmPasswordController,
                    textInputAction:
                    TextInputAction.done,
                    obscureText: isObscure,
                    decoration: AppInputStyle.getInputDecoration(
                        hint: 'confirmpasswordHint'.tr(),
                        suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          },
                          icon: Icon(
                            _getObscureIcon(),
                            color: AppColors.darkGray,
                          ),
                        )),
                  ),
                ),
                Height.v12,
                Text(
                  'passwstrength'.tr(),
                  style: AppStyles.title,
                ),
                Height.v8,
                PasswordStrengthChecker(
                  strength: passNotifier,
                ),
              ],
            ),
          ),
        ));
  }
}
