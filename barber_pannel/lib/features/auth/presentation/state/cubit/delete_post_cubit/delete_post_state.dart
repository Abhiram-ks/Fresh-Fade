part of 'delete_post_cubit.dart';

@immutable
abstract class DeletePostState {}

final class DeletePostInitial extends DeletePostState {}
final class DeletePostLoading extends DeletePostState {}
final class DeletePostSuccess extends DeletePostState {}
final class DeletePostErorr extends DeletePostState {
  final String error;
  DeletePostErorr({required this.error});
}