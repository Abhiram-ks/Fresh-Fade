import 'package:barber_pannel/features/app/data/datasource/banner_remote_datasource.dart';
import 'package:barber_pannel/features/app/data/datasource/barber_remote_datasource.dart';
import 'package:barber_pannel/features/app/data/datasource/barber_service_datasource.dart';
import 'package:barber_pannel/features/app/data/datasource/post_remote_datasource.dart';
import 'package:barber_pannel/features/app/data/datasource/service_remote_datasource.dart';
import 'package:barber_pannel/features/app/data/repo/banner_repository_impl.dart';
import 'package:barber_pannel/features/app/data/repo/barber_repository_impl.dart';
import 'package:barber_pannel/features/app/data/repo/barber_service_repository_impl.dart';
import 'package:barber_pannel/features/app/data/repo/image_picker_repo_impl.dart';
import 'package:barber_pannel/features/app/data/repo/post_repository_impl.dart';
import 'package:barber_pannel/features/app/data/repo/service_repository_impl.dart';
import 'package:barber_pannel/features/app/domain/repo/banner_repository.dart';
import 'package:barber_pannel/features/app/domain/repo/barber_repository.dart';
import 'package:barber_pannel/features/app/domain/repo/barber_service_repository.dart';
import 'package:barber_pannel/features/app/domain/repo/image_picker_repo.dart';
import 'package:barber_pannel/features/app/domain/repo/post_repository.dart';
import 'package:barber_pannel/features/app/domain/repo/service_repository.dart';
import 'package:barber_pannel/features/app/domain/usecase/get_banner_usecase.dart';
import 'package:barber_pannel/features/app/domain/usecase/get_barber_usecase.dart';
import 'package:barber_pannel/features/app/domain/usecase/get_barber_services_usecase.dart';
import 'package:barber_pannel/features/app/domain/usecase/get_posts_usecase.dart';
import 'package:barber_pannel/features/app/domain/usecase/get_services_usecase.dart';
import 'package:barber_pannel/features/app/domain/usecase/update_barber_usecase.dart';
import 'package:barber_pannel/features/app/domain/usecase/update_barber_newdata_usecase.dart';
import 'package:barber_pannel/features/app/domain/usecase/updated_barber_service_usecase.dart';
import 'package:barber_pannel/features/app/domain/usecase/upload_barber_service_usecase.dart';
import 'package:barber_pannel/features/app/domain/usecase/upload_post_usecase.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/barber_/barber_service_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/barber_service_modification_bloc/barber_service_modification_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_barber_service_bloc/fetch_barber_service_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_banner_bloc/fetch_banner_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_barber_bloc/fetch_barber_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_post_bloc/fetch_posts_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_service_bloc/fetch_service_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/image_picker_bloc/image_picker_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/logout_bloc/logout_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/update_profile_bloc/update_profile_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/upload_post_bloc/upload_post_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/upload_service_data_bloc.dart/upload_service_data_bloc.dart';
import 'package:barber_pannel/service/cloudinary/cloudinary_service.dart';
import 'package:barber_pannel/features/auth/data/datasource/auth_local_datasouce.dart';
import 'package:barber_pannel/features/auth/data/datasource/auth_login_remotedatasoucre.dart';
import 'package:barber_pannel/features/auth/data/datasource/password_local_datasouce.dart';
import 'package:barber_pannel/features/auth/data/repo/auth_login_repo_impl.dart';
import 'package:barber_pannel/features/auth/data/repo/auth_register_repo_impl.dart';
import 'package:barber_pannel/features/auth/data/repo/password_repo_impl.dart';
import 'package:barber_pannel/features/auth/domain/repo/auth_login_repo.dart';
import 'package:barber_pannel/features/auth/domain/repo/auth_register_repo.dart';
import 'package:barber_pannel/features/auth/domain/repo/password_repo.dart';
import 'package:barber_pannel/features/auth/domain/usecase/auth_login_usecase.dart';
import 'package:barber_pannel/features/auth/domain/usecase/auth_register_usecase.dart';
import 'package:barber_pannel/features/auth/domain/usecase/password_usecase.dart';
import 'package:barber_pannel/features/auth/presentation/state/bloc/login_bloc/login_bloc.dart';
import 'package:barber_pannel/features/auth/presentation/state/bloc/password_bloc.dart/password_bloc.dart';
import 'package:barber_pannel/features/auth/presentation/state/bloc/splash_bloc/splash_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import '../../features/app/domain/usecase/picker_image_usecase.dart';
import '../../features/auth/data/datasource/auth_register_remotedatasouce.dart';
import '../../features/auth/presentation/state/bloc/register_bloc/register_bloc.dart';

//? Service Locator instance
final sl = GetIt.instance;


/// Initialize all dependencies
Future<void> init() async {
   // ==================== External Dependencies ====================
  // Firebase instances (Singleton - created once and reused)
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<ImagePicker>(() => ImagePicker());

  // ==================== Internal Dependencies ====================
  // !==================== Data Sources ====================
  // Local data source (Singleton - created once and reused)
  sl.registerLazySingleton<AuthLocalDatasource>(
    () => AuthLocalDatasource(),
  );

  // Remote data sources (Singleton - created once and reused)
  sl.registerLazySingleton<AuthRegisterRemotedatasouce>(
    () => AuthRegisterRemotedatasouce(
      firestore: sl(),  // Inject FirebaseFirestore
      auth: sl(),       // Inject FirebaseAuth
    ),
  );

  sl.registerLazySingleton<AuthLoginRemotedatasource>(
    () => AuthLoginRemotedatasource(
      firestore: sl(),              // Inject FirebaseFirestore
      auth: sl(),                   // Inject FirebaseAuth
      authLocalDatasource: sl(),    // Inject AuthLocalDatasource
    ),
  );

  // Password remote data source
  sl.registerLazySingleton<PasswordRemoteDatasource>(
    () => PasswordRemoteDatasource(
      auth: sl(),                   // Inject FirebaseAuth
      firestore: sl(),              // Inject FirebaseFirestore
    ),
  );

  // Banner remote data source
  sl.registerLazySingleton<BannerRemoteDatasource>(
    () => BannerRemoteDatasource(
      firestore: sl(),  // Inject FirebaseFirestore
    ),
  );

  //? Barber remote data source
  sl.registerLazySingleton<BarberRemoteDatasource>(
    () => BarberRemoteDatasource(
      firestore: sl(),  // Inject FirebaseFirestore
    ),
  );

  // Post remote data source
  sl.registerLazySingleton<PostRemoteDatasource>(
    () => PostRemoteDatasource(
      firestore: sl(),  // Inject FirebaseFirestore
    ),
  );

  // Service remote data source
  sl.registerLazySingleton<ServiceRemoteDatasource>(
    () => ServiceRemoteDatasource(
      firestore: sl(),  // Inject FirebaseFirestore
    ),
  );

  // Barber service datasource
  sl.registerLazySingleton<BarberServiceDatasource>(
    () => BarberServiceDatasource(
      firestore: sl(),  // Inject FirebaseFirestore
    ),
  );

  // Cloudinary service
  sl.registerLazySingleton<CloudinaryService>(
    () => CloudinaryService(),
  );

 

  // !==================== Repositories ====================
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<AuthLoginRepository>(
    () => AuthLoginRepositoryImpl(remoteDataSource: sl()),
  );

  // Password repository
  sl.registerLazySingleton<PasswordRepository>(
    () => PasswordRepositoryImpl(remoteDatasource: sl()),
  );

  // Banner repository
  sl.registerLazySingleton<BannerRepository>(
    () => BannerRepositoryImpl(remoteDatasource: sl()),
  );

  // Barber repository
  sl.registerLazySingleton<BarberRepository>(
    () => BarberRepositoryImpl(remoteDatasource: sl()),
  );
  

  // Image picker repository
  sl.registerLazySingleton<ImagePickerRepository>(
    () => ImagePickerRepositoryImpl(sl()),
  );

  // Post repository
  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(remoteDatasource: sl()),
  );

  // Service repository
  sl.registerLazySingleton<ServiceRepository>(
    () => ServiceRepositoryImpl(remoteDatasource: sl()),
  );

  // Barber service repository
  sl.registerLazySingleton<BarberServiceRepository>(
    () => BarberServiceRepositoryImpl(datasource: sl()),
  );

  // !==================== Use Cases ====================
  sl.registerLazySingleton<RegisterBarberUseCase>(
    () => RegisterBarberUseCase(repository: sl()),
  );

  sl.registerLazySingleton<LoginBarberUseCase>(
    () => LoginBarberUseCase(repository: sl()),
  );

  // Password usecase
  sl.registerLazySingleton<PasswordUsecase>(
    () => PasswordUsecase(passwordRepository: sl()),
  );

  // Banner use case
  sl.registerLazySingleton<GetBannerUseCase>(
    () => GetBannerUseCase(repository: sl()),
  );

  // Barber use case
  sl.registerLazySingleton<GetBarberUseCase>(
    () => GetBarberUseCase(repository: sl()),
  );

  // Image picker use case
  sl.registerLazySingleton<PickImageUseCase>(
    () => PickImageUseCase(sl()),
  );

  // Upload post use case
  sl.registerLazySingleton<UploadPostUseCase>(
    () => UploadPostUseCase(repository: sl()),
  );

  // Get posts use case
  sl.registerLazySingleton<GetPostsUseCase>(
    () => GetPostsUseCase(repository: sl()),
  );

  // Update barber use case
  sl.registerLazySingleton<UpdateBarberUseCase>(
    () => UpdateBarberUseCase(repository: sl()),
  );

  // Get services use case
  sl.registerLazySingleton<GetServicesUseCase>(
    () => GetServicesUseCase(repository: sl()),
  );

  // Upload barber service use case
  sl.registerLazySingleton<UploadBarberServiceUseCase>(
    () => UploadBarberServiceUseCase(repository: sl()),
  );

  // Get barber services use case
  sl.registerLazySingleton<GetBarberServicesUseCase>(
    () => GetBarberServicesUseCase(repository: sl()),
  );

  sl.registerLazySingleton<ModificationBarberUsecase>(
    () => ModificationBarberUsecase(repository: sl()),
  );

  // Update barber newdata use case
  sl.registerLazySingleton<UpdateBarberNewdataUsecase>(
    () => UpdateBarberNewdataUsecase(repo: sl()),
  );

  // !==================== Blocs ====================
  // Blocs (Factory - creates new instance every time)
  sl.registerFactory<RegisterBloc>(
    () => RegisterBloc(usecase: sl()),
  );

  sl.registerFactory<LoginBloc>(
    () => LoginBloc(usecase: sl()),
  );

  // Password bloc
  sl.registerFactory<PasswordBloc>(
    () => PasswordBloc(passwordUsecase: sl()),
  );

  // Banner bloc
  sl.registerFactory<FetchBannersBloc>(
    () => FetchBannersBloc(useCase: sl()),
  );

  // Barber bloc
  sl.registerFactory<FetchBarberBloc>(
    () => FetchBarberBloc(
      localDB: sl(),
      useCase: sl(),
    ),
  );


  // Bloc Logout
  sl.registerFactory<LogoutBloc>(
    () => LogoutBloc(
      localDB: sl(),
      auth: sl())
  );

  // Splash bloc
  sl.registerFactory<SplashBloc>(
    () => SplashBloc(
      auth: sl(),
      localDB: sl(),
      useCase: sl(),
    ),
  );

  // Image picker bloc
  sl.registerFactory<ImagePickerBloc>(
    () => ImagePickerBloc(useCase: sl()),
  );

  // Upload post bloc
  sl.registerFactory<UploadPostBloc>(
    () => UploadPostBloc(
      localDB: sl(),
      cloudService: sl(),
      uploadPostUseCase: sl(),
    ),
  );

  // Fetch posts bloc
  sl.registerFactory<FetchPostsBloc>(
    () => FetchPostsBloc(
      localDB: sl(),
      useCase: sl(),
    ),
  );

  // Update profile bloc
  sl.registerFactory<UpdateProfileBloc>(
    () => UpdateProfileBloc(
      cloudinaryService: sl(),
      localDB: sl(),
      updateBarberUseCase: sl(),
    ),
  );

  // Fetch service bloc
  sl.registerFactory<FetchServiceBloc>(
    () => FetchServiceBloc(useCase: sl()),
  );

  // Barber service bloc
  sl.registerFactory<BarberServiceBloc>(
    () => BarberServiceBloc(
      usecase: sl(),
      localDB: sl(),
    ),
  );

  // Fetch barber service bloc
  sl.registerFactory<FetchBarberServiceBloc>(
    () => FetchBarberServiceBloc(
      useCase: sl(),
      localDB: sl(),
    ),
  );

  // Barber service modification bloc
  sl.registerFactory<BarberServiceModificationBloc>(
    () => BarberServiceModificationBloc(usecase: sl()),
  );

  // Upload service data bloc
  sl.registerFactory<UploadServiceDataBloc>(
    () => UploadServiceDataBloc(
      cloudinary: sl(),
      localDB: sl(),
      usecase: sl(),
    ),
  );
}