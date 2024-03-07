import 'package:easy_localization/easy_localization.dart';
import 'package:fatora/core/boilerplate/get_model/cubits/get_model_cubit.dart';
import 'package:fatora/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:fatora/core/constants/app_strings.dart';
import 'package:fatora/core/constants/helpers.dart';
import 'package:fatora/features/advertisment/data/advertisment_response_model.dart';
import 'package:fatora/features/terminal/domain/repository/terminal_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/api/core_models/base_response_model.dart';
import '../../../../core/api/errors/base_error.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_keys.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/utils/di.dart';
import '../../../../core/utils/shared_perefrences/shared_perefrences_helper.dart';
import '../../../../core/widgets/common_appbar.dart';
import '../../../../core/widgets/confirmation_popup.dart';
import '../../../../core/widgets/drawer_widget.dart';
import '../../../advertisment/data/advertisement_model.dart';
import '../../../advertisment/domain/advertisement_repo.dart';
import '../../../client/data/models/client_response_model.dart';
import '../../../client/domain/repository/client_repo.dart';
import '../../../settings/data/models/check_update_response_model.dart';
import '../../../settings/domain/repository/settings_repo.dart';
import '../../../terminal/data/models/terminal_response_model.dart';
import '../widgets/carousel_with_indicator.dart';
import '../widgets/terminal_card.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> terminals = [];

  List<String> splittedTerminals = [];

  int numberOfTerminals = 0;
  
  int terminalNumber = 1;

  List<Widget> terminalCards = [];

  static final AppPreferences _appPreferences = instance<AppPreferences>();

  GetModelCubit? getModel;

  bool reDraw = true;

  static Future<void> checkUpdate(BuildContext context) async {
    final res = await SettingsRepository.checkUpdate(Constants.APP_VERSION);
    if(res is CheckUpdateResponseModel) {
      if(res.availableUpdate!) {
        if(res.isMajor!) {
          Dialogs.updateApp(context: AppKeys.navigatorKey.currentContext ?? context, isMajor: false);
        }
        else {
          Dialogs.updateApp(context: AppKeys.navigatorKey.currentContext ?? context, isMajor: true);
        }
      }
      else {

      }

    }
    else if(res is ServerError) {
    }
    else if (res is BaseError){
    }
    else {
    }
  }


  @override
  void initState() {
    _appPreferences.clearFilters();
    _appPreferences.clearFirstFilter();
    checkUpdate(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBars.home(AppStrings.home),
        drawer: DrawerWidget(),
        body: RefreshIndicator(
          onRefresh: () {
            setState(() {
              reDraw = false;
            });
            Future.delayed(const Duration(milliseconds: 0), () {
              setState(() {
                terminalCards = [];
                reDraw = true;
              });
            });
            return Future.delayed(const Duration(seconds: 0));
          },
          child: ListView(
            children: [
              _buildSlider(),
              Height.v16,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(AppStrings.terminals,
                    style: AppStyles.title.copyWith(
                        color: AppColors.darkGray,
                        fontWeight: FontWeight.bold)),
              ),
              reDraw == true ?
              _buildTerminalsList(context) : const SizedBox.shrink()
            ],
          ),
        )
    );
  }

  Padding _buildTerminalsList(BuildContext context) {
    return Padding(
              padding: const EdgeInsets.all(12.0),
              child: GetModel<ClientListResponse>(
                  onSuccess: (ClientListResponse model) async {
                    setState(() {
                      reDraw = true;
                    });
                    for (int i = 0; i < model.list.length; i++) {
                      TerminalResponseModel? res =
                      (await TerminalRepository.getAllClientTerminals(
                          model.list[i].id)) as TerminalResponseModel?;
                      List<String> clientTerminals = res?.terminals ?? [];
                      setState(() {
                        for(int j = 0; j < clientTerminals.length; j++) {
                          terminalCards.add(
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: TerminalCard(
                                  client: model.list[i],
                                  terminal: clientTerminals[j],
                                  size: MediaQuery.of(context).size.width,),
                              )
                          );
                        }
                      });
                    }
                  },
                  repositoryCallBack: (data) =>
                      ClientRepository.getAllUserClients(),
                  modelBuilder: (ClientListResponse model) {
                    return SizedBox(
                      height: terminalCards.length * 125,
                      child: Column(
                        children: List.generate(
                            terminalCards.length,
                                (index) => terminalCards[index]),
                      ),
                    );
                  }),
            );
  }


  _buildSlider() {
    return GetModel<AdvertisementsResponseModel>(
      error: Center(child: Text('errorloading'.tr(), style: AppStyles.title,)),
      loading: Shimmer.fromColors(
        baseColor: AppColors.primary,
        highlightColor: AppColors.secondary,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.primary,
            ),
            height: 130.0.h,
          ),
        ),
      ),
      onCubitCreated: (cubit) {
        getModel = cubit;
      },
      repositoryCallBack: (data) => AdvertisementRepository.getAdvertisements(),
      modelBuilder: (ads) {
        List<Advertisement> images = [];
        for(int i = 0; i < ads.list!.length; i++) {
          images.add(ads.list![i]);
        }
        return images.isEmpty ?
          const SizedBox.shrink() :
          CarouselWithIndicator(
          imgList: List.generate(images.length, (index) => images[index]),
        );
      },
    );
  }
}
