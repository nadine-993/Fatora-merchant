import 'package:fatora/core/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/error_widget.dart';
import '../cubits/get_model_cubit.dart';

typedef CreatedCallback = void Function(GetModelCubit cubit);
typedef ModelBuilder<Model> = Widget Function(Model model);
typedef ModelReceived<Model> = Function(Model model);

class GetModel<Model> extends StatefulWidget {
  final double? loadingHeight;
  final Widget? loading;
  final Widget? error;

  final ModelBuilder<Model>? modelBuilder;
  final ModelReceived<Model>? onSuccess;
  final VoidCallback? onFailure;

  final RepositoryCallBack? repositoryCallBack;
  final CreatedCallback? onCubitCreated;
  final bool withAnimation;
  final bool withRefresh;

  const GetModel({
    Key? key,
    this.repositoryCallBack,
    this.onCubitCreated,
    this.modelBuilder,
    this.onSuccess,
    this.onFailure,
    this.loadingHeight,
    this.loading,
    this.withAnimation = true,
    this.withRefresh = true, this.error,
  }) : super(key: key);

  @override
  State<GetModel<Model>> createState() => _GetModelState<Model>();
}

class _GetModelState<Model> extends State<GetModel<Model>> {
  GetModelCubit<Model>? cubit;

  @override
  void initState() {
    cubit = GetModelCubit<Model>(widget.repositoryCallBack!);
    if (widget.onCubitCreated != null) {
      widget.onCubitCreated!(cubit!);
    }
    cubit?.getModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetModelCubit, GetModelState>(
      bloc: cubit,
      builder: (context, state) {
        if (state is GetModelLoading) {
          print('GetModel Loading Builder');
          return widget.loading ?? const LoadingWidget();
        } else {
          if (state is GetModelSuccessfully) {
            print('GetModel Success Builder');
            return buildModel(state.model);
          } else if (state is GetModelError) {
            print('GetModel Error Builder');
            return widget.error ?? const CustomErrorWidget();
          } else {
            print('GetModel Other Builder');
            return Container();
          }
        }
      },
      listener: (context, state) {
        if (state is GetModelSuccessfully && widget.onSuccess != null) {
          print('GetModel Success Listener');
          widget.onSuccess!(state.model);
        }
        if (state is GetModelError && widget.onFailure != null) {
          print('GetModel Error Listener');
          widget.onFailure!();
        }
      },
    );
  }

  buildModel(Model model) {
    return widget.withRefresh
        ? RefreshIndicator(
            child: widget.modelBuilder!(model),
            onRefresh: () {
              cubit?.getModel();
              return Future.delayed(const Duration(seconds: 1));
            })
        : widget.modelBuilder!(model);
  }
}
