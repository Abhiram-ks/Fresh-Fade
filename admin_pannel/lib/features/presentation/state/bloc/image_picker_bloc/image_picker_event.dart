part of 'image_picker_bloc.dart';

@immutable
abstract class PickImageEvent{}
class ImagePickerEvent extends PickImageEvent{}
class ClearImageAction extends ImagePickerEvent {} 