part of 'image_picker_bloc.dart';

@immutable
abstract class ImagePickerEvent {}

final class PickImageAction extends ImagePickerEvent {}

final class ClearImageAction extends ImagePickerEvent {}