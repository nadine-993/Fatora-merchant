import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:fatora/core/api/core_models/base_result_model.dart';
import 'package:fatora/core/api/errors/base_error.dart';
import 'package:fatora/core/constants/app_strings.dart';
import 'package:fatora/core/constants/app_styles.dart';
import 'package:fatora/core/constants/helpers.dart';
import 'package:fatora/core/utils/navigation.dart';
import 'package:fatora/core/widgets/common_appbar.dart';
import 'package:fatora/core/widgets/confirmation_popup.dart';
import 'package:fatora/core/widgets/custom_keyboard.dart';
import 'package:fatora/core/widgets/fatora_input.dart';
import 'package:fatora/core/widgets/padding_widget.dart';
import 'package:fatora/features/client/data/models/client_model.dart';
import 'package:fatora/features/payment/presentation/views/payment_details_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../../core/api/core_models/base_response_model.dart';
import '../../../../core/api/errors/internal_server_error.dart';
import '../../../../core/boilerplate/get_model/widgets/get_model.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/methods/methods.dart';
import '../../../../core/utils/di.dart';
import '../../../../core/utils/shared_perefrences/shared_perefrences_helper.dart';
import '../../../../core/utils/toast.dart';
import '../../../client/data/models/user_information_response.dart';
import '../../../client/domain/repository/client_repo.dart';
import '../../../settings/data/models/get_default_params_response.dart';
import '../../../settings/domain/repository/settings_repo.dart';
import '../../../terminal/presentation/widgets/terminal_small_card.dart';
import '../../data/models/create_full_payment_request_model.dart';
import '../../data/models/create_full_payment_response_model.dart';
import '../../data/models/decrypt_qr_response.dart';
import '../../data/models/payment_creation_request.dart';
import '../../data/models/payment_creation_response.dart';
import '../../domain/repository/payment_repo.dart';
import '../widgets/callback_input_widget.dart';
import '../widgets/tigger_input_widget.dart';
import 'confirm_payment_otp_page.dart';

class AddPaymentPage extends StatefulWidget {
  const AddPaymentPage({
    Key? key,
    required this.terminal,
    required this.client,
    required this.fromHomePage,
  }) : super(key: key);

  final Client client;
  final String terminal;
  final bool fromHomePage;

  @override
  State<AddPaymentPage> createState() => _AddPaymentPageState();
}

class _AddPaymentPageState extends State<AddPaymentPage> {
  static final AppPreferences _appPreferences = instance<AppPreferences>();

  final _callbackController = TextEditingController();
  final _triggerController = TextEditingController();
  final _notesController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  QRViewController? qrController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  bool isExpanded = false;
  bool isLoading = false;

  String arLink = '';
  String enLink = '';

  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
  );

  String currency = '';
  double amountNum = 0;
  String amount = '';
  String formattedAmount = '';

  _getExpandedText() {
    if (isExpanded) {
      return AppStrings.seeLess;
    } else {
      return AppStrings.seeMore;
    }
  }

  bool isFlashOn = true;

  void _toggleFlash() {
    setState(() {
      isFlashOn = !isFlashOn;
    });
    qrController?.toggleFlash();
  }

  @override
  void initState() {
    setState(() {
      _callbackController.text = _appPreferences.getCallback();
      _triggerController.text = _appPreferences.getTrigger();
      _notesController.text = " ";
    });
    super.initState();
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      qrController!.pauseCamera();
    } else if (Platform.isIOS) {
      qrController!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 300.0;
    return isLoading
        ? Scaffold(
            extendBodyBehindAppBar: true,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200.h,
                    width: 200.w,
                    child: Lottie.asset(
                        height: 30.h,
                        width: 30.w,
                        AppAssets.qrScan,
                        repeat: true),
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            bottomNavigationBar: Container(
              height: 250.h,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
              child: CustomKeyboard(
                onClear: () {
                  setState(() {
                    amount = '';
                    formattedAmount = '';
                  });
                },
                onKeyPressed: (value) {
                  if (amount.length < 12) {
                    if (amount.length > 10 && value == '00') {
                      // Do nothing
                    } else if (amount.length > 9 && value == '000') {
                      // Do nothing
                    } else if (amount.isEmpty &&
                        (value == '0' || value == '00' || value == '000')) {
                      // Do nothing
                    } else {
                      setState(() {
                        amount += value;
                        formattedAmount = amount;
                        formattedAmount =
                            Methods.formatMoney(double.parse(amount));
                      });
                    }
                  }
                },
                onSuccess: () async {
                  _onKeyboardSubmit(scanArea, context);
                },
                onBackspace: () {
                  setState(() {
                    if(amount.length == 1) {
                      amount = '';
                      formattedAmount = amount;
                    }
                    else {
                      amount = amount.substring(0, amount.length - 1);
                      formattedAmount = amount;
                      formattedAmount = Methods.formatMoney(double.parse(amount));
                    }
                  });
                },
              ),
            ),
            appBar: CommonAppBars.inner(AppStrings.createPayment),
            body: _getPageContent(),
          );
  }

  Widget _getPageContent() {
    return GetModel<GetDefaultParamsResponse>(
        onSuccess: (model) {
          setState(() {
            _callbackController.text = model.callbackURL ?? '';
            _triggerController.text = model.triggerURL ?? '';
            _notesController.text = model.notes ?? '';
          });
        },
        repositoryCallBack: (data) => SettingsRepository.getDefaultParams(),
        modelBuilder: (model) {
          return PaddingWidget(
            child: Form(
              key: _formKey,
              child: ListView(children: [
                Height.v12,
                TerminalSmallCard(
                  client: widget.client,
                  terminalId: widget.terminal,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Amount Label
                    Text(
                      AppStrings.amount,
                      style: AppStyles.title,
                    ),

                    // See More Text Button
                    TextButton(
                        onPressed: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        child: Text(_getExpandedText()))
                  ],
                ),
                GestureDetector(
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: AmountInput(formattedAmount: formattedAmount)),


                isExpanded
                    ? Column(
                        children: [
                          Height.v12,
                          NotesInput(notesController: _notesController),
                          Height.v8,
                          CallbackInput(
                              callbackController: _callbackController),
                          Height.v8,
                          TriggerInput(triggerController: _triggerController),
                          Height.v8,


                        ],
                      )
                    : const SizedBox.shrink(),
              ]),
            ),
          );
        });
  }

  void _onKeyboardSubmit(double scanArea, BuildContext context) {
    if (amount.isNotEmpty) {
      Dialogs.createPaymentPopup(
          onFlash: _toggleFlash,
          qrWidget: QRView(
            overlay: QrScannerOverlayShape(
              cutOutBottomOffset: 0,
                borderColor: AppColors.secondary,
                borderRadius: 10,
                borderLength: 40,
                borderWidth: 10,
                cutOutSize: scanArea),
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          context: context,
          onGenerateLinkTap: () async {
            Navigation.pop(context);
            Dialogs.loading(context: context);
            // Create Payment
            BaseResultModel? res = (await PaymentRepository.createPayment(
                PaymentCreationRequest(
                    transaction: PaymentRequest(
                        amount: double.parse(amount),
                        terminalId: widget.terminal,
                        callbackURL: _callbackController.text,
                        triggerURL: _triggerController.text,
                        notes: _notesController.text,
                        clientId: widget.client.id,
                        lang: 'en'))));

            if (res is PaymentCreationResponse) {
              // If Success
              if (res?.code == 300) {
                // Create two links
                arLink = res?.response?.paymentLink ?? '';
                enLink = res?.response?.paymentLink ?? '';

                // And show success Toast
                Navigation.pop(context);
                Dialogs.success(
                    context: context,
                    message: 'addPaymentSuccess'.tr());

                // Then Push replacement

                Future.delayed(const Duration(milliseconds: 3000), () {
                  Navigation.pop(context);
                  Navigation.popThenPush(
                      context,
                      PaymentDetailsPage(
                        paymentId: res?.response?.paymentId ?? '',
                      ));
                });
              }

              // If Failure
              else {
                Toasts.showToast(AppStrings.failureMessage, ToastType.error);
              }
            } else if (res is BaseError) {
              Navigation.pop(context);
              Toasts.showToast(res.message, ToastType.error);
            } else if (res is ServerError) {
              Navigation.pop(context);
              Toasts.showToast(
                  res.message ?? AppStrings.failureMessage, ToastType.error);
            } else {
              print(res);
              Navigation.pop(context);
              Toasts.showToast(AppStrings.failureMessage, ToastType.error);
            }
          });
    }
    else if(amount.isEmpty){
      Toasts.showToast('emptyamounterror'.tr(), ToastType.informative);
    }
  }

  void _onQRViewCreated(QRViewController controller) async {
    setState(() {
      qrController = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      controller.stopCamera();
      Navigation.pop(context);

      Dialogs.loading(context: context);

      // Decrypt Qr
      final qrRes = (await PaymentRepository.decryptQR(scanData.code!));

      print("testin");

      if (qrRes is DecryptQrResponse) {
        // Then send payment info with card info
        final BaseResultModel? paymentRes =
            (await PaymentRepository.createFullPayment(
                CreateFullPaymentRequestModel(
                    amount: double.parse(amount == '' ? '0' : amount),
                    terminalId: widget.terminal,
                    callbackURL: _callbackController.text,
                    triggerURL: _triggerController.text,
                    clientId: widget.client.id,
                    notes: _notesController.text,
                    lang: 'en',
                    cardNumber: qrRes?.cardNumber,
                    expiryDate: qrRes?.expiryDate)));
        if (paymentRes is CreateFullPaymentResponse) {
          setState(() {
            isLoading = false;
          });
          if (paymentRes?.paymentId != null && paymentRes?.sessionId != null) {
            // Push OTP page
            Navigation.popThenPush(
                context,
                ConfirmPaymentOtpPage(
                  terminalId: widget.terminal,
                  amount: amount,
                  client: widget.client,
                  paymentId: paymentRes?.paymentId ?? '',
                  sessionId: paymentRes?.sessionId ?? ''

                ));
            setState(() {
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
            });
            Toasts.showToast(AppStrings.failureMessage, ToastType.error);
          }
        }
        else if (qrRes is BaseError) {
          Navigation.pop(context);
          Toasts.showToast(AppStrings.failureMessage, ToastType.error);
        }
        else if (paymentRes is ServerError) {
          Navigation.pop(context);
          Toasts.showToast(
              paymentRes.message ?? AppStrings.failureMessage, ToastType.error);
        }
        else if (paymentRes is BaseError) {
          Navigation.pop(context);
          Toasts.showToast(paymentRes.message, ToastType.error);
        }
        else if (paymentRes is InternalServerError) {
          Navigation.pop(context);
          Toasts.showToast(paymentRes.message, ToastType.error);
        } else {
          Navigation.pop(context);
          Toasts.showToast(AppStrings.failureMessage ?? '', ToastType.error);
        }

      }

      else if (qrRes is BaseError) {
        Navigation.pop(context);
        Toasts.showToast(AppStrings.failureMessage, ToastType.error);
      }
      else if (qrRes is ServerError) {
        Navigation.pop(context);
        Toasts.showToast(
            qrRes.message ?? AppStrings.failureMessage, ToastType.error);
      }
      else if (qrRes is BaseError) {
        Navigation.pop(context);
        Toasts.showToast(qrRes.message, ToastType.error);
      }
      else if (qrRes is InternalServerError) {
        Navigation.pop(context);
        Toasts.showToast(qrRes.message, ToastType.error);
      } else {
        Navigation.pop(context);
        Toasts.showToast(AppStrings.failureMessage ?? '', ToastType.error);
      }
    });
  }

  @override
  void dispose() {
    qrController?.dispose();
    super.dispose();
  }
}

class AmountInput extends StatelessWidget {
  const AmountInput({
    super.key,
    required this.formattedAmount,
  });

  final String formattedAmount;

  @override
  Widget build(BuildContext context) {
    return GetModel<UserInformationResponse>(
        repositoryCallBack: (data) =>
            ClientRepository.getUserInformation(),
        modelBuilder:
            (UserInformationResponse userInformationResponse) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20),
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.lightGray,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userInformationResponse.user?.currency ?? '',
                  style: AppStyles.headline,
                ),
                Width.v12,
                Text(
                  formattedAmount,
                  style: AppStyles.title,
                ),
              ],
            ),
          );
        });
  }
}

class AmountKeyboardInput extends StatefulWidget {
  const AmountKeyboardInput({
    super.key,
    required TextEditingController amountController,
    this.readOnly,
  }) : _amountController = amountController;

  final TextEditingController _amountController;
  final bool? readOnly;

  @override
  State<AmountKeyboardInput> createState() => _AmountKeyboardInputState();
}

class _AmountKeyboardInputState extends State<AmountKeyboardInput> {
  int maxLength = 12;

  @override
  Widget build(BuildContext context) {
    return GetModel<UserInformationResponse>(
        repositoryCallBack: (data) => ClientRepository.getUserInformation(),
        modelBuilder: (UserInformationResponse userInformationResponse) {
          return FatoraInput(
            maxLength: maxLength,
            readOnly: widget.readOnly ?? true,
            textEditingController: widget._amountController,
            prefixIcon: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Text(
                  userInformationResponse.user?.currency ?? '',
                  style: AppStyles.headline,
                )),
            validationType: ValidationType.empty,
            onChanged: (value) {
              Methods.formatMoney(double.tryParse(value) ?? 0);
            },
            hint: AppStrings.amountHint,
            inputType: TextInputType.number,
            isLast: true,
          );
        });
  }
}
