import 'package:fatora/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:fatora/core/constants/app_strings.dart';
import 'package:fatora/core/constants/app_styles.dart';
import 'package:fatora/core/constants/helpers.dart';
import 'package:fatora/core/methods/methods.dart';
import 'package:fatora/core/utils/navigation.dart';
import 'package:fatora/core/widgets/common_appbar.dart';
import 'package:fatora/core/widgets/custom_button.dart';
import 'package:fatora/core/widgets/padding_widget.dart';
import 'package:fatora/core/widgets/titled_widget.dart';
import 'package:fatora/features/payment/presentation/views/add_payment_page.dart';
import 'package:fatora/features/terminal/presentation/views/terminal_page.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_dropdown_flutter/multiselect_dropdown_flutter.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_lists.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/utils/di.dart';
import '../../../../core/utils/shared_perefrences/shared_perefrences_helper.dart';
import '../../../../core/utils/toast.dart';
import '../../../../core/widgets/multi_date_picker.dart';
import '../../../client/data/models/client_model.dart';
import '../../../settings/data/models/get_default_params_response.dart';
import '../../../settings/domain/repository/settings_repo.dart';
import '../../data/models/filter_params.dart';
import '../payment_functions.dart';

class FilterPaymentsPage extends StatefulWidget {
  const FilterPaymentsPage(
      {Key? key, required this.client, required this.terminalId, })
      : super(key: key);

  final Client client;
  final String? terminalId;

  @override
  State<FilterPaymentsPage> createState() => _FilterPaymentsPageState();
}

class _FilterPaymentsPageState extends State<FilterPaymentsPage> {
  final _amountController = TextEditingController();

  List<String> _selectedStatus = [];
  List<String> _selectedStatusLetters = [];


  DateTime? _startDate;
  DateTime? _endDate;

  static final AppPreferences _appPreferences = instance<AppPreferences>();


  @override
  void initState() {
    super.initState();
    FilterParams filterParams = _appPreferences.getFilters();
    _startDate = DateTime.parse(filterParams.startDate ?? Constants.defaultStartDate.toString());
    _endDate = filterParams.endDate != null ? DateTime.parse(filterParams.endDate ?? Constants.defaultEndDate.toString()) : Constants.defaultEndDate;
    _amountController.text = filterParams.amount ?? '';
    _selectedStatus = filterParams.statuses ?? ['Approved', 'Reversed'];
    print('here' + _appPreferences.getFirstFilter().toString());
  }



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: _getSearchButton(context),
      ),
      appBar: CommonAppBars.inner(AppStrings.filter,
          action: TextButton(
              onPressed: () {
                setState(() {
                  setState(() {
                    _startDate = DateTime.parse(Constants.defaultStartDate.toString());
                    _endDate = DateTime.parse(Constants.defaultEndDate.toString());
                    _amountController.clear();
                    _selectedStatus = ['Approved', 'Reversed'];
                  });
                });
              },
              child: Text(
                AppStrings.clear,
                style: AppStyles.title.copyWith(color: AppColors.red),
              ))),
      body: _getBody(),
    );
  }

  CustomButton _getSearchButton(BuildContext context) {
    return CustomButton(
      iconData: AppIcons.search,
      onTap: () {
        _appPreferences.setFirstFilter();
        _appPreferences.setFilters(
            _amountController.text,
            _selectedStatus,
            _startDate.toString(),
            _endDate.toString()
        );
        Navigation.pop(context);
        Navigation.popThenPush(
            context,
            TerminalPage(
                client: widget.client,
                terminalId: widget.terminalId ?? '',
            ));
      },
      enabled: true,
      text: AppStrings.search,
    );
  }

  Widget _getBody() {
    return PaddingWidget(
        child: Form(
          child: Column(
            children: [
              // Amount Input
              AmountKeyboardInput(amountController: _amountController, readOnly: false),

              Height.v12,

              // Status Multiselect
              GetModel<GetDefaultParamsResponse>(
                repositoryCallBack: (json) => SettingsRepository.getDefaultParams(),
                modelBuilder: (model) {
                  return TitledWidget(
                    title: Text(AppStrings.status, style: AppStyles.title,),
                    child: SizedBox(
                      height: 65,
                      child: MultiSelectDropdown.simpleList(
                        listTextStyle: AppStyles.title,
                        boxDecoration: BoxDecoration(
                          color: AppColors.lightGray,
                          borderRadius: BorderRadius.circular(10),
                          border: null,
                        ),
                        includeSelectAll: true,
                        isLarge: true,
                        list: AppLists.statusList,
                        initiallySelected: _appPreferences.getFirstFilter() ? PaymentFunctions.getStatusNames(model.status!.isEmpty ? ['A', 'R'] : model.status!) :  _selectedStatus,
                        onChange: (newList) {
                          _selectedStatus = newList.map((dynamic item) => item.toString()).toList();
                        },
                        textStyle: AppStyles.title,
                      ),
                    ),);
                },
              ),


              Height.v12,

              // Date picker
              TitledWidget(
                title: Text(AppStrings.dateRange, style: AppStyles.title,),
                child: MultiDatePicker(
                  startDate: _startDate!,
                  endDate: _endDate!,

                  hintText: _endDate != null ?
                  '${Methods.getDate(_startDate.toString())} - ${Methods
                      .getDate(_endDate.toString())}' : Methods.getDate(_startDate.toString()),
                  suffixIcon: Icons.access_time_outlined,
                  selectedValue:
                  '${Methods.getDate(_startDate.toString())} - ${Methods.getDate(_endDate.toString())}' ,
                  onSubmit: (Object? value) {
                    if (value is PickerDateRange) {
                      if(value.startDate == null || value.endDate == null) {
                        Toasts.showToast( AppStrings.dateRangeWarning, ToastType.error);
                      }
                      else {
                        setState(() {
                          _startDate = value.startDate;
                          _endDate = value.endDate;
                        });
                        Navigation.pop(context);
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
