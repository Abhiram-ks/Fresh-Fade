import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

//? Service Locator instance
final sl = GetIt.instance;


/// Initialize all dependencies
Future<void> init() async {

  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

}