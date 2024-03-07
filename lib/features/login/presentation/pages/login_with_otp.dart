import 'package:easy_localization/easy_localization.dart';
import 'package:fatora/core/boilerplate/create_model/cubits/create_model_cubit.dart';
import 'package:fatora/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:fatora/core/constants/app_colors.dart';
import 'package:fatora/core/constants/app_strings.dart';
import 'package:fatora/core/constants/app_styles.dart';
import 'package:fatora/core/constants/helpers.dart';
import 'package:fatora/core/utils/navigation.dart';
import 'package:fatora/core/widgets/common_appbar.dart';
import 'package:fatora/core/widgets/loading_widget.dart';
import 'package:fatora/core/widgets/padding_widget.dart';
import 'package:fatora/features/login/presentation/pages/set_password_page.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/toast.dart';
import '../../../../core/widgets/otp_widget.dart';
import '../../../payment/data/models/resend_otp_response_model.dart';
import '../../data/models/confirm_login_request_model.dart';
import '../../data/models/confirm_login_response_model.dart';
import '../../domain/repository/user_repo.dart';

class LoginWithOtp extends StatefulWidget {
  const LoginWithOtp({Key? key, required this.username})
      : super(key: key);

  final String username;


  @override
  State<LoginWithOtp> createState() => _LoginWithOtpState();
}

class _LoginWithOtpState extends State<LoginWithOtp> {
  late CreateModelCubit otpCubit;
  bool isCompleted = false;

  late CreateModelCubit resendCubit;
  TextEditingController otpController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBars.inner('accountconfirmation'.tr()),
      body: Center(
        child: PaddingWidget(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text(
                  !isCompleted ? 'enterCode'.tr() : '',
                  style: AppStyles.title,
                ),
                Height.v24,
                CreateModel<ConfirmOtpResponseModel>(
                  loading: const LoadingWidget(),
                  onFailure: () {
                    setState(() {
                      isCompleted = false;
                      otpController.clear();
                    });
                  },
                  onSuccess: (model) {
                    Navigation.popThenPush(context, SetPasswordPage(userId: model.userId!, passwordResetCode: model.passwordResetCode!,));
                  },
                  onCubitCreated: (cubit) {
                    otpCubit = cubit;
                  },
                  repositoryCallBack: (data) => UserRepository.confirmLoginOtp(data),
                  child: OtpWidget(
                    textEditingController: otpController,
                      onCompleted: (value) async {
                        setState(() {
                          isCompleted = true;
                        });
                    otpCubit.createModel(ConfirmLoginRequestModel(
                        usernameOrEmail: widget.username,
                        otp: value
                    ));
                  }),
                ),

                if(!isCompleted)
                CreateModel<ResendOtpResponse>
                  (
                    repositoryCallBack: (data) => UserRepository.resendOTP(data),
                    onSuccess: (model) {
                      Toasts.showToast(model.message ?? 'OTP Resent Successfully', ToastType.success);
                    },
                    onCubitCreated: (cubit) {
                      resendCubit = cubit;
                    },
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () {
                              resendCubit.createModel(widget.username);
                              otpController.clear();
                            },
                            child: Text(
                              AppStrings.resend,
                              style: AppStyles.title
                                  .copyWith(color: AppColors.black),
                            ))),
                    ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}


