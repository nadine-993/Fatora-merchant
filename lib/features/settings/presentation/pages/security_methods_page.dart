import 'package:easy_localization/easy_localization.dart';
import 'package:fatora/core/constants/helpers.dart';
import 'package:fatora/core/widgets/error_widget.dart';
import 'package:fatora/core/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local_auth/local_auth.dart';

import 'package:fatora/core/constants/app_colors.dart';
import 'package:fatora/core/constants/app_styles.dart';
import 'package:fatora/core/widgets/padding_widget.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/di.dart';
import '../../../../core/utils/navigation.dart';
import '../../../../core/utils/shared_perefrences/shared_perefrences_helper.dart';
import '../../../../core/widgets/common_appbar.dart';
import '../../../../core/widgets/custom_button.dart';

enum SupportState {
  unknown,
  supported,
  unsupported,
}

class SecurityMethodsPage extends StatefulWidget {
  const SecurityMethodsPage({Key? key}) : super(key: key);

  @override
  State<SecurityMethodsPage> createState() => _SecurityMethodsPageState();
}

class _SecurityMethodsPageState extends State<SecurityMethodsPage> {
  List<BiometricType>? _availableBiometrics;
  final LocalAuthentication auth = LocalAuthentication();
  bool? _canCheckBiometrics;
  SupportState supportState = SupportState.unknown;



  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  final AppPreferences _appPreferences = instance<AppPreferences>();


  @override
  void initState() {
    super.initState();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => supportState = isSupported
          ? SupportState.supported
          : SupportState.unsupported),
    );
  }

  Future<List<BiometricType>?> getBiometrics() async {
    return await auth.getAvailableBiometrics();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: supportState == SupportState.supported ? false : true,
/*      bottomNavigationBar: supportState == SupportState.supported ? Padding(
        padding: const EdgeInsets.all(15),
        child: CustomButton(
          text: AppStrings.save,
          onTap: () {
            Navigation.pop(context);
          },
          enabled: true,
        ),
      ) : null,*/
      appBar: CommonAppBars.inner(AppStrings.security),
      body: PaddingWidget(
        child: supportState == SupportState.supported ?
        FutureBuilder(
          future: getBiometrics(),
          builder: (context, AsyncSnapshot<List<BiometricType>?> snapshot) {
            if(snapshot.hasData) {
              return Column(
                children: [
                  SecurityToggle(title: 'fingerprintNfaceID'.tr(), onToggle: () => _appPreferences.setFingerprint(true), untoggleSwitch: () => _appPreferences.setFingerprint(false), securityType: SecurityType.fingerprint,),
                  SecurityToggle(title: 'keeploggedin'.tr(), onToggle: () => _appPreferences.setSavePassword(true), untoggleSwitch: () => _appPreferences.setSavePassword(false), securityType: SecurityType.savePassword),

                ],
              );
            }
            else if(snapshot.hasError) {
              return const CustomErrorWidget();
            }
            return const LoadingWidget();
          },
        ) :
        _getSupportWidget()
        ,
      ),
    );
  }

  Center _getSupportWidget() {
    return Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.no_encryption_gmailerrorred, color: AppColors.primary, size: 80.h,),
          Height.v12,
          Text('devicehasnoauthentication'.tr(), textAlign: TextAlign.center, style: AppStyles.title,),
        ],
      ));
  }
}

enum SecurityType {
  savePassword,
  fingerprint
}

class SecurityToggle extends StatefulWidget {
  const SecurityToggle({Key? key, required this.title, required this.onToggle, required this.untoggleSwitch, required this.securityType}) : super(key: key);
  
  final String title;
  final Function onToggle;
  final SecurityType securityType;
  final Function untoggleSwitch;

  @override
  State<SecurityToggle> createState() => _SecurityToggleState();
}

class _SecurityToggleState extends State<SecurityToggle> {
  static final AppPreferences _appPreferences = instance<AppPreferences>();

  bool isSwitchedFinger = _appPreferences.getFingerprint();
  bool isSwitchedPassword = _appPreferences.getSavePassword();
  late bool isSwitched;
  @override
  void initState() {
    isSwitched = widget.securityType == SecurityType.fingerprint ? isSwitchedFinger : isSwitchedPassword;
    super.initState();
  }

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        BiometricType.fingerprint;
        widget.onToggle();
      });
    } else {
      setState(() {
        isSwitched = false;
        widget.untoggleSwitch();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.title,
          style: AppStyles.title,
        ),
        Switch(
          onChanged: toggleSwitch,
          value: isSwitched,
          activeColor: AppColors.secondary,
          activeTrackColor: AppColors.secondary.withOpacity(0.5),
          inactiveThumbColor: AppColors.lightGray,
          inactiveTrackColor: AppColors.midGray,
        ),
      ],
    );
  }
}
