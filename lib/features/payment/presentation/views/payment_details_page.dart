import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fatora/core/api/core_models/base_result_model.dart';
import 'package:fatora/core/api/core_models/empty_model.dart';
import 'package:fatora/core/api/errors/base_error.dart';
import 'package:fatora/core/boilerplate/create_model/cubits/create_model_cubit.dart';
import 'package:fatora/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:fatora/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:fatora/core/constants/app_icons.dart';
import 'package:fatora/core/constants/app_strings.dart';
import 'package:fatora/core/constants/app_styles.dart';
import 'package:fatora/core/constants/helpers.dart';
import 'package:fatora/core/methods/methods.dart';
import 'package:fatora/core/utils/navigation.dart';
import 'package:fatora/core/widgets/common_appbar.dart';
import 'package:fatora/core/widgets/confirmation_popup.dart';
import 'package:fatora/core/widgets/custom_button.dart';
import 'package:fatora/core/widgets/loading_widget.dart';
import 'package:fatora/core/widgets/padding_widget.dart';
import 'package:fatora/features/payment/domain/repository/payment_repo.dart';
import 'package:fatora/features/payment/presentation/widgets/payment_row.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_notification/in_app_notification.dart';
// import 'package:pusher_beams/pusher_beams.dart';
import 'package:social_share/social_share.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_keys.dart';
import '../../../../core/constants/app_values.dart';
import '../../../../core/utils/launchers.dart';
import '../../../../core/utils/service_locator.dart';
import '../../../../core/utils/toast.dart';
import '../../../../main.dart';
import '../../../client/data/models/get_my_permissions_response.dart';
import '../../../client/data/models/user_information_response.dart';
import '../../../client/domain/repository/client_repo.dart';
import '../../data/models/payment_by_id_request.dart';
import '../../data/models/payment_model.dart';
import '../../data/models/reverse_payment_response_model.dart';
import '../payment_functions.dart';
import '../widgets/link_input_widget.dart';
import 'confirm_reverse_otp_page.dart';
import 'package:http/http.dart' as http;

class PaymentDetailsPage extends StatefulWidget {
  const PaymentDetailsPage({Key? key, required this.paymentId})
      : super(key: key);

  final String paymentId;

  @override
  State<PaymentDetailsPage> createState() => _PaymentDetailsPageState();
}

class _PaymentDetailsPageState extends State<PaymentDetailsPage> {
  List<PopupMenuButton> menuItems = [];
  late CreateModelCubit reverseCubit;
  String? loadedCurrency;

  @override
  Widget build(BuildContext context) {
    return GetModel<GetMyPermissionsResponse>(
        withRefresh: false,
        loading: Container(
          color: Colors.white,
        ),
        repositoryCallBack: (data) => ClientRepository.getMyPermissions(),
        modelBuilder: (GetMyPermissionsResponse permissions) {
          return GetModel<Payment>(
              withRefresh: true,
              loading: Container(
                color: Colors.white,
                child: const LoadingWidget(),
              ),
              repositoryCallBack: (data) => PaymentRepository.getPaymentById(
                  PaymentByIdRequest(id: widget.paymentId)),
              modelBuilder: (Payment payment) {
                if (payment.status == 'A') {}
                return Scaffold(
                  appBar: CommonAppBars.inner(AppStrings.paymentInfo,
                      action:
                          //(permissions.items?.reverse == true || permissions.items?.cancel == true)

                          payment.status == 'A' || payment.status == 'P'
                              ? payment.status == 'A' &&
                                      permissions.items?.reverse == true
                                  ? PopupMenuButton(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      child: const Icon(
                                        AppIcons.more,
                                      ),
                                      itemBuilder: (context) {
                                        return [
                                          PopupMenuItem(
                                            value: 1,
                                            padding: EdgeInsets.zero,
                                            height: 40,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.repeat_rounded,
                                                  color: AppColors.reversedBg,
                                                  size: 20,
                                                ),
                                                Width.v8,
                                                Text(
                                                  AppStrings.reverse,
                                                  style: AppStyles.title
                                                      .copyWith(
                                                          color: AppColors
                                                              .reversedBg),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ];
                                      },
                                      onSelected: (int selection) {
                                        switch (selection) {
                                          case (1):
                                            Dialogs.confirmationPopup(
                                              context: context,
                                              confirmation: AppStrings.reverse,
                                              confirmationButton: CreateModel<
                                                      ReversePaymentResponse>(
                                                  onCubitCreated: (cubit) {
                                                    reverseCubit = cubit;
                                                  },
                                                  repositoryCallBack: (json) =>
                                                      PaymentRepository
                                                          .reversePayment(json),
                                                  onSuccess: (res) {
                                                    if (res?.code == 100) {
                                                      Toasts.showToast(
                                                          AppStrings
                                                              .reverseSuccess,
                                                          ToastType.error);
                                                      Navigation.pop(context);
                                                      ServiceLocator
                                                          .refreshPayments();
                                                    } else if (res?.code ==
                                                        200) {
                                                      Navigation.pop(context);
                                                      Navigation.popThenPush(
                                                          context,
                                                          ConfirmReverseOtpPage(
                                                            currency:
                                                                loadedCurrency!,
                                                            amount: payment
                                                                .amount
                                                                .toString(),
                                                            client: payment
                                                                    .clientName ??
                                                                '',
                                                            paymentId:
                                                                payment.id ??
                                                                    '',
                                                          ));
                                                    } else {
                                                      Toasts.showToast(
                                                          AppStrings
                                                              .failureMessage,
                                                          ToastType.error);
                                                      Navigation.pop(context);

                                                    }
                                                  },
                                                  child: CustomButton(
                                                    height: AppSize.s45,
                                                    size: ButtonSize.small,
                                                    buttonColor:
                                                        AppColors.secondary,
                                                    enabled: true,
                                                    hasLoading: true,
                                                    onTap: () {
                                                      reverseCubit.createModel(
                                                          widget.paymentId);
                                                    },
                                                    text: 'yes'.tr(),
                                                  )),
                                              onTap: () {},
                                            );
                                            break;
                                          case (2):
                                            Dialogs.confirmationPopup(
                                              context: context,
                                              confirmation:
                                                  AppStrings.cancelPayment,
                                              onTap: () async {
                                                BaseResultModel? res =
                                                    await PaymentRepository
                                                        .cancelPayment(
                                                            widget.paymentId);
                                                if (res is EmptyModel) {
                                                  Toasts.showToast(
                                                      AppStrings.cancelSuccess,
                                                      ToastType.success);
                                                  Navigation.pop(context);
                                                  Navigation.pop(context);
                                                  ServiceLocator
                                                      .refreshPayments();
                                                } else {
                                                  Toasts.showToast(
                                                      AppStrings.failureMessage,
                                                      ToastType.error);

                                                  Navigation.pop(context);

                                                }
                                              },
                                            );
                                            break;
                                        }
                                      },
                                    )
                                  : payment.status == 'P' &&
                                          permissions.items?.cancel == true
                                      ? PopupMenuButton(
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                          ),
                                          child: const Icon(
                                            AppIcons.more,
                                          ),
                                          itemBuilder: (context) {
                                            return [
                                              PopupMenuItem(
                                                  padding: EdgeInsets.zero,
                                                  value: 2,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Icon(
                                                        Icons.cancel_outlined,
                                                        color:
                                                            AppColors.cancelled,
                                                        size: 20,
                                                      ),
                                                      Width.v8,
                                                      Text(
                                                        AppStrings
                                                            .cancelPayment,
                                                        style: AppStyles.title
                                                            .copyWith(
                                                                color: AppColors
                                                                    .cancelled),
                                                      ),
                                                    ],
                                                  )),
                                            ];
                                          },
                                          onSelected: (int selection) {
                                            switch (selection) {
                                              case (1):
                                                Dialogs.confirmationPopup(
                                                  context: context,
                                                  confirmation:
                                                      AppStrings.reverse,
                                                  confirmationButton: CreateModel<
                                                          ReversePaymentResponse>(
                                                      onCubitCreated: (cubit) {
                                                        reverseCubit = cubit;
                                                      },
                                                      repositoryCallBack:
                                                          (json) =>
                                                              PaymentRepository
                                                                  .reversePayment(
                                                                      json),
                                                      onSuccess: (res) {
                                                        print("sameer");
                                                        if (res?.code == 100) {
                                                          Toasts.showToast(
                                                              AppStrings
                                                                  .reverseSuccess,
                                                              ToastType.error);

                                                          Navigation.pop(
                                                              context);
                                                          ServiceLocator
                                                              .refreshPayments();
                                                        } else if (res?.code ==
                                                            200) {
                                                          Navigation.pop(
                                                              context);
                                                          Navigation.popThenPush(
                                                              context,
                                                              ConfirmReverseOtpPage(
                                                                currency:
                                                                    loadedCurrency!,
                                                                amount: payment
                                                                    .amount
                                                                    .toString(),
                                                                client: payment
                                                                        .clientName ??
                                                                    '',
                                                                paymentId:
                                                                    payment.id ??
                                                                        '',
                                                              ));
                                                        } else {
                                                          Toasts.showToast(
                                                              AppStrings
                                                                  .failureMessage,
                                                              ToastType.error);

                                                          Navigation.pop(
                                                              context);
                                                        }
                                                      },
                                                      child: CustomButton(
                                                        height: AppSize.s45,
                                                        size: ButtonSize.small,
                                                        buttonColor:
                                                            AppColors.secondary,
                                                        enabled: true,
                                                        hasLoading: true,
                                                        onTap: () {
                                                          reverseCubit
                                                              .createModel(widget
                                                                  .paymentId);
                                                        },
                                                        text: 'yes'.tr(),
                                                      )),
                                                  onTap: () {},
                                                );
                                                break;
                                              case (2):
                                                Dialogs.confirmationPopup(
                                                  context: context,
                                                  confirmation:
                                                      AppStrings.cancelPayment,
                                                  onTap: () async {
                                                    BaseResultModel? res =
                                                        await PaymentRepository
                                                            .cancelPayment(
                                                                widget
                                                                    .paymentId);
                                                    if (res is EmptyModel) {
                                                      Toasts.showToast(
                                                          AppStrings
                                                              .cancelSuccess,
                                                          ToastType.success);
                                                      Navigation.pop(context);
                                                      Navigation.pop(context);ServiceLocator
                                                          .refreshPayments();
                                                    } else {
                                                      Toasts.showToast(
                                                          AppStrings
                                                              .failureMessage,
                                                          ToastType.error);

                                                      Navigation.pop(context);

                                                    }
                                                  },
                                                );
                                                break;
                                            }
                                          },
                                        )
                                      : const SizedBox.shrink()
                              : const SizedBox.shrink()),
                  body: PaddingWidget(
                    child: ListView(
                      children: [
                        PaymentRow(
                            title: AppStrings.dateNTime,
                            value:
                                '${Methods.getDate(payment.creationTimestamp)} - ${Methods.getTime(payment.creationTimestamp)}' ??
                                    ''),
                        GetModel<UserInformationResponse>(
                            onSuccess: (model) {
                              setState(() {
                                loadedCurrency = model.user?.currency ?? '';
                              });
                            },
                            loading: const SizedBox.shrink(),
                            repositoryCallBack: (data) =>
                                ClientRepository.getUserInformation(),
                            modelBuilder: (UserInformationResponse
                                userInformationResponse) {
                              return PaymentRow(
                                  title: AppStrings.amount,
                                  value:
                                      "${Methods.formatMoney(payment.amount ?? 0)} ${userInformationResponse.user?.currency ?? ''}");
                            }),
                        PaymentRow(
                            title: AppStrings.card,
                            value: payment.cardNumber ?? ''),
                        PaymentRow(
                            title: AppStrings.terminal,
                            value: payment.terminalId ?? ''),
                        PaymentRow(
                            title: AppStrings.response,
                            value: payment.responseCode ?? ''),
                        PaymentRow(
                          title: AppStrings.responseDescription,
                          value: payment.responseDescription != null
                              ? Methods.capitalizeFirst(
                                  payment.responseDescription ?? '')
                              : '',
                        ),
                        PaymentRow(
                            title: AppStrings.operation,
                            value: payment.type ?? ''),
                        PaymentRow(
                            title: AppStrings.status,
                            widget: PaymentFunctions.getStatusWidget(
                                payment.status ?? '')),
                        PaymentRow(
                            title: AppStrings.transRRN,
                            value: payment.rrn ?? ''),
                        PaymentRow(
                            title: AppStrings.transNotes,
                            value: payment.notes ?? ''),
                        if (payment.status == 'A' || payment.status == 'R')
                          Center(
                            child: Wrap(
                              runSpacing: 8,
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomButton(
                                  iconData: Icons.search,
                                  text: 'viewreceipt',
                                  buttonColor: AppColors.secondary,
                                  onTap: () {
                                    Launchers.launchWebUrl(
                                        'https://fmp-t.fatora.me/receipt?paymentId=${widget.paymentId}');
                                  },
                                  width: 150.w,
                                  enabled: true,
                                ),
                                Width.v4,
                                CustomButton(
                                  iconData: Icons.share,
                                  type: ButtonType.bordered,
                                  text: 'sharereceipt',
                                  width: 150.w,
                                  onTap: () async {
                                    await SocialShare.shareOptions(
                                        'https://fmp-t.fatora.me/receipt?paymentId=${widget.paymentId}');
                                  },
                                  enabled: true,
                                  buttonColor: AppColors.transparent,
                                  textColor: AppColors.primary,
                                ),
                              ],
                            ),
                          ),
                        if (payment.status == 'F' || payment.status == 'P')
                          Column(
                            children: [
                              LinkWidget(
                                title: AppStrings.arabicUrl,
                                value: payment.arPaymentLink ?? '',
                              ),
                              Height.v12,
                              LinkWidget(
                                title: AppStrings.englishUrl,
                                value: payment.enPaymentLink ?? '',
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              });
        });
  }
}
