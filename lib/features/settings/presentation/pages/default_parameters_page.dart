import 'package:fatora/core/api/core_models/base_result_model.dart';
import 'package:fatora/core/api/core_models/empty_model.dart';
import 'package:fatora/core/boilerplate/create_model/cubits/create_model_cubit.dart';
import 'package:fatora/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:fatora/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:fatora/core/constants/helpers.dart';
import 'package:fatora/core/utils/navigation.dart';
import 'package:fatora/core/widgets/common_appbar.dart';
import 'package:fatora/core/widgets/custom_button.dart';
import 'package:fatora/core/widgets/padding_widget.dart';
import 'package:fatora/features/payment/presentation/payment_functions.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_dropdown_flutter/multiselect_dropdown_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_lists.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/widgets/titled_widget.dart';
import '../../../payment/presentation/widgets/callback_input_widget.dart';
import '../../../payment/presentation/widgets/tigger_input_widget.dart';
import '../../data/models/get_default_params_response.dart';
import '../../data/models/set_default_params_request.dart';
import '../../domain/repository/settings_repo.dart';

class DefaultParametersPage extends StatefulWidget {
  const DefaultParametersPage({Key? key}) : super(key: key);

  @override
  State<DefaultParametersPage> createState() => _DefaultParametersPageState();
}

class _DefaultParametersPageState extends State<DefaultParametersPage> {

  final _callbackController = TextEditingController();
  final _triggerController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<String> _selectedStatus = [];
  List<String> _selectedStatusLetters = [];


  @override
  void initState() {
    _getDefaultList();
    super.initState();
  }



  void _getDefaultList() async {
    setState(() async{
      BaseResultModel? res = await SettingsRepository.getDefaultParams();
      if(res is GetDefaultParamsResponse?) {
        _selectedStatus = PaymentFunctions.getStatusNames(res!.status ?? []);
        _selectedStatusLetters = res!.status ?? [];
      }
    });
  }

  late CreateModelCubit _paramsCubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15),
        child: CreateModel<EmptyModel>(
          repositoryCallBack: (data) => SettingsRepository.setDefaultParams(data),
          onSuccess: (model) {
            Navigation.pop(context);
          },
          onCubitCreated: (cubit) {
            _paramsCubit = cubit;
          },
          child: CustomButton(
            iconData: AppIcons.save,
            text: AppStrings.save,
            onTap: () {
              _paramsCubit.createModel(SetDefaultParamsRequest(
                triggerURL: _triggerController.text,
                callbackURL: _callbackController.text,
                status: _selectedStatusLetters
              ));
            },
            enabled: true,
          ),
        ),
      ),
      appBar: CommonAppBars.inner(AppStrings.defaultParams),
      body: GetModel<GetDefaultParamsResponse>(
        onSuccess: (model) {
          setState(() {
            _callbackController.text = model.callbackURL ?? '';
            _triggerController.text = model.triggerURL ?? '';
          });
        },
        repositoryCallBack: (data) => SettingsRepository.getDefaultParams(),
        modelBuilder: (model) {
          return PaddingWidget(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CallbackInput(callbackController: _callbackController),

                  Height.v8,

                  TriggerInput(
                      triggerController: _triggerController,
                    onEditingComplete: () {
                      // Hide the keyboard
                      FocusScope.of(context).requestFocus(FocusNode());

                      _paramsCubit.createModel(SetDefaultParamsRequest(
                          triggerURL: _triggerController.text,
                          callbackURL: _callbackController.text,
                          status: _selectedStatus
                      ));
                    },
                  ),

                  Height.v8,

                  // Status Multiselect
                  TitledWidget(
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
                        initiallySelected: _selectedStatus,
                        onChange: (newList) async{
                       /*   await SettingsRepository.setDefaultParams(SetDefaultParamsRequest(
                              triggerURL: _triggerController.text,
                              callbackURL: _callbackController.text,
                              status: PaymentFunctions.getStatusLetter(newList.map((dynamic item) => item.toString()).toList())
                          ));*/
                          _selectedStatus = newList.map((dynamic item) => item.toString()).toList();
                          _selectedStatusLetters = PaymentFunctions.getStatusLetter(_selectedStatus);

                        },
                        textStyle: AppStyles.title,
                      ),
                    ),),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}




