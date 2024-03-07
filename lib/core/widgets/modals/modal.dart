import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';


class BottomSheets {
  static Future<dynamic> showModal(
      BuildContext context, {
        required Widget child,
        bool isBig = false,
      }) async {
    return showModalBottomSheet<dynamic>(
      backgroundColor: Colors.transparent,
      context: context,
      isDismissible: true,
      barrierColor: AppColors.lightGray,
      isScrollControlled: true,
      enableDrag: true,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 30,
                color: Colors.black.withOpacity(0.1),
              )
            ],
          ),
          child: Popover(child: child, isBig: isBig),
        );
      },
    );
  }
}

class Popover extends StatelessWidget {
  final bool isBig;

  const Popover({
    Key? key,
    required this.child,
    this.isBig = false,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height / 3,
          maxHeight: MediaQuery.of(context).size.height * 9 / 10,
        ),
        clipBehavior: Clip.antiAlias,
        decoration: const  BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
            bottom: Radius.circular(0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isBig) child else Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

