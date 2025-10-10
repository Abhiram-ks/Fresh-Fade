import 'package:admin_pannel/features/data/datasource/service_remote_datasource.dart';
import 'package:admin_pannel/features/data/datasource/banner_remote_datasource.dart';
import 'package:admin_pannel/features/data/datasource/barber_remote_datasource.dart';
import 'package:admin_pannel/features/data/repo/service_repo_impl.dart';
import 'package:admin_pannel/features/data/repo/banner_repo_impl.dart';
import 'package:admin_pannel/features/data/repo/barber_repo_impl.dart';
import 'package:admin_pannel/features/data/repo/image_upload_repo_impl.dart';
import 'package:admin_pannel/features/data/repo/image_picker_repo_impl.dart';
import 'package:admin_pannel/features/domain/repo/service_repo.dart';
import 'package:admin_pannel/features/domain/repo/banner_repo.dart';
import 'package:admin_pannel/features/domain/repo/barber_repo.dart';
import 'package:admin_pannel/features/domain/repo/image_upload_repo.dart';
import 'package:admin_pannel/features/domain/repo/image_picker_repo.dart';
import 'package:admin_pannel/features/domain/usecase/fetch_service_usecase.dart';
import 'package:admin_pannel/features/domain/usecase/service_usecase.dart';
import 'package:admin_pannel/features/domain/usecase/fetch_client_banner_usecase.dart';
import 'package:admin_pannel/features/domain/usecase/fetch_barber_banner_usecase.dart';
import 'package:admin_pannel/features/domain/usecase/fetch_barber_usecase.dart';
import 'package:admin_pannel/features/domain/usecase/pick_image_usecase.dart';
import 'package:admin_pannel/features/domain/usecase/update_barber_status_usecase.dart';
import 'package:admin_pannel/features/presentation/state/bloc/fetch_service_bloc/fetch_service_bloc.dart';
import 'package:admin_pannel/features/presentation/state/bloc/service_manage_bloc/service_manage_bloc.dart';
import 'package:admin_pannel/features/presentation/state/bloc/fetch_client_banner_bloc/fetch_client_banner_bloc.dart';
import 'package:admin_pannel/features/presentation/state/bloc/fetch_barber_banner_bloc/fetch_barber_banner_bloc.dart';
import 'package:admin_pannel/features/presentation/state/bloc/fetch_barber_bloc/fetch_barber_bloc.dart';
import 'package:admin_pannel/features/presentation/state/bloc/image_upload_bloc/image_upload_bloc.dart';
import 'package:admin_pannel/features/presentation/state/bloc/image_delete_bloc/image_delete_bloc.dart';
import 'package:admin_pannel/features/presentation/state/bloc/image_picker_bloc/image_picker_bloc.dart';
import 'package:admin_pannel/features/presentation/state/bloc/splash_bloc/splash_bloc.dart';
import 'package:admin_pannel/features/presentation/state/cubit/progresser_cubit/progresser_cubit.dart';
import 'package:admin_pannel/features/presentation/state/cubit/radio_button_cubit/radio_button_cubit.dart';
import 'package:admin_pannel/service/cloudinary/cloudinary_service.dart';
import 'package:admin_pannel/service/firebase/firebase_image_service.dart';
import 'package:admin_pannel/features/data/datasource/auth_local_datasource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import '../../features/presentation/state/bloc/bloc_and_unbloc_bloc/blocandunbloc_bloc.dart';
import '../../features/presentation/state/bloc/request_bloc/request_bloc.dart';

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

  // Barber Bloc
  sl.registerFactory(
    () => FetchBarberBloc(
      sl(),
    ),
  );

  // Image Management Blocs
  sl.registerFactory(
    () => ImageUploadBloc(
      sl(),
      sl(),
      sl(),
    ),
  );

  sl.registerFactory(
    () => ImageDeletionBloc(
      sl(),
    ),
  );

  sl.registerFactory(
    () => PickImageBloc(
      sl(),
    ),
  );

  // Request Bloc
  sl.registerFactory(
    () => RequestBloc(
      usecase: sl(),
    ),
  );

  // Bloc & UnBloc Bloc
  sl.registerFactory(
    () => BlocandunblocBloc(
      usecase: sl(),
    ),
  );

  // Cubits
  sl.registerFactory(() => ProgresserCubit());
  sl.registerFactory(() => RadioCubit());

  // Use cases
  sl.registerLazySingleton(() => FetchServiceUsecase(sl()));
  sl.registerLazySingleton(() => ServiceManagementUsecase(sl()));
  sl.registerLazySingleton(() => FetchClientBannerUsecase(sl()));
  sl.registerLazySingleton(() => FetchBarberBannerUsecase(sl()));
  sl.registerLazySingleton(() => FetchBarberUsecase(sl()));
  sl.registerLazySingleton(() => PickImageUseCase(sl()));
  sl.registerLazySingleton(() => UpdateBarberStatusUsecase(repository: sl()));

  // Repository
  sl.registerLazySingleton<ServiceManagementRepository>(
    () => ServiceManagementRepositoryImpl(dataSource: sl()),
  );

  sl.registerLazySingleton<BannerRepository>(
    () => BannerRepositoryImpl(dataSource: sl()),
  );

  sl.registerLazySingleton<BarberRepository>(
    () => BarberRepositoryImpl(dataSource: sl()),
  );

  sl.registerLazySingleton<ImageUploader>(
    () => ImageUploaderMobile(sl()),
  );

  sl.registerLazySingleton<ImagePickerRepository>(
    () => ImagePickerRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton(() => ServiceRemoteDatasource());
  sl.registerLazySingleton(() => BannerRemoteDatasource(FirebaseFirestore.instance));
  sl.registerLazySingleton(() => BarberRemoteDatasource(FirebaseFirestore.instance));
  sl.registerLazySingleton(() => AuthLocalDatasource());

  // Services
  sl.registerLazySingleton(() => CloudinaryService());
  sl.registerLazySingleton(() => FirestoreImageService());
  sl.registerLazySingleton(() => FirestoreImageServiceDeletion());
  sl.registerLazySingleton(() => ImagePicker());

  // Feature - Splash
  sl.registerFactory(() => SplashBloc(authLocalDatasource: sl()));
}
