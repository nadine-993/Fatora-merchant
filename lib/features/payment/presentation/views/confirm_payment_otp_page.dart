import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'package:fatora/core/api/core_models/empty_model.dart';
import 'package:fatora/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:fatora/core/constants/app_colors.dart';
import 'package:fatora/core/constants/app_styles.dart';
import 'package:fatora/core/constants/helpers.dart';
import 'package:fatora/core/methods/methods.dart';
import 'package:fatora/core/utils/navigation.dart';
import 'package:fatora/core/widgets/common_appbar.dart';
import 'package:fatora/core/widgets/confirmation_popup.dart';
import 'package:fatora/core/widgets/custom_button.dart';
import 'package:fatora/core/widgets/titled_widget.dart';
import 'package:fatora/features/client/data/models/client_model.dart';
import 'package:fatora/features/payment/domain/repository/payment_repo.dart';
import 'package:fatora/features/payment/presentation/views/payment_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_notification/in_app_notification.dart';

import '../../../../core/boilerplate/create_model/cubits/create_model_cubit.dart';
import '../../../../core/boilerplate/create_model/widgets/create_model.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/toast.dart';
import '../../../../core/widgets/otp_widget.dart';
import '../../../../main.dart';
import '../../../client/data/models/user_information_response.dart';
import '../../../client/domain/repository/client_repo.dart';
import '../../data/models/pay_with_otp_request_model.dart';
import '../../data/models/pay_with_otp_response_model.dart';
import '../../data/models/resend_otp_response_model.dart';

class ConfirmPaymentOtpPage extends StatefulWidget {
  const ConfirmPaymentOtpPage({
    Key? key,
    required this.terminalId,
    required this.paymentId,
    required this.sessionId,
    required this.client,
    required this.amount,
  }) : super(key: key);

  final String terminalId;
  final String paymentId;
  final Client client;
  final String amount;
  final String sessionId;

  @override
  State<ConfirmPaymentOtpPage> createState() => _ConfirmPaymentOtpPageState();
}

class _ConfirmPaymentOtpPageState extends State<ConfirmPaymentOtpPage> {


  bool isCompleted = false;
  late CreateModelCubit otpCubit;
  late CreateModelCubit cancelCubit;
  late CreateModelCubit resendCubit;
  TextEditingController otpController = TextEditingController();

  final FocusNode focusNode = FocusNode();
  int _seconds = 600; // 10 minutes in seconds
  late Timer _timer;
  DateTime? _lastPressedAt;

  String otp = '';
  int numberOfTrails = 0;
  int numberOfTrailsLeft = 3;

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          if (_seconds < 1) {
            timer.cancel();
            // Perform action here when timer ends
          } else {
            _seconds = _seconds - 1;
          }
        });
      },
    );
  }

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CommonAppBars.otp('Payment Confirmation', widget.paymentId, context),
      body: WillPopScope(
        onWillPop: () async {
          if (_lastPressedAt == null ||
              DateTime.now().difference(_lastPressedAt!) >
                  const Duration(seconds: 2)) {
            _lastPressedAt = DateTime.now();
            Toasts.showToast(
              "Press back again to exit",
              ToastType.informative,
            );
            return false;
          }
          cancelCubit.createModel(widget.paymentId);
          Navigation.pop(context);
          Navigation.pop(context);
          return true;
        },
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TitledWidget(
                      title: Text(
                        'totalamount'.tr(),
                        style: AppStyles.title
                            .copyWith(color: AppColors.secondary),
                      ),
                      child: GetModel<UserInformationResponse>(
                        loading: const SizedBox.shrink(),
                        repositoryCallBack: (data) =>
                            ClientRepository.getUserInformation(),
                        modelBuilder: (UserInformationResponse model) {
                          return Text(
                            "${Methods.formatMoney(double.parse(widget.amount))} ${model.user?.currency ?? ''}",
                            style: AppStyles.title,
                          );
                        },
                      )),
                  Height.v24,
                  TitledWidget(
                      title: Text(
                        'merchant'.tr(),
                        style: AppStyles.title
                            .copyWith(color: AppColors.secondary),
                      ),
                      child: Text(
                        widget.client.name ?? '',
                        style: AppStyles.title,
                      )),
                ],
              ),
              Height.v28,
              Text(
                'enterOTP'.tr(),
                style: AppStyles.title.copyWith(
                    overflow: TextOverflow.visible, color: AppColors.secondary),
              ),
              Height.v4,
              OtpWidget(
                textEditingController: otpController,
                onCompleted: (value) {
                  setState(() {
                    otp = value;
                  });
                },
              ),
              if (!isCompleted)
                CreateModel<ResendOtpResponse>(
                  repositoryCallBack: (data) =>
                      PaymentRepository.resendOTP(data),
                  onSuccess: (model) {
                    Toasts.showToast(model.message ?? 'OTP Resent Successfully',
                        ToastType.success);
                  },
                  onCubitCreated: (cubit) {
                    resendCubit = cubit;
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        resendCubit.createModel(widget.paymentId);
                        otpController.clear();
                      },
                      child: Text(
                        AppStrings.resend,
                        style: AppStyles.title.copyWith(color: AppColors.black),
                      ),
                    ),
                  ),
                ),
              //Center(child: Text('Number of trials: $numberOfTrailsLeft', style: AppStyles.title,)),
              Height.v12,
              Center(
                child: Wrap(
                  runSpacing: 10,
                  children: [
                    CreateModel<PayWithOtpResponse>(
                      onFailure: () {
                        numberOfTrails++;
                        numberOfTrailsLeft--;
                        if (numberOfTrails == 3) {
                          Navigation.pop(context);
                          Navigation.pop(context);
                          Navigation.pop(context);
                        } else {
                          Navigation.pop(context);
                        }
                      },
                      onSuccess: (model) {
                        Dialogs.paymentSuccess(
                            context: context,
                            paymentId: widget.paymentId,
                            onPressed: () {
                              Navigation.pop(context);
                              Navigation.pop(context);
                              Navigation.popThenPush(
                                      context,
                                      PaymentDetailsPage(
                                          paymentId: widget.paymentId))
                                  ?.whenComplete(() => print("Sameer Zakzak"));
                            });
                      },
                      onCubitCreated: (cubit) {
                        otpCubit = cubit;
                      },
                      repositoryCallBack: (data) =>
                          PaymentRepository.payWithOtp(data),
                      child: CustomButton(
                        text: 'pay'.tr(),
                        buttonColor: AppColors.secondary,
                        onTap: () {
                          Dialogs.loading(context: context);

                          print(widget.client.id);

                          otpCubit
                              .createModel(PayWithOtpRequestModel(
                                  language: 'en',
                                  otp: otp,
                                  terminalId: widget.terminalId,
                                  paymentId: widget.paymentId,
                                  clientId: widget.client.id,
                                  session: widget.sessionId))
                             ;
                        },
                        width: 140.w,
                        enabled: true,
                      ),
                    ),
                    Width.v12,
                    if (!isCompleted)
                      CreateModel<EmptyModel>(
                          repositoryCallBack: (data) =>
                              PaymentRepository.cancelPayment(data),
                          onCubitCreated: (cubit) {
                            cancelCubit = cubit;
                          },
                          onSuccess: (model) {
                            Toasts.showToast(
                                'cancelSuccess'.tr(), ToastType.error);

                            Navigation.pop(context);
                            Navigation.pop(context);
                          },
                          child: CustomButton(
                              text: 'cancel'.tr(),
                              type: ButtonType.bordered,
                              onTap: () {
                                cancelCubit.createModel(widget.paymentId);
                              },
                              width: 140.w,
                              enabled: true,
                              textColor: AppColors.red,
                              buttonColor: AppColors.transparent)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
