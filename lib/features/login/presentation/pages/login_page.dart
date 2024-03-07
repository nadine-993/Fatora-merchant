import 'package:easy_localization/easy_localization.dart';
import 'package:fatora/core/constants/app_assets.dart';
import 'package:fatora/core/widgets/custom_button.dart';
import 'package:fatora/core/widgets/padding_widget.dart';
import 'package:fatora/features/login/presentation/pages/password_page.dart';
import 'package:flutter/material.dart';

import '../../../../core/boilerplate/create_model/cubits/create_model_cubit.dart';
import '../../../../core/boilerplate/create_model/widgets/create_model.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/constants/helpers.dart';
import '../../../../core/utils/navigation.dart';
import '../../../../core/widgets/fatora_input.dart';
import '../../data/models/verify_username_response_model.dart';
import '../../domain/repository/user_repo.dart';
import 'login_with_otp.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  late CreateModelCubit _loginCubit;


  // Booleans
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.loginTitle,
                  style: AppStyles.headline,
                ),
                Height.v16,
                Text(
                  AppStrings.username,
                  style: AppStyles.title,
                  maxLines: 2,
                ),

                // Username Input
                FatoraInput(
                  onEditingComplete: () {
                    if (_formKey.currentState!.validate()) {
                      _loginCubit.createModel(_emailController.text);
                    }
                  },
                  prefixIcon: const Icon(Icons.person, color: AppColors.primary),
                  hint: AppStrings.usernameHint,
                  textEditingController: _emailController,
                  validationType: ValidationType.empty,
                  inputType: TextInputType.emailAddress,
                ),

                Height.v12,

                CreateModel<VerifyUsernameResponseModel>(
                  onlyFailure: true,
                  onFailure: () {
                    Navigation.push(context, PasswordPage(username: _emailController.text,));
                  },
                  onSuccess: (model) {
                    if(model.firstLogin ?? true) {
                      Navigation.push(context, LoginWithOtp(username: _emailController.text,));
                    }
                    else {
                      Navigation.push(context, PasswordPage(username: _emailController.text,));
                    }
                  },
                  onCubitCreated: (cubit) {
                    _loginCubit = cubit;
                  },
                  repositoryCallBack: (data) => UserRepository.verifyUsername(data),
                  child: CustomButton(
                    enabled: true,
                    text: 'continue'.tr(),
                    onTap: () async{
                      if (_formKey.currentState!.validate()) {
                        _loginCubit.createModel(_emailController.text);
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
