import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:fatora/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:fatora/core/constants/app_styles.dart';
import 'package:fatora/core/constants/helpers.dart';
import 'package:fatora/core/widgets/common_appbar.dart';
import 'package:fatora/core/widgets/padding_widget.dart';
import 'package:fatora/features/client/data/models/client_model.dart';
import 'package:fatora/features/payment/domain/repository/payment_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fatora/core/methods/methods.dart' as m;
import 'package:in_app_notification/in_app_notification.dart';

import '../../../../core/boilerplate/create_model/cubits/create_model_cubit.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/navigation.dart';
import '../../../../core/utils/service_locator.dart';
import '../../../../core/utils/toast.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/otp_widget.dart';
import '../../../../core/widgets/titled_widget.dart';
import '../../../../main.dart';
import '../../data/models/confirm_reverse_request_model.dart';
import '../../data/models/reverse_payment_response_model.dart';
import 'package:http/http.dart' as http;

class ConfirmReverseOtpPage extends StatefulWidget {
  const ConfirmReverseOtpPage(
      {Key? key,
      required this.paymentId,
      required this.client,
      required this.amount,
      required this.currency})
      : super(key: key);

  final String paymentId;
  final String client;
  final String amount;
  final String currency;

  @override
  State<ConfirmReverseOtpPage> createState() => _ConfirmReverseOtpPageState();
}

class _ConfirmReverseOtpPageState extends State<ConfirmReverseOtpPage> {
  late CreateModelCubit otpCubit;

  bool isCompleted = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonAppBars.inner('reverseConfirmation'.tr()),
      body: PaddingWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitledWidget(
                title: Text(
                  'totalamount'.tr(),
                  style: AppStyles.title.copyWith(color: AppColors.secondary),
                ),
                child: Text(
                  "${m.Methods.formatMoney(double.parse(widget.amount))} ${widget.currency}",
                  style: AppStyles.title,
                )),
            Height.v24,
            TitledWidget(
                title: Text(
                  'merchant'.tr(),
                  style: AppStyles.title.copyWith(color: AppColors.secondary),
                ),
                child: Text(
                  widget.client ?? '',
                  style: AppStyles.title,
                )),
            Height.v28,
            Text(
              'enterOTP'.tr(),
              style: AppStyles.title.copyWith(
                  overflow: TextOverflow.visible, color: AppColors.secondary),
            ),
            Height.v4,
            CreateModel<ReversePaymentResponse>(
              loading: const LoadingWidget(),
              onSuccess: (model) {
                if (model.code == 0) {
                  Toasts.showToast(model.response ?? '', ToastType.success);

                  Navigation.pop(context);
                  ServiceLocator.refreshPayments();
                } else if (model.code == 100) {
                  Toasts.showToast('Wrong OTP' ?? '', ToastType.success);

                  Navigation.pop(context);

                } else if (model.code == 200) {
                  Toasts.showToast('Wrong OTP' ?? '', ToastType.success);

                  Navigation.pop(context);

                } else {
                  Toasts.showToast(model.response ?? '', ToastType.success);

                  setState(() {
                    isCompleted = false;
                  });
                }
              },
              onCubitCreated: (cubit) {
                otpCubit = cubit;
              },
              repositoryCallBack: (data) =>
                  PaymentRepository.confirmReversePayment(data),
              child: OtpWidget(
                onCompleted: (value) async {
                  setState(() {
                    isCompleted = true;
                  });
                  otpCubit
                      .createModel(ConfirmReverseRequestModel(
                          paymentId: widget.paymentId, otp: value))
                      .whenComplete(() {

                  });
                },
              ),
            ),
            Height.v24,
          ],
        ),
      ),
    );
  }
}
