import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/fatora_input.dart';

class TriggerInput extends StatelessWidget {
  const TriggerInput({
    super.key,
    required TextEditingController triggerController, this.onEditingComplete,
  }) : _triggerController = triggerController;

  final TextEditingController _triggerController;
  final void Function()? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return FatoraInput(
      isLast: true,
        onEditingComplete: onEditingComplete,
        label: AppStrings.trigger,
        hint: AppStrings.triggerHint,
        textEditingController: _triggerController,
        prefixIcon: const Icon(Icons.web_rounded, color: AppColors.primary),
        inputType: TextInputType.url,
        validationType: ValidationType.none
    );
  }
}

class NotesInput extends StatelessWidget {
  const NotesInput({
    super.key,
    required TextEditingController notesController, this.onEditingComplete,
  }) : _notesController = notesController;

  final TextEditingController _notesController;
  final void Function()? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return FatoraDesInput(
        isLast: true,
        onEditingComplete: onEditingComplete,
        label: AppStrings.notes,
        hint:"Payment description",
        textEditingController: _notesController,
        prefixIcon: const Icon(Icons.sticky_note_2_outlined, color: AppColors.primary,weight: 20,size: 22),
        inputType: TextInputType.multiline,
        validationType: ValidationType.none
    );
  }
}