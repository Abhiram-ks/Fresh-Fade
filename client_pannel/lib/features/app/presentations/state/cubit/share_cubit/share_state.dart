part of 'share_cubit.dart';

@immutable
abstract class ShareState {}

final class ShareInitial extends ShareState {}

final class ShareLoading extends ShareState {}

final class ShareSuccess extends ShareState {
  final String text;
  final String ventureName;
  final String location;
  final String? imageUrl;
  
  ShareSuccess({required this.text, required this.ventureName, required this.location, this.imageUrl});
}

final class ShareFailure extends ShareState {
  final String error;
  ShareFailure({required this.error});
}