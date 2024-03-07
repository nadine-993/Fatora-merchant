import 'package:fatora/core/constants/app_colors.dart';
import 'package:fatora/core/constants/app_strings.dart';
import 'package:fatora/core/constants/app_styles.dart';
import 'package:fatora/core/constants/app_values.dart';
import 'package:fatora/core/constants/helpers.dart';
import 'package:fatora/core/methods/methods.dart';
import 'package:fatora/core/utils/navigation.dart';
import 'package:fatora/features/payment/presentation/payment_functions.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/toast.dart';
import '../../data/models/payment_model.dart';
import '../views/payment_details_page.dart';

enum PaymentStatus{
  P,
  A
}

class PaymentCard extends StatelessWidget {
  const PaymentCard({Key? key, required this.payment, required this.currency}) : super(key: key);

  final Payment payment;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap(context);
      },
      child: Container(
        padding: const EdgeInsets.all(AppPadding.p14),
        decoration: _getCardStyle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 8,
              child: Column(
                children: [
                  // Amount and status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Amount
                      Flexible(
                        child: Text('${Methods.formatMoney(payment.amount ?? 0)} $currency',
                            style: AppStyles.title.copyWith(
                              fontWeight: FontWeight.w600
                            )
                        ),
                      ),

                      // Status
                      PaymentFunctions.getStatusWidget(payment.status ?? ''),


                    ],
                  ),

                  Height.v8,

                  // Datetime and operation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Date and time
                      Flexible(
                        child: Text(
                            '${Methods.getDate(payment.creationTimestamp)}  ${Methods.getTime(payment.creationTimestamp)}',
                            style: AppStyles.body.copyWith(
                              overflow: TextOverflow.ellipsis,
                              color: AppColors.darkerGray
                            )
                        ),
                      ),

                      Container(
                        width: 110,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: AppColors.black)
                          ),
                          child: Text(payment.type ?? '',
                            style: AppStyles.body.copyWith(color: AppColors.black),))
                    ],
                  )
                ],
              ),
            ),

            // Arrow
             Expanded(
                flex: 1,
                child: Padding(
                  padding:  const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Icon(
                    Icons.navigate_next,
                    color: payment.type == AppStrings.refund ? AppColors.darkGray.withOpacity(0.5)  : Colors.black,
                  ),
                ))
          ],
        ),
      ),
    );
  }

  BoxDecoration _getCardStyle() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.lightGray
      );
  }

  void onTap(BuildContext context) {
    // If refund
    if(payment.type == 'Refund') {
      Toasts.showToast( AppStrings.refundError, ToastType.error);
    }

    // If
    else {
      Navigation.push(context, PaymentDetailsPage(paymentId: payment.id ?? ''));
    }
  }
}
