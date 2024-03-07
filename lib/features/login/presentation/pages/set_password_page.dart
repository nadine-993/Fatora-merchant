import 'package:easy_localization/easy_localization.dart';
import 'package:el_tooltip/el_tooltip.dart';
import 'package:fatora/core/api/core_models/base_result_model.dart';
import 'package:fatora/core/api/errors/base_error.dart';
import 'package:fatora/core/utils/navigation.dart';
import 'package:fatora/core/widgets/common_appbar.dart';
import 'package:fatora/features/home/presentation/pages/home_page.dart';
import 'package:fatora/features/login/data/models/login_request_model.dart';
import 'package:fatora/features/login/data/models/set_password_request_model.dart';
import 'package:fatora/features/login/presentation/pages/password_page.dart';
import 'package:flutter/material.dart';
import 'package:password_strength_checker/password_strength_checker.dart';

import '../../../../core/boilerplate/create_model/cubits/create_model_cubit.dart';
import '../../../../core/boilerplate/create_model/widgets/create_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_input_style.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/constants/helpers.dart';
import '../../../../core/notification/domin/repository/notification_repository.dart';
import '../../../../core/notification/notification.dart';
import '../../../../core/utils/di.dart';
import '../../../../core/utils/shared_perefrences/shared_perefrences_helper.dart';
import '../../../../core/utils/toast.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/fatora_input.dart';
import '../../../../core/widgets/padding_widget.dart';
import '../../../../core/widgets/titled_widget.dart';
import '../../data/models/login_response_model.dart';
import '../../data/models/set_password_response_model.dart';
import '../../domain/repository/user_repo.dart';

class SetPasswordPage extends StatefulWidget {
  const SetPasswordPage({Key? key, required this.userId, required this.passwordResetCode}) : super(key: key);

  final int userId;
  final String passwordResetCode;

  @override
  State<SetPasswordPage> createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends State<SetPasswordPage> {
  final _passwordController = TextEditingController();
  final _passwordAgainController = TextEditingController();

  // Booleans
  bool isFilled = false;

  // Keys
  final _formKey = GlobalKey<FormState>();

  late CreateModelCubit setPasswordCubit;

  static final AppPreferences _appPreferences = instance<AppPreferences>();

  final passNotifier = ValueNotifier<PasswordStrength?>(null);

  bool isObscure = true;

  IconData _getObscureIcon() {
    return isObscure ? Icons.visibility : Icons.visibility_off;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: CommonAppBars.inner('settingpassword'.tr()),
      body: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: (event) {
          // Dismiss the keyboard when tapping outside
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: PaddingWidget(
          child: Form(
            key: _formKey,
            onChanged: () {
              setState(() {
                if (_passwordController.text.isNotEmpty && _passwordAgainController.text.isNotEmpty) {
                  isFilled = true;
                } else {
                  isFilled = false;
                }
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PasswordInput(
                  labelWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('newpassword'.tr(), style: AppStyles.title,),

                      const ElTooltip(
                        content: Text("Password must contain:\n- At least 8 characters\n- At least 1 small letter\n- At least 1 capital letter\n- At least 1 special character"),
                        child: Icon(AppIcons.informative, color: AppColors.darkerGray, size: 25,),
                      ),

                    ],
                  ),
                  validationType: ValidationType.password,
                  isLast: false,
                  label: 'newpassword'.tr(),
                  hint: 'newpasswordHint'.tr(),
                  textEditingController: _passwordController,
                  onChanged: (value) {
                    passNotifier.value =
                        PasswordStrength.calculate(text: value);
                  },
                ),

                Height.v12,

            TitledWidget(
              title: Text('confirmpassword'.tr(), style: AppStyles.title,),
              child: TextFormField(
                onEditingComplete: () {
                  if (_formKey.currentState!.validate()) {
                    setPasswordCubit?.createModel(SetPasswordRequestModel(
                        userId: widget.userId,
                        password: _passwordController.text,
                        resetCode: widget.passwordResetCode,
                        returnUrl: null
                    )
                    );
                  }
                },
                validator: (input) {
                  if(input!.isEmpty) {
                    return 'emptyfieldError'.tr();
                  }
                  else if(input! != _passwordController.text) {
                    return 'confirmpasswordError'.tr();
                  }
                  else {
                    return null;
                  }
                },
                controller: _passwordAgainController,
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

                Height.v8,
                PasswordStrengthChecker(
                  strength: passNotifier,
                ),
                Height.v24,

                CreateModel<SetPasswordResponseModel>(
                  onSuccess: (SetPasswordResponseModel model) async {
                    BaseResultModel? res = (await UserRepository.login(
                        LoginRequestModel(
                            userNameOrEmailAddress: model.userName,
                            password: _passwordController.text,
                            isMobile: true
                        )
                    ));
                    if(res is LoginResponseModel) {
                      _appPreferences.setAccessToken(res?.accessToken ?? '');
                      final fcmRes = await NotificationRepository.updateFCMToken(
                          Messaging.token);
                      print('TTE ${fcmRes.toString()}');
                      Navigation.pushReplacement(context, HomePage());
                    }
                    if(res is BaseError) {
                      Toasts.showToast(res.message, ToastType.error);
                    }

                  },
                  onCubitCreated: (CreateModelCubit cubit) {
                    setPasswordCubit = cubit;
                  },
                  repositoryCallBack: (data) => UserRepository.setPassword(data),
                  child: CustomButton(
                    enabled: true,
                    text:'setpassword'.tr(),
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                          setPasswordCubit?.createModel(SetPasswordRequestModel(
                              userId: widget.userId,
                              password: _passwordController.text,
                              resetCode: widget.passwordResetCode,
                              returnUrl: null
                          )
                          );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
