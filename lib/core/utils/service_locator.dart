import 'package:get_it/get_it.dart';

import '../boilerplate/pagination/cubits/pagination_cubit.dart';

class ServiceLocator{
  static void registerModels(){
    GetIt.I.registerLazySingleton<CubitStore>(() => CubitStore());

  }

  static refreshPayments(){
    GetIt.I<CubitStore>().payments.getList();
  }

  static setPayments(PaginationCubit payments){
    GetIt.I<CubitStore>().payments = payments;
  }

}

class CubitStore{
  late PaginationCubit payments;
}