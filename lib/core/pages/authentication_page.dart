import 'package:easy_localization/easy_localization.dart';
import 'package:fatora/core/utils/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import '../../features/home/presentation/pages/home_page.dart';
import '../utils/di.dart';
import '../utils/shared_perefrences/shared_perefrences_helper.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key? key, this.fromResume = false}) : super(key: key);

  final bool? fromResume;

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final LocalAuthentication auth = LocalAuthentication();
  String _authorized = 'notauthorized'.tr();
  bool _isAuthenticating = false;

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'اثبت هويتك',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    setState(() {
      if(authenticated) {
        _authorized = 'Authorized';
        if(widget.fromResume!) {
          Navigation.pop(context);
        }
        else {
          Navigation.pushReplacement(context, HomePage());
        }
      }
      else {
        _authorized = 'notauthorized'.tr();
      }
    });

  }

  @override
  void initState() {
    super.initState();
    if(_authorized != 'Authorized') {
      if(_appPreferences.getFingerprint()) {
        _authenticate();
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    if(_authorized != 'Authorized') {
      if(_appPreferences.getFingerprint()) {
        _authenticate();
      }
    }
    return Scaffold(
    );
  }
}
