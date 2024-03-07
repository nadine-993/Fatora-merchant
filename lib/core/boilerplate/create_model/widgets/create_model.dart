import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants/app_colors.dart';
import '../../../utils/toast.dart';
import '../cubits/create_model_cubit.dart';

typedef CreatedCallback = void Function(CreateModelCubit cubit);
typedef ModelCreated<Model> = Function(Model model);

class CreateModel<Model> extends StatefulWidget {
  final ModelCreated<Model>? onSuccess;
  final VoidCallback? onFailure;
  final bool? onlyFailure;
  final double? loadingHeight;
  final RepositoryCallBack? repositoryCallBack;
  final CreatedCallback? onCubitCreated;
  final Widget child;
  final Widget? loading;

  const CreateModel(
      {Key? key,
      this.repositoryCallBack,
      this.onCubitCreated,
      required this.child,
      this.onSuccess,
      this.onFailure,
      this.loadingHeight, this.onlyFailure = false, this.loading})
      : super(key: key);

  @override
  State<CreateModel<Model>> createState() => _GetModelState<Model>();
}

class _GetModelState<Model> extends State<CreateModel<Model>> {
  CreateModelCubit<Model>? cubit;

  @override
  void initState() {
    cubit = CreateModelCubit<Model>(widget.repositoryCallBack!);
    if (widget.onCubitCreated != null) {
      widget.onCubitCreated!(cubit!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateModelCubit, CreateModelState>(
      bloc: cubit,
      builder: (context, state) {
        if (widget.onCubitCreated != null) {
          widget.onCubitCreated!(cubit!);
        }

        if (state is CreateModelInitial) {
          print('CreateModelInitial');
          return widget.child;
        }

        else if (state is Loading) {
          print('CreateModel Loading');
          return widget.loading ?? Shimmer.fromColors(
            baseColor: AppColors.primary.withOpacity(0.5),
            highlightColor: AppColors.secondary.withOpacity(0.5),
            child: widget.child,
          );
        }

        else if (state is CreateModelSuccessfully) {
          print('CreateModelSuccessfully');
          return widget.child;
        }


        else {
            print('CreateModel Else');
            return widget.child;
          }
      },
      listener: (context, state) {
        if (state is CreateModelSuccessfully) {
          print('CreateModelSuccessfully listener');
          if(widget.onSuccess != null) {
            widget.onSuccess!(state.model);
          }
        }
        if (state is Error) {
          if(widget.onlyFailure == true) {
            if(widget.onFailure != null) {
              widget.onFailure!();
            }
          }
          else {
            print('CreateModel Error listener');
            if(widget.onFailure != null) {
              widget.onFailure!();
            }
            Toasts.showToast(state.message.toString(), ToastType.error);
          }
        }
      },
    );
  }
}
