import 'package:fatora/core/constants/app_icons.dart';
import 'package:fatora/core/constants/app_strings.dart';
import 'package:fatora/core/methods/methods.dart';
import 'package:fatora/core/widgets/custom_button.dart';
import 'package:fatora/core/widgets/fatora_input.dart';
import 'package:fatora/features/client/data/models/client_model.dart';
import 'package:fatora/features/terminal/presentation/views/terminal_page.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/helpers.dart';
import '../../../../core/utils/navigation.dart';
import '../../../../core/widgets/common_appbar.dart';
import '../../../../core/widgets/padding_widget.dart';
import '../../../terminal/presentation/widgets/terminal_small_card.dart';
import '../widgets/link_input_widget.dart';

class PaymentLinksPage extends StatelessWidget {
  const PaymentLinksPage({Key? key, required this.amount, required this.terminal, required this.client, required this.arLink, required this.enLink, required this.fromHomePage}) : super(key: key);

  final String terminal;
  final Client client;
  final String amount;
  final String arLink;
  final String enLink;
  final bool fromHomePage;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: CustomButton(
          onTap: () {
            if(!fromHomePage) {
              Navigation.pop(context);
            }
            Navigation.popThenPush(context, TerminalPage(
                client: client,
                terminalId: terminal,
            ));
          },
          text: AppStrings.close,
          enabled: true,
        ),
      ),
      appBar: CommonAppBars.inner(AppStrings.paymentLinks),
      body: PaddingWidget(
        child: Column(
          children: [
            TerminalSmallCard(client: client, terminalId: terminal,),

            Height.v12,

            FatoraInput(
              label: AppStrings.amount,
                readOnly: true,
                textEditingController: TextEditingController.fromValue(TextEditingValue(text: '${Methods.formatMoney(double.parse(amount))} SP')),
                prefixIcon: const Icon(AppIcons.amount, color: AppColors.primary) ,
                validationType: ValidationType.none
            ),

            Height.v24,

            LinkWidget(
              title: AppStrings.englishUrl,
              value: enLink ?? '',
            ),

            LinkWidget(
              title: AppStrings.arabicUrl,
              value: enLink.replaceFirst('en', 'ar') ?? '',
            ),
          ],
        )
      ),
    );
  }
}
