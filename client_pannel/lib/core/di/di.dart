import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../../features/app/data/datasource/service_remote_datasource.dart';
import '../../features/app/data/datasource/banner_remote_datasource.dart';
import '../../features/app/data/datasource/barber_remote_datasource.dart';
import '../../features/app/data/datasource/chat_remote_datasource.dart';
import '../../features/app/data/datasource/comment_remote_datasource.dart';
import '../../features/app/data/datasource/post_remote_datasource.dart';
import '../../features/app/data/datasource/rating_remote_datasource.dart';
import '../../features/app/data/datasource/user_remote_datasource.dart';
import '../../features/app/data/datasource/wishlist_remote_datasource.dart';
import '../../features/app/data/datasource/slot_remote_datasource.dart';
import '../../features/app/data/datasource/booking_remote_datasource.dart';
import '../../features/app/data/repo/service_repo_impl.dart';
import '../../features/app/data/repo/banner_repo_impl.dart';
import '../../features/app/data/repo/barber_repo_impl.dart';
import '../../features/app/data/repo/chat_repo_impl.dart';
import '../../features/app/data/repo/comment_repo_impl.dart';
import '../../features/app/data/repo/imagepicker_repo_impl.dart';
import '../../features/app/data/repo/post_repo_impl.dart';
import '../../features/app/data/repo/user_repo_impl.dart';
import '../../features/app/data/repo/wishlist_repo_impl.dart';
import '../../features/app/data/repo/slot_repo_impl.dart';
import '../../features/app/data/repo/booking_repo_impl.dart';
import '../../features/app/data/repo/calcel_booking_repository.dart';
import '../../features/app/domain/repo/service_repo.dart';
import '../../features/app/domain/repo/banner_repo.dart';
import '../../features/app/domain/repo/barber_repo.dart';
import '../../features/app/domain/repo/chat_repo.dart';
import '../../features/app/domain/repo/comment_repo.dart';
import '../../features/app/domain/repo/image_picker_repo.dart';
import '../../features/app/domain/repo/post_repo.dart';
import '../../features/app/domain/repo/user_repo.dart';
import '../../features/app/domain/repo/wishlist_repo.dart';
import '../../features/app/domain/repo/slot_repo.dart';
import '../../features/app/domain/repo/booking_repo.dart';
import '../../features/app/domain/usecase/get_admin_services_usecase.dart';
import '../../features/app/domain/usecase/get_all_barbers_usecase.dart';
import '../../features/app/domain/usecase/get_banner_usecase.dart';
import '../../features/app/domain/usecase/get_barber_usecase.dart';
import '../../features/app/domain/usecase/get_barber_services_usecase.dart';
import '../../features/app/domain/usecase/get_barber_individual_posts.dart';
import '../../features/app/domain/usecase/get_comments_usecase.dart';
import '../../features/app/domain/usecase/get_last_message_usecase.dart';
import '../../features/app/domain/usecase/get_message_badge_usecase.dart';
import '../../features/app/domain/usecase/get_posts_with_barbers_usecase.dart';
import '../../features/app/domain/usecase/get_request_for_chat_update_repo.dart';
import '../../features/app/domain/usecase/get_strem_chat_usecase.dart';
import '../../features/app/domain/usecase/pick_image_usecase.dart';
import '../../features/app/domain/usecase/send_chat_usecasde.dart';
import '../../features/app/domain/usecase/send_comment_usecase.dart';
import '../../features/app/domain/usecase/stream_chats_usecase.dart';
import '../../features/app/domain/usecase/update_user_usecase.dart';
import '../../features/app/domain/usecase/user_usecase.dart';
import '../../features/app/domain/usecase/wishlist_service_usecase.dart';
import '../../features/app/domain/usecase/get_slots_datas_usecase.dart';
import '../../features/app/domain/usecase/booking_usecase.dart';
import '../../features/app/presentations/state/bloc/fetch_bloc/fetch_abarber_bloc/fetch_abarber_bloc.dart';
import '../../features/app/presentations/state/bloc/fetch_bloc/fetch_admin_service_bloc/fetch_admin_service_bloc.dart';
import '../../features/app/presentations/state/bloc/fetch_bloc/fetch_barber_bloc/fetch_barber_bloc_bloc.dart';
import '../../features/app/presentations/state/bloc/fetch_bloc/fetch_barber_service_bloc/fetch_barber_service_bloc.dart';
import '../../features/app/presentations/state/bloc/fetch_bloc/fetch_barber_post_bloc/fetch_barber_post_bloc.dart';
import '../../features/app/presentations/state/bloc/fetch_bloc/fetch_chat_barberlabel_bloc/fetch_chat_barberlabel_bloc.dart';
import '../../features/app/presentations/state/bloc/fetch_bloc/fetch_chat_barber_leble_bloc/fetch_chat_barber_lebel_bloc.dart';
import '../../features/app/presentations/state/bloc/fetch_bloc/fetch_comments_bloc/fetch_comments_bloc.dart';
import '../../features/app/presentations/state/bloc/fetch_bloc/fetch_post_with_barber_bloc/fech_post_with_barber_bloc.dart';
import '../../features/app/presentations/state/bloc/fetch_bloc/fetch_wishlist_bloc/fetch_wishlist_bloc.dart';
import '../../features/app/presentations/state/bloc/fetch_bloc/fetch_slots_specific_date_bloc/fetch_slots_specific_date_bloc.dart';
import '../../features/app/presentations/state/bloc/fetch_bloc/fetch_slots_datas_bloc/fetch_slots_dates_bloc.dart';
import '../../features/app/presentations/state/bloc/fetch_bloc/fetch_booking_with_barber_bloc/fetch_booking_with_barber_bloc.dart';
import '../../features/app/presentations/state/bloc/fetch_bloc/fetch_specific_booking_bloc/fetch_specific_booking_bloc.dart';
import '../../features/app/presentations/state/bloc/image_picker_bloc/image_picker_bloc.dart';
import '../../features/app/presentations/state/bloc/fetch_bloc/fetch_banner_bloc/fetch_banner_bloc.dart';
import '../../features/app/presentations/state/bloc/fetch_bloc/fetch_user_bloc/fetch_user_bloc.dart';
import '../../features/app/presentations/state/bloc/launcher_service_bloc/launcher_service_bloc.dart';
import '../../features/app/presentations/state/bloc/logout_bloc/logout_bloc.dart';
import '../../features/app/presentations/state/bloc/delete_account_bloc/delete_account_bloc.dart';
import '../../features/app/presentations/state/bloc/cancel_booking_bloc/cancel_booking_bloc.dart';
import '../../features/app/presentations/state/bloc/send_comment_bloc/send_comment_bloc.dart';
import '../../features/app/presentations/state/bloc/send_message_bloc/send_message_bloc.dart';
import '../../features/app/presentations/widget/cod_payment_bloc/cod_payment_bloc.dart';
import '../../features/app/presentations/state/bloc/update_profile_bloc/update_profile_bloc.dart';
import '../../features/auth/data/datasource/auth_local_datasource.dart';
import '../../features/auth/data/datasource/auth_remote_datasource.dart';
import '../../features/auth/data/repo/auth_repo_impl.dart';
import '../../features/auth/domain/repo/auth_repo.dart';
import '../../features/auth/domain/usecase/auth_usecase.dart';
import '../../features/auth/presentations/state/bloc/auth_bloc/auth_bloc.dart';
import '../../features/auth/presentations/state/bloc/splash_bloc/splash_bloc.dart';
import '../../features/auth/presentations/state/cubit/progresser_cubit/progresser_cubit.dart';
import '../../features/app/presentations/state/cubit/fetch_single_wishlist_cubit/fetch_single_wishlist_cubit.dart';
import '../../features/app/presentations/state/cubit/last_message_cubit/last_message_cubit.dart';
import '../../features/app/presentations/state/cubit/message_badget_cubit.dart/message_badge_cubit.dart';
import '../../features/app/presentations/state/cubit/share_cubit/share_cubit.dart';
import '../../features/app/presentations/state/cubit/status_chat_request_cubit/status_chat_request_cubit.dart';
import '../../features/app/presentations/state/cubit/voice_cubit/voice_cubit.dart';
import '../../features/app/presentations/state/cubit/wish_list_function_cubit/wish_list_fuction_cubit.dart';
import '../../service/cloudinary/cloudinary_service.dart';
import '../../service/share/share_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ! Bloc & Cubit
  /// Bloc reference
  sl.registerFactory(() => SplashBloc(localDB: sl()));
  sl.registerFactory(() => AuthBloc(authUsecase: sl()));
  sl.registerFactory(() => FetchUserBloc(userUsecase: sl(), localDB: sl()));
  sl.registerFactory(() => FetchBannersBloc(useCase: sl()));
  sl.registerFactory(() => FechPostWithBarberBloc(
    getPostsWithBarbersUseCase: sl(), 
    localDB: sl(),
  ));
  sl.registerFactory(() => FetchCommentsBloc(
    getCommentsUseCase: sl(),
    localDB: sl(),
  ));
  sl.registerFactory(() => SendCommentBloc(
    sendCommentUseCase: sl(),
    localDB: sl(),
  ));
  sl.registerFactory(() => SendMessageBloc(
    sendChatUsecase: sl(),
    cloudinaryService: sl(),
  ));
  sl.registerFactory(() => FetchAllbarberBloc(getAllBarbersUseCase: sl()));
  sl.registerFactory(() => FetchAbarberBloc(usecase: sl()));
  sl.registerFactory(() => FetchBarberServiceBloc(getBarberServicesUseCase: sl()));
  sl.registerFactory(() => FetchBarberPostBloc(getBarberIndividualPostsUseCase: sl()));
  sl.registerFactory(() => FetchWishlistBloc(wishlistServiceUsecase: sl(), localDB: sl()));
  sl.registerFactory(() => FetchSlotsSpecificDateBloc(getSlotsDatasUsecase: sl()));
  sl.registerFactory(() => FetchSlotsDatesBloc(getSlotsDatasUsecase: sl()));
  sl.registerFactory(() => FetchChatBarberlabelBloc(
    localDB: sl(),
    streamChatsUseCase: sl(),
  ));
  sl.registerFactory(() => FetchChatBarberlebelBloc(
    localDB: sl(),
    usecase: sl(),
  ));
  sl.registerFactory(() => FetchAdminServiceBloc(getAdminServicesUseCase: sl()));
  sl.registerFactory(() => ImagePickerBloc(usecase: sl()));
  sl.registerFactory(() => UpdateProfileBloc(cloud: sl(), usecase: sl(), 
  localDB: sl()));
  sl.registerFactory(() => LogoutBloc(localDB: sl(), auth: sl(), googleSignIn: sl()));
  sl.registerFactory(() => LauncherServiceBloc());
  sl.registerFactory(() => DeleteAccountBloc(
    localDB: sl(), 
    auth: sl(), 
    googleSignIn: sl(), 
  ));
  sl.registerFactory(() => CodPaymentBloc(
    getSlotsDatasUsecase: sl(),
    localDB: sl(),
    bookingUsecase: sl(),
  ));
  sl.registerFactory(() => FetchBookingWithBarberBloc(
    localDB: sl(),
    bookingusecase: sl(),
  ));
  sl.registerFactory(() => FetchSpecificBookingBloc(
    bookingUsecase: sl(),
  ));
  sl.registerFactory(() => CancelBookingBloc(
    cancelBookingRepository: sl(),
    getSlotsDatasUsecase: sl(),
  ));
  
  /// Cubit reference
  sl.registerFactory(() => ShareCubit(shareService: sl()));
  sl.registerFactory(() => VoiceSearchCubit());
  sl.registerFactory(() => StatusChatRequstDartCubit(usecase: sl()));
  sl.registerFactory(() => ProgresserCubit());
  sl.registerFactory(() => MessageBadgeCubit(localDB: sl(), usecase: sl()));
  sl.registerFactory(() => LastMessageCubit(usecase: sl(), localDB: sl()));
  sl.registerFactory(() => WishListFuctionCubit(wishlistServiceUsecase: sl(), localDB: sl()));
  sl.registerFactory(() => FetchSingleWishlistCubit(wishlistServiceUsecase: sl(), localDB: sl()));

  //! Usecase
  //==================Usecase reference==================
  sl.registerLazySingleton(() => AuthUsecase(authRepo: sl()));
  sl.registerLazySingleton(() => UserUsecase(userRepo: sl()));
  sl.registerLazySingleton(() => UpdateUserUseCase(userRepo: sl()));
  sl.registerLazySingleton(() => GetBannerUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetAllBarbersUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetBarberUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetBarberServicesUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetBarberIndividualPostsUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetPostsWithBarbersUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetCommentsUseCase(repository: sl()));
  sl.registerLazySingleton(() => SendCommentUseCase(repository: sl()));
  sl.registerLazySingleton(() => SendChatUsecase(chatRepository: sl()));
  sl.registerLazySingleton(() => StreamChatsUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetStremChatUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetMessageBadgeUsecase(chatRepository: sl()));
  sl.registerLazySingleton(() => GetLastMessageUsecase(chatRepository: sl()));
  sl.registerLazySingleton(() => GetRequestForChatUpdateUseCase(sl()));
  sl.registerLazySingleton(() => GetAdminServicesUseCase(repository: sl()));
  sl.registerLazySingleton(() => PickImageUseCase(sl()));
  sl.registerLazySingleton(() => WishlistServiceUsecase(wishlistRepo: sl()));
  sl.registerLazySingleton(() => GetSlotsDatasUsecase(repository: sl()));
  sl.registerLazySingleton(() => BookingUsecase(bookingRepo: sl()));

  //! Repository
  //==================Repository reference==================
  sl.registerLazySingleton<AuthRepo>(
    () => AuthRepositoryImpl(authRemoteDatasource: sl()),
  );
  sl.registerLazySingleton<UserRepo>(
    () => UserRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<BannerRepository>(
    () => BannerRepositoryImpl(remoteDatasource: sl()),
  );
  sl.registerLazySingleton<BarberRepository>(
    () => BarberRepositoryImpl(remoteDatasource: sl()),
  );
  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(remoteDatasource: sl()),
  );
  sl.registerLazySingleton<SendCommentRepository>(
    () => SendCommentRepositoryImpl(remoteDatasource: sl()),
  );
  sl.registerLazySingleton<ImagePickerRepository>(
    () => ImagePickerRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(remoteDatasource: sl()),
  );
  sl.registerLazySingleton<ServiceRepository>(
    () => ServiceRepositoryImpl(remoteDatasource: sl()),
  );
  sl.registerLazySingleton<WishlistRepo>(
    () => WishlistRepoImpl(wishlistRemoteDatasource: sl()),
  );
  sl.registerLazySingleton<SlotRepository>(
    () => SlotRepositoryImpl(remoteDatasource: sl()),
  );
  sl.registerLazySingleton<BookingRepo>(
    () => BookingRepositoryImpl(bookingRemoteDatasource: sl()),
  );
  sl.registerLazySingleton<CancelBookingRepository>(
    () => CancelBookingRepositoryImpl(),
  );

  //! Datasource
  //==================Datasource reference==================
  sl.registerLazySingleton(
    () => AuthRemoteDatasource(
      auth: sl(),
      googleSignIn: sl(),
      localDB: sl(),
      firestore: sl(),
    ),
  );
  sl.registerLazySingleton(() => AuthLocalDatasource());
  sl.registerLazySingleton(() => UserRemoteDataSource(firestore: sl()));
  sl.registerLazySingleton(() => BannerRemoteDatasource(firestore: sl()));
  sl.registerLazySingleton(() => RatingRemoteDataSource(firestore: sl()));
  sl.registerLazySingleton(() => BarberRemoteDatasource(
    firestore: sl(), 
    ratingService: sl(),
  ));
  sl.registerLazySingleton(() => PostRemoteDatasource(
    barber: sl(), 
    firestore: sl(),
  ));
  sl.registerLazySingleton(() => SendCommentRemoteDataSource(firestore: sl()));
  sl.registerLazySingleton(() => ChatRemoteDatasource(
    firestore: sl(),
    barberRemoteDatasource: sl(),
  ));
  sl.registerLazySingleton(() => ServiceRemoteDatasource(firestore: sl()));
  sl.registerLazySingleton(() => WishlistRemoteDatasource(firestore: sl(), barberRemoteDatasource: sl()));
  sl.registerLazySingleton(() => SlotRemoteDatasource(firestore: sl()));
  sl.registerLazySingleton(() => BookingRemoteDatasource(
    firestore: sl(),
    barberService: sl(),
  ));

  //! Services
  //==================Services reference==================
  sl.registerLazySingleton(() => CloudinaryService());
  sl.registerLazySingleton<ShareService>(() => ShareServiceImpl());
  sl.registerLazySingleton(() => BarberService(sl()));

  //? External Dependencies
  //==================External Dependencies reference==================
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => GoogleSignIn());
  sl.registerLazySingleton(() => ImagePicker());
}
