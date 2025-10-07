import 'package:admin_pannel/features/data/datasource/service_remote_datasource.dart';
import 'package:admin_pannel/features/data/datasource/banner_remote_datasource.dart';
import 'package:admin_pannel/features/data/repo/service_repo_impl.dart';
import 'package:admin_pannel/features/data/repo/banner_repo_impl.dart';
import 'package:admin_pannel/features/domain/repo/service_repo.dart';
import 'package:admin_pannel/features/domain/repo/banner_repo.dart';
import 'package:admin_pannel/features/domain/usecase/fetch_service_usecase.dart';
import 'package:admin_pannel/features/domain/usecase/service_usecase.dart';
import 'package:admin_pannel/features/domain/usecase/fetch_client_banner_usecase.dart';
import 'package:admin_pannel/features/domain/usecase/fetch_barber_banner_usecase.dart';
import 'package:admin_pannel/features/presentation/state/bloc/fetch_service_bloc/fetch_service_bloc.dart';
import 'package:admin_pannel/features/presentation/state/bloc/service_manage_bloc/service_manage_bloc.dart';
import 'package:admin_pannel/features/presentation/state/bloc/fetch_client_banner_bloc/fetch_client_banner_bloc.dart';
import 'package:admin_pannel/features/presentation/state/bloc/fetch_barber_banner_bloc/fetch_barber_banner_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Service Management
  
  // Bloc
  sl.registerFactory(
    () => FetchingServiceBloc(
      sl(),
    ),
  );
  
  sl.registerFactory(
    () => ServiceMangementBloc(
      repo: sl(),
    ),
  );

  // Banner Blocs
  sl.registerFactory(
    () => FetchUserBannerBloc(
      sl(),
    ),
  );

  sl.registerFactory(
    () => FetchBannerBarberBloc(
      sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => FetchServiceUsecase(sl()));
  sl.registerLazySingleton(() => ServiceManagementUsecase(sl()));
  sl.registerLazySingleton(() => FetchClientBannerUsecase(sl()));
  sl.registerLazySingleton(() => FetchBarberBannerUsecase(sl()));

  // Repository
  sl.registerLazySingleton<ServiceManagementRepository>(
    () => ServiceManagementRepositoryImpl(dataSource: sl()),
  );

  sl.registerLazySingleton<BannerRepository>(
    () => BannerRepositoryImpl(dataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton(() => ServiceRemoteDatasource());
  sl.registerLazySingleton(() => BannerRemoteDatasource(FirebaseFirestore.instance));
}
