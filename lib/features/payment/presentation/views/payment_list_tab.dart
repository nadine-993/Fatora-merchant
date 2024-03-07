import 'package:fatora/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:fatora/core/constants/app_strings.dart';
import 'package:fatora/core/constants/app_styles.dart';
import 'package:fatora/core/utils/extentions.dart';
import 'package:fatora/core/utils/navigation.dart';
import 'package:fatora/features/payment/presentation/views/filter_payments_page.dart';
import 'package:flutter/material.dart';

import '../../../../core/boilerplate/pagination/cubits/pagination_cubit.dart';
import '../../../../core/boilerplate/pagination/widgets/pagination_list.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/constants/helpers.dart';
import '../../../../core/utils/di.dart';
import '../../../../core/utils/service_locator.dart';
import '../../../../core/utils/shared_perefrences/shared_perefrences_helper.dart';
import '../../../client/data/models/client_model.dart';
import '../../../client/data/models/user_information_response.dart';
import '../../../client/domain/repository/client_repo.dart';
import '../../../settings/data/models/get_default_params_response.dart';
import '../../../settings/domain/repository/settings_repo.dart';
import '../../data/models/filter_params.dart';
import '../../data/models/payment_model.dart';
import '../../data/models/payments_request_model.dart';
import '../../domain/repository/payment_repo.dart';
import '../payment_functions.dart';
import '../widgets/payment_card.dart';

class PaymentListTab extends StatefulWidget {
  const PaymentListTab({Key? key, this.terminalId,required this.client, required this.defaultStatuses}) : super(key: key);

  final Client client;
  final String? terminalId;
  final List<String> defaultStatuses;

  @override
  State<PaymentListTab> createState() => _PaymentListTabState();
}

class _PaymentListTabState extends State<PaymentListTab> {
  PaginationCubit? listCubit;
  
  static final AppPreferences _appPreferences = instance<AppPreferences>();

  late FilterParams _filterParams;
  
  @override
  void initState() {
    _filterParams = _appPreferences.getFilters();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(alignment: Alignment.centerRight, child:
        TextButton(
            onPressed: () {
              Navigation.push(context,  FilterPaymentsPage(
                  client:  widget.client,
                  terminalId: widget.terminalId,
              ));
            },
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.filter_list_rounded, size: 20,),
                Width.v4,
                Text(AppStrings.filter, style: AppStyles.title.copyWith(fontWeight: FontWeight.w600),),
              ],
            ))),
        Expanded(
          child: GetModel<GetDefaultParamsResponse>(
        repositoryCallBack: (json) => SettingsRepository.getDefaultParams(),
        modelBuilder: (GetDefaultParamsResponse getDefaultParamsResponse) {
          return GetModel<UserInformationResponse>(
            repositoryCallBack: (data) => ClientRepository.getUserInformation(),
            modelBuilder: (UserInformationResponse userInformationResponse) {
              return PaginationList<Payment>(
                onCubitCreated: (cubit) {
                  ServiceLocator.setPayments(cubit!);
                },
                repositoryCallBack: (data) =>
                    PaymentRepository.getPayments(
                      data,
                      PaymentsRequestModel(
                        terminalId: widget.terminalId,
                        clientName: '',
                        type: '',
                        id: '',
                        amount: _filterParams.amount ?? '',
                        cardNumber: '',
                        fromCreationTimestamp: _filterParams.startDate ?? Constants.defaultStartDate.toString(),
                        fromResponseTimestamp: null,
                        responseCode: '',
                        responseDescription: '',
                        rrn: '',
                        sequance: '',
                        sorting: '',
                        status:
                        _filterParams.statuses != null ?
                        _filterParams.statuses!.isNotEmpty ? PaymentFunctions.getStatusLetter(_filterParams.statuses ?? widget.defaultStatuses)  : getDefaultParamsResponse.status!.isEmpty ? ['A', 'R'] : getDefaultParamsResponse.status : getDefaultParamsResponse.status,
                        toCreationTimestamp: DateTime.parse(_filterParams.endDate ?? Constants.defaultEndDate.toString()).endOfDay.toString(),
                        toResponseTimestamp: null,
                      ),
                    ),
                listBuilder: (cards) {
                  return  ListView.separated(
                      separatorBuilder: (context, number) => Height.v8,
                      itemCount: cards.length,
                      itemBuilder: (context, index) {
                        return PaymentCard(payment: cards[index], currency: userInformationResponse.user?.currency ?? '',);
                      }
                  );
                },
              );
            },
          );
    }
          ),
        ),
      ],
    );
  }
}
