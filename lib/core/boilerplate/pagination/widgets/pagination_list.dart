import 'package:easy_localization/easy_localization.dart';
import 'package:fatora/core/constants/app_assets.dart';
import 'package:fatora/core/constants/app_styles.dart';
import 'package:fatora/core/widgets/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../utils/navigation.dart';
import '../../../widgets/animations/fade_animation.dart';
import '../../../widgets/error_widget.dart';
import '../../../widgets/no_data_widget.dart';
import '../cubits/pagination_cubit.dart';

typedef CreatedCallback = void Function(PaginationCubit cubit);

typedef ListBuilder<Model> = Widget Function(List<Model> list);

//typedef AsyncWidgetBuilder<T> = Widget Function(BuildContext context, AsyncSnapshot<T> snapshot);

class PaginationList<Model> extends StatefulWidget {
  final RepositoryCallBack? repositoryCallBack;
  final ListBuilder<Model>? listBuilder;
  final CreatedCallback? onCubitCreated;
  final bool? withPagination;
  final bool withEmptyWidget;
  final Map<String, dynamic>? initialParam;
  final VoidCallback? onRefresh;
  final Axis scrollDirection;
  final Widget? errorWidget;
  final Widget? noDataWidget;
  const PaginationList(
      {Key? key,
        this.noDataWidget,
        this.errorWidget,
        this.scrollDirection = Axis.vertical,
        this.repositoryCallBack,
        this.listBuilder,
        this.withPagination = false,
        this.onCubitCreated,
        this.initialParam,
        this.withEmptyWidget = true,
        this.onRefresh})
      : super(key: key);

  @override
  PaginationListState<Model> createState() => PaginationListState<Model>();
}

class PaginationListState<Model> extends State<PaginationList<Model>> {
  final RefreshController _refreshController = RefreshController();
  PaginationCubit<Model>? cubit;

  @override
  void initState() {
    cubit = PaginationCubit<Model>(widget.repositoryCallBack!);
    if (widget.onCubitCreated != null) {
      widget.onCubitCreated!(cubit!);
    }
    cubit?.getList(param: widget.initialParam);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildConsumer();
  }

  _buildConsumer() {
    return BlocConsumer<PaginationCubit<Model>, PaginationState>(
        bloc: cubit,
        listener: (context, state) {
          if (state is Error) {

          } else if (state is GetListSuccessfully) {
            if (widget.onRefresh != null) widget.onRefresh!();
            _refreshController.refreshCompleted();
            if (state.noMoreData) {
              _refreshController.loadNoData();
            } else {
              _refreshController.loadComplete();
            }
          }
        },
        builder: (context, state) {
          if (state is Loading) {
            return const Center(child: LoadingWidget());
          } else if (state is GetListSuccessfully) {
            return smartRefresher(state.list as List<Model>);
          } else if (state is Error) {
            return  CustomErrorWidget();
            return const SizedBox.shrink();
          } else {
            return Container();
          }
        });
  }

  smartRefresher(List<Model> list) {
    Widget child;
    if (list.isEmpty && widget.withEmptyWidget) {
      child = widget.noDataWidget ?? const NoDataWidget();
    } else {
      child = widget.listBuilder!(list);
    }

    return SmartRefresher(
      scrollDirection: widget.scrollDirection,
      enablePullDown: widget.scrollDirection == Axis.vertical,
      enablePullUp: widget.scrollDirection == Axis.vertical,
      header: const MaterialClassicHeader(),
      controller: _refreshController,
      onRefresh: () async {
        cubit?.getList();
      },
      onLoading: () async {
        cubit?.getList(loadMore: true);
      },
      footer: customFooter,
      child: child,
    );
  }


  var customFooter = CustomFooter(
    builder: (BuildContext? context,LoadStatus? mode){
      Widget body ;
      if(mode==LoadStatus.idle){
        body =  Text("loadmore".tr(), style: AppStyles.title,);
      }
      else if(mode==LoadStatus.loading){
        body =  Lottie.asset(
            AppAssets.loader,
            repeat: true
        );
      }
      else if(mode == LoadStatus.failed){
        body = Text("loadfailed".tr());
      }
      else if(mode == LoadStatus.canLoading){
        body =  Text("releasetoloadmore".tr(), style: AppStyles.title,);
      }
      else{
        body = Text("nomoredata".tr(), style: AppStyles.title,);
      }
      return SizedBox(
        height: 55.0,
        child: Center(child:body),
      );
    },
  );
}
