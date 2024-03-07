import 'package:fatora/core/api/core_models/empty_model.dart';
import 'package:fatora/core/boilerplate/create_model/cubits/create_model_cubit.dart';
import 'package:fatora/core/constants/app_styles.dart';
import 'package:fatora/core/utils/navigation.dart';
import 'package:fatora/core/utils/toast.dart';
import 'package:fatora/features/payment/domain/repository/payment_repo.dart';
import 'package:flutter/material.dart';

import '../boilerplate/create_model/widgets/create_model.dart';
import '../utils/di.dart';
import '../utils/shared_perefrences/shared_perefrences_helper.dart';

class CommonAppBars {
  static AppBar home(String title) {
    return AppBar(
      title: Text(title, style: AppStyles.headline,),
      centerTitle: true,
    );
  }

  static AppBar inner(String title, {Widget action = const SizedBox.shrink()}) {
    return AppBar(
      title: Text(title, style: AppStyles.headline,),
      centerTitle: true,
      actions: [Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: action,
      )],
    );
  }

  static late CreateModelCubit otpCubit;
  static AppBar otp(String title, String paymentId, BuildContext context) {
    return AppBar(
      title: Text(title, style: AppStyles.headline,),
      centerTitle: true,
      leading: CreateModel<EmptyModel>(
        repositoryCallBack: (data) => PaymentRepository.cancelPayment(data),
        onCubitCreated: (cubit) {
          otpCubit = cubit;
        },
        onFailure: () {
          Navigation.pop(context);
        },
        onSuccess: (model) {
          Toasts.showToast('Cancelled', ToastType.error);
          Navigation.pop(context);
          Navigation.pop(context);
        },
        child: IconButton(
            icon: const Icon(Icons.arrow_back_outlined),
            onPressed: () {
              otpCubit.createModel(paymentId);
            }),
      ),
    );
  }

  static final AppPreferences _appPreferences = instance<AppPreferences>();

  static AppBar terminal(String title) {
    return AppBar(
      title: Text(title, style: AppStyles.headline,),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () async{
          await _appPreferences.clearFilters();
          await _appPreferences.clearFirstFilter();
        },
      ),
    );
  }
}


