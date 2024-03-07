import 'package:flutter/material.dart';

import '../constants/app_values.dart';

class PaddingWidget extends StatelessWidget {
  const PaddingWidget({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: AppPadding.pagesPadding,
      child: child,
    );
  }
}
