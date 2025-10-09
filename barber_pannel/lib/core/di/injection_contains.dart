import 'package:barber_pannel/features/auth/data/repo/auth_register_repo_impl.dart';
import 'package:barber_pannel/features/auth/domain/repo/auth_register_repo.dart';
import 'package:barber_pannel/features/auth/domain/usecase/auth_register_usecase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

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

  // ==================== Internal Dependencies ====================
  // !==================== Data Sources ====================
  // Remote data source (Singleton - created once and reused)
  sl.registerLazySingleton<AuthRegisterRemotedatasouce>(
    () => AuthRegisterRemotedatasouce(
      firestore: sl(),  // Inject FirebaseFirestore
      auth: sl(),       // Inject FirebaseAuth
    ),
  );
  // !==================== Repositories ====================
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: sl()));

  // !==================== Use Cases ====================
  sl.registerLazySingleton<RegisterBarberUseCase>(() => RegisterBarberUseCase(repository: sl()));
 // ==================== Blocs ====================
  // Blocs (Factory - creates new instance every time)
  sl.registerLazySingleton<RegisterBloc>(
    () => RegisterBloc(
      usecase: sl()));
}