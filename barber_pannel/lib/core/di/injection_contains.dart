import 'package:barber_pannel/features/app/data/datasource/banner_remote_datasource.dart';
import 'package:barber_pannel/features/app/data/datasource/barber_remote_datasource.dart';
import 'package:barber_pannel/features/app/data/datasource/barber_service_datasource.dart';
import 'package:barber_pannel/features/app/data/datasource/chat_remote_datasource.dart';
import 'package:barber_pannel/features/app/data/datasource/comments_remote_datasource.dart';
import 'package:barber_pannel/features/app/data/datasource/post_remote_datasource.dart';
import 'package:barber_pannel/features/app/data/datasource/service_remote_datasource.dart';
import 'package:barber_pannel/features/app/data/datasource/user_remote_datasource.dart';
import 'package:barber_pannel/features/app/data/repo/banner_repository_impl.dart';
import 'package:barber_pannel/features/app/data/repo/barber_repository_impl.dart';
import 'package:barber_pannel/features/app/data/repo/barber_service_repository_impl.dart';
import 'package:barber_pannel/features/app/data/repo/chat_repo_impl.dart';
import 'package:barber_pannel/features/app/data/repo/comments_repository_impl.dart';
import 'package:barber_pannel/features/app/data/repo/image_picker_repo_impl.dart';
import 'package:barber_pannel/features/app/data/repo/post_repository_impl.dart';
import 'package:barber_pannel/features/app/data/repo/service_repository_impl.dart';
import 'package:barber_pannel/features/app/data/repo/barber_repo_impl.dart';
import 'package:barber_pannel/features/app/domain/repo/banner_repository.dart';
import 'package:barber_pannel/features/app/domain/repo/barber_repository.dart';
import 'package:barber_pannel/features/app/domain/repo/barber_service_repository.dart';
import 'package:barber_pannel/features/app/domain/repo/chat_repository.dart';
import 'package:barber_pannel/features/app/domain/repo/commets_repository.dart';
import 'package:barber_pannel/features/app/domain/repo/image_picker_repo.dart';
import 'package:barber_pannel/features/app/domain/repo/post_repository.dart';
import 'package:barber_pannel/features/app/domain/repo/service_repository.dart';
import 'package:barber_pannel/features/app/domain/repo/user_repo.dart';
import 'package:barber_pannel/features/app/domain/usecase/chat_labels_usecase.dart';
import 'package:barber_pannel/features/app/domain/usecase/delete_post_usecase.dart';
import 'package:barber_pannel/features/app/domain/usecase/get_banner_usecase.dart';
import 'package:barber_pannel/features/app/domain/usecase/get_barber_usecase.dart';
import 'package:barber_pannel/features/app/domain/usecase/get_barber_services_usecase.dart';
import 'package:barber_pannel/features/app/domain/usecase/get_chat_users_usecase.dart';
import 'package:barber_pannel/features/app/domain/usecase/get_comments_usecase.dart';
import 'package:barber_pannel/features/app/domain/usecase/get_posts_usecase.dart';
import 'package:barber_pannel/features/app/domain/usecase/get_post_with_barber_usecase.dart';
import 'package:barber_pannel/features/app/domain/usecase/get_services_usecase.dart';
import 'package:barber_pannel/features/app/domain/usecase/send_message_usecase.dart';
import 'package:barber_pannel/features/app/domain/usecase/update_barber_usecase.dart';
import 'package:barber_pannel/features/app/domain/usecase/update_barber_newdata_usecase.dart';
import 'package:barber_pannel/features/app/domain/usecase/updated_barber_service_usecase.dart';
import 'package:barber_pannel/features/app/domain/usecase/upload_barber_service_usecase.dart';
import 'package:barber_pannel/features/app/domain/usecase/upload_post_usecase.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/barber_service_bloc/barber_service_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/barber_service_modification_bloc/barber_service_modification_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_barber_service_bloc/fetch_barber_service_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_banner_bloc/fetch_banner_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_barber_bloc/fetch_barber_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_chat_user_lebel_bloc/fetch_chat_user_lebel_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_comment_bloc/fetch_comment_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_post_bloc/fetch_posts_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_post_with_barber_bloc/fetch_post_with_barber_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_service_bloc/fetch_service_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/fetch_bloc/fetch_user_bloc/fetch_user_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/image_picker_bloc/image_picker_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/lauch_service_bloc/lauch_service_bloc.dart' show LauchServiceBloc;
import 'package:barber_pannel/features/app/presentation/state/bloc/logout_bloc/logout_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/send_message_bloc/send_message_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/update_profile_bloc/update_profile_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/upload_post_bloc/upload_post_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/bloc/upload_service_data_bloc.dart/upload_service_data_bloc.dart';
import 'package:barber_pannel/features/app/presentation/state/cubit/last_message_cubit/last_message_cubit.dart';
import 'package:barber_pannel/features/app/presentation/state/cubit/like_comments_cubit/like_comments_cubit.dart';
import 'package:barber_pannel/features/app/presentation/state/cubit/like_post_cubit/like_post_cubit.dart';
import 'package:barber_pannel/features/app/presentation/state/cubit/message_badge_cubit/message_badge_cubit.dart';
import 'package:barber_pannel/features/app/presentation/state/cubit/request_chat_statuc_cubit/request_chat_status_cubit.dart';
import 'package:barber_pannel/features/app/presentation/state/cubit/nav_cubit/nav_cubit.dart';
import 'package:barber_pannel/features/app/presentation/state/cubit/setting_tab_cubit/setting_tab_cubit.dart';
import 'package:barber_pannel/features/app/presentation/state/cubit/post_like_animation_cubit/post_like_animation_cubit.dart';
import 'package:barber_pannel/features/app/presentation/state/cubit/share_cubit/share_cubit.dart';
import 'package:barber_pannel/service/share/share_service.dart';
import 'package:barber_pannel/features/auth/presentation/state/cubit/delete_post_cubit/delete_post_cubit.dart';
import 'package:barber_pannel/features/auth/presentation/state/cubit/progresser_cubit/progresser_cubit.dart';
import 'package:barber_pannel/core/common/custom_chat_textfiled.dart';
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
      firestore: sl(), 
      barberRemoteDatasource: sl(), 
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

  // User remote data source
  sl.registerLazySingleton<UserRemoteDatasource>(
    () => UserRemoteDatasource(
      firestore: sl(),  // Inject FirebaseFirestore
    ),
  );

  // Chat remote data source
  sl.registerLazySingleton<ChatRemoteDatasource>(
    () => ChatRemoteDatasource(
      firestore: sl(),  // Inject FirebaseFirestore
      userRemoteDatasource: sl(),  // Inject UserRemoteDatasource
    ),
  );

  // Comments remote data source
  sl.registerLazySingleton<CommentsRemoteDatasource>(
    () => CommentsRemoteDatasource(
      firestore: sl(),  // Inject FirebaseFirestore
    ),
  );

  // Cloudinary service
  sl.registerLazySingleton<CloudinaryService>(
    () => CloudinaryService(),
  );

  // Share service
  sl.registerLazySingleton<ShareService>(
    () => ShareServiceImpl(),
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

  // Chat repository
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      chatRemoteDatasource: sl(),
    ),  
  );

  // User repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepoImpl(
      remoteDatasource: sl(),
    ),
  );

  // Comments repository
  sl.registerLazySingleton<CommentsRepository>(
    () => CommentsRepositoryImpl(
      commentsRemoteDatasource: sl(),
    ),
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

  // Delete post use case
  sl.registerLazySingleton<DeletePostUsecase>(
    () => DeletePostUsecase(postRepository: sl()),
  );

  // Get post with barber use case
  sl.registerLazySingleton<GetPostWithBarberUsecase>(
    () => GetPostWithBarberUsecase(postRepository: sl()),
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

  // Get chat users use case
  sl.registerLazySingleton<GetChatUsersUsecase>(
    () => GetChatUsersUsecase(repository: sl()),
  );

  // Chat labels use case
  sl.registerLazySingleton<ChatLabelsUsecase>(
    () => ChatLabelsUsecase(chatRepository: sl()),
  );

  // Get comments use case
  sl.registerLazySingleton<GetCommentsUsecase>(
    () => GetCommentsUsecase(commentsRepository: sl()),
  );

  // Send message use case
  sl.registerLazySingleton<SendMessageUsecase>(
    () => SendMessageUsecase(chatRepository: sl()),
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

  // Fetch post with barber bloc
  sl.registerFactory<FetchPostWithBarberBloc>(
    () => FetchPostWithBarberBloc(
      usecase: sl(),
      localDB: sl(),
    ),
  );

  // Fetch comment bloc
  sl.registerFactory<FetchCommentBloc>(
    () => FetchCommentBloc(
      getCommentsUsecase: sl(),
      localDB: sl(),
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

  // Fetch chat user label bloc
  sl.registerFactory<FetchChatUserlebelBloc>(
    () => FetchChatUserlebelBloc(
      localDB: sl(),
      usecase: sl(),
    ),
  );

  // Message badge cubit
  sl.registerFactory<MessageBadgeCubit>(
    () => MessageBadgeCubit(
      usecase: sl(),
      authLocalDatasource: sl(),
    ),
  );

  // Last message cubit
  sl.registerFactory<LastMessageCubit>(
    () => LastMessageCubit(
      usecase: sl(),
      localDB: sl(),
    ),
  );

  // Fetch user bloc
  sl.registerFactory<FetchUserBloc>(
    () => FetchUserBloc(
      userRepository: sl(),
      localDB: sl(),
    ),
  );

  // Status chat request cubit
  sl.registerFactory<StatusChatRequstDartCubit>(
    () => StatusChatRequstDartCubit(sl()),
  );

  // Send message bloc
  sl.registerFactory<SendMessageBloc>(
    () => SendMessageBloc(
      usecase: sl(),
      cloudinaryService: sl(),
    ),
  );

  // Progresser cubit
  sl.registerFactory<ProgresserCubit>(
    () => ProgresserCubit(),
  );

  // Delete post cubit
  sl.registerFactory<DeletePostCubit>(
    () => DeletePostCubit(deletePostUsecase: sl()),
  );

  // Like post cubit
  sl.registerFactory<LikePostCubit>(
    () => LikePostCubit(firestore: sl()),
  );

  // Like comment cubit
  sl.registerFactory<LikeCommentCubit>(
    () => LikeCommentCubit(firestore: sl()),
  );

  // Emoji picker cubit
  sl.registerFactory<EmojiPickerCubit>(
    () => EmojiPickerCubit(),
  );

  // Navigation cubit
  sl.registerFactory<ButtomNavCubit>(
    () => ButtomNavCubit(),
  );

  // Profile tab cubit
  sl.registerFactory<ProfiletabCubit>(
    () => ProfiletabCubit(),
  );

  // Post like animation cubit
  sl.registerFactory<PostLikeAnimationCubit>(
    () => PostLikeAnimationCubit(),
  );

  // Share cubit
  sl.registerFactory<ShareCubit>(
    () => ShareCubit(shareService: sl()),
  );

  // Lauch service bloc
  sl.registerFactory<LauchServiceBloc>(
    () => LauchServiceBloc(),
  );
}