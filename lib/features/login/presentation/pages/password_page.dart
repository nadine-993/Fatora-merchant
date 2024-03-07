import 'package:fatora/core/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/boilerplate/create_model/cubits/create_model_cubit.dart';
import '../../../../core/boilerplate/create_model/widgets/create_model.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/constants/helpers.dart';
import '../../../../core/notification/domin/repository/notification_repository.dart';
import '../../../../core/notification/notification.dart';
import '../../../../core/utils/di.dart';
import '../../../../core/utils/navigation.dart';
import '../../../../core/utils/shared_perefrences/shared_perefrences_helper.dart';
import '../../../../core/utils/toast.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/fatora_input.dart';
import '../../../../core/widgets/padding_widget.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../data/models/login_request_model.dart';
import '../../data/models/login_response_model.dart';
import '../../domain/repository/user_repo.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({Key? key, required this.username}) : super(key: key);

  final String username;

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final _passwordController = TextEditingController();


  // Keys
  final _formKey = GlobalKey<FormState>();

  // Cubits
  CreateModelCubit? loginCubit;

  static final AppPreferences _appPreferences = instance<AppPreferences>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          toolbarHeight: 100,
          title: const Image(height: 120, image: AssetImage(AppAssets.logo))),
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
            onChanged: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.loginTitle,
                  style: AppStyles.headline,
                ),

                Height.v16,

                // Password Input
                PasswordInput(
                  onEditingComplete: () {
                    _onSubmit(context);
                  },
                  prefixIcon: AppIcons.password,
                  textEditingController: _passwordController,
                  onFieldSubmitted: (value) {
                    _onSubmit(context);
                  },
                ),

                Height.v12,

                CreateModel<LoginResponseModel>(
                  onSuccess: (LoginResponseModel model) async {
                    _appPreferences.setAccessToken(model.accessToken!);
                    final fcmRes = await NotificationRepository.updateFCMToken(
                        Messaging.token);
                    Navigation.pushReplacement(context, HomePage());
                  },
                  onCubitCreated: (CreateModelCubit cubit) {
                    loginCubit = cubit;
                  },
                  repositoryCallBack: (data) => UserRepository.login(data),
                  child: CustomButton(
                    iconData: AppIcons.login,
                    enabled: true,
                    text: AppStrings.login,
                    onTap: () {
                      _onSubmit(context);
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

  void _onSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      loginCubit?.createModel(LoginRequestModel(
          userNameOrEmailAddress: widget.username,
          password: _passwordController.text,
          isMobile: true));
    } else {
      Toasts.showToast(
          AppStrings.wentWrong, ToastType.error);
    }
  }
}

class PasswordInput extends StatefulWidget {
    const PasswordInput(
      {Key? key,
      required this.textEditingController,
      this.hint,
      this.onFieldSubmitted, this.label, this.onChanged, this.isLast, this.validationType, this.labelWidget, this.prefixIcon, this.onEditingComplete})
      : super(key: key);

  final TextEditingController textEditingController;
  final Function(String)? onFieldSubmitted;
  final void Function()? onEditingComplete;
  final Function(String)? onChanged;
  final String? hint;
  final String? label;
  final Widget? labelWidget;
  final bool? isLast;
  final IconData? prefixIcon;
  final ValidationType? validationType;

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool isObscure = true;

  IconData _getObscureIcon() {
    return isObscure ? Icons.visibility : Icons.visibility_off;
  }

  @override
  Widget build(BuildContext context) {
    return FatoraInput(
      onEditingComplete: widget.onEditingComplete,
      labelWidget: widget.labelWidget,
      label: widget.label ?? AppStrings.password,
      onFieldSubmitted: widget.onFieldSubmitted,
      prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon, color: AppColors.primary,) : null,
      isLast: widget.isLast ?? true,
      onChanged: widget.onChanged ?? (value) {},
      suffixIcon: IconButton(
        onPressed: () {
          setState(() {
            isObscure = !isObscure;
          });
        },
        icon: Icon(
          _getObscureIcon(),
          color: AppColors.darkGray,
        ),
      ),
      validationType: widget.validationType ?? ValidationType.empty,
      hint: widget.hint ?? AppStrings.passwordHint,
      textEditingController: widget.textEditingController,
      inputType: TextInputType.text,
      obscureText: isObscure,
    );
  }
}
