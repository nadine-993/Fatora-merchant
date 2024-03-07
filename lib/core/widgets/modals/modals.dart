import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/helpers.dart';

class SmallModal extends StatefulWidget {
  final Function confirm;
  final Widget content;

  const SmallModal({
    Key? key,
    required this.confirm,
    required this.content,
  }) : super(key: key);

  @override
  _SmallModalState createState() => _SmallModalState();
}

class _SmallModalState extends State<SmallModal> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Height.v16,
            const ModalHandle(),
            Height.v24,
            widget.content,
          ],
        ).respectGuidelinesMargins(),
      ),
    );
  }
}



class ModalHandle extends StatelessWidget {
  const ModalHandle({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 38,
          height: 5,
          decoration: BoxDecoration(
            color: AppColors.midGray,
            borderRadius: BorderRadius.circular(40),
          ),
        ),
      ],
    );
  }
}
