import 'package:barber_pannel/features/app/data/datasource/banner_remote_datasource.dart';
import 'package:barber_pannel/features/app/data/datasource/barber_remote_datasource.dart';
import 'package:barber_pannel/features/app/data/datasource/post_remote_datasource.dart';
import 'package:barber_pannel/features/app/data/repo/banner_repository_impl.dart';
import 'package:barber_pannel/features/app/data/repo/barber_repository_impl.dart';
import 'package:barber_pannel/features/app/data/repo/image_picker_repo_impl.dart';
import 'package:barber_pannel/features/app/data/repo/post_repository_impl.dart';
import 'package:barber_pannel/features/app/domain/repo/banner_repository.dart';
import 'package:barber_pannel/features/app/domain/repo/barber_repository.dart';
import 'package:barber_pannel/features/app/domain/repo/image_picker_repo.dart';
import 'package:barber_pannel/features/app/domain/repo/post_repository.dart';
import 'package:barber_pannel/features/app/domain/usecase/get_banner_usecase.dart';
import 'package:barber_pannel/features/app/domain/usecase/get_barber_usecase.dart';
import 'package:barber_pannel/features/app/domain/usecase/upload_post_usecase.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_banner_bloc/fetch_banner_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_barber_bloc/fetch_barber_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/image_picker_bloc/image_picker_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/logout_bloc/logout_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/upload_post_bloc/upload_post_bloc.dart';
import 'package:barber_pannel/service/cloudinary/cloudinary_service.dart';
import 'package:barber_pannel/features/auth/data/datasource/auth_local_datasouce.dart';
import 'package:barber_pannel/features/auth/data/datasource/auth_login_remotedatasoucre.dart';
import 'package:barber_pannel/features/auth/data/repo/auth_login_repo_impl.dart';
import 'package:barber_pannel/features/auth/data/repo/auth_register_repo_impl.dart';
import 'package:barber_pannel/features/auth/domain/repo/auth_login_repo.dart';
import 'package:barber_pannel/features/auth/domain/repo/auth_register_repo.dart';
import 'package:barber_pannel/features/auth/domain/usecase/auth_login_usecase.dart';
import 'package:barber_pannel/features/auth/domain/usecase/auth_register_usecase.dart';
import 'package:barber_pannel/features/auth/presentation/state/bloc/login_bloc/login_bloc.dart';
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

  // !==================== Use Cases ====================
  sl.registerLazySingleton<RegisterBarberUseCase>(
    () => RegisterBarberUseCase(repository: sl()),
  );

  sl.registerLazySingleton<LoginBarberUseCase>(
    () => LoginBarberUseCase(repository: sl()),
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

  // !==================== Blocs ====================
  // Blocs (Factory - creates new instance every time)
  sl.registerFactory<RegisterBloc>(
    () => RegisterBloc(usecase: sl()),
  );

  sl.registerFactory<LoginBloc>(
    () => LoginBloc(usecase: sl()),
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
}