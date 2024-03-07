import 'package:fatora/core/constants/app_colors.dart';
import 'package:fatora/core/constants/helpers.dart';
import 'package:fatora/core/utils/navigation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/api/core_models/base_result_model.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/di.dart';
import '../../../../core/utils/shared_perefrences/shared_perefrences_helper.dart';
import '../../../../core/widgets/circular_button.dart';
import '../../../../core/widgets/padding_widget.dart';
import 'package:fatora/core/widgets/common_appbar.dart';

import '../../../client/data/models/client_model.dart';
import '../../../notification/presentation/view/notifications_list_tab.dart';
import '../../../payment/presentation/payment_functions.dart';
import '../../../payment/presentation/views/add_payment_page.dart';
import '../../../payment/presentation/views/payment_list_tab.dart';
import '../../../settings/data/models/get_default_params_response.dart';
import '../../../settings/domain/repository/settings_repo.dart';
import '../widgets/terminal_small_card.dart';

class TerminalPage extends StatefulWidget {
  const TerminalPage({
    Key? key,
    required this.client,
    required this.terminalId,
    this.clearFilter = false,
  }) : super(key: key);

  final Client client;
  final String terminalId;
  final bool clearFilter;

  @override
  State<TerminalPage> createState() => _TerminalPageState();
}

class _TerminalPageState extends State<TerminalPage> {
  int _selectedIndex = 0;

  static final AppPreferences _appPreferences = instance<AppPreferences>();
  List<String> _selectedStatus = [];


  @override
  void initState() {
    super.initState();
    if(widget.clearFilter) {
      _appPreferences.clearFilters();
      _appPreferences.clearFirstFilter();
    }
    _getDefaultList();
  }



  void _getDefaultList() async {
      BaseResultModel? res = await SettingsRepository.getDefaultParams();
      if(res is GetDefaultParamsResponse?) {
        _selectedStatus = res!.status!;
      }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: _selectedIndex == 0
            ? CircularButton(
                onPressed: () {
                  Navigation.push(
                      context,
                      AddPaymentPage(
                        fromHomePage: false,
                          client: widget.client,
                          terminal: widget.terminalId,
                      ));
                },
              )
            : null,
        appBar: CommonAppBars.inner(AppStrings.terminal),
        body: PaddingWidget(
          child: Column(
            children: [
              TerminalSmallCard(
                  client: widget.client, terminalId: widget.terminalId),
              Height.v12,
              Container(
                height: 50,
                decoration: BoxDecoration(
                    color: AppColors.lightGray,
                    borderRadius: BorderRadius.circular(10.0)),
                child: TabBar(
                  onTap: (selected) {
                    setState(() {
                      _selectedIndex = selected;
                    });
                  },
                  indicator: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10.0)),
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.darkGray,
                  tabs:  [
                    Tab(
                      text: AppStrings.payments,
                    ),
                    Tab(
                      text: AppStrings.notifications,
                    )
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  dragStartBehavior: DragStartBehavior.down,
                  children: [
                    PaymentListTab(
                      client: widget.client,
                      terminalId: widget.terminalId,
                      defaultStatuses: _selectedStatus,
                    ),
                     NotificationsListTab(
                      terminalId: widget.terminalId,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
