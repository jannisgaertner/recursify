import 'dart:developer';
import 'dart:io';

import 'package:image/image.dart';

import 'editor/image_picker/image_picker_cubit.dart';
import 'editor/recursion_cubit.dart';

class RecursiveImageProcessor {

  ImagePickerCubit? _imagePickerCubit;
  RecursionCubit _recursionCubit;
  int _frame = 0;

  RecursiveImageProcessor(this._imagePickerCubit, this._recursionCubit);

  set picker(ImagePickerCubit? value) {
    _imagePickerCubit = value;
  }

  void start(RecursionState state) async {
    if (_imagePickerCubit == null) {
      log("ImagePickerCubit is null");
      return;
    }

    if (_imagePickerCubit!.state.file == null) {
      log("ImagePickerCubit.state.file is null");
      return;
    }

    File img = _imagePickerCubit!.state.file!;
    await _saveImage(img);
  }

  _saveImage(File img) async {
    String filename = "img_${_paddedInt(++_frame)}.png";
    Image? decodedImage = decodePng(await img.readAsBytes());
    if (decodedImage == null) {
      log("Failed to decode image");
      return;
    }
    Image sizedImage = copyResize(
      decodedImage,
      width: _recursionCubit.state.size.width.toInt(),
      height: _recursionCubit.state.size.height.toInt(),
    );
    await File(filename).writeAsBytes(encodePng(sizedImage));
  }

  String _paddedInt(int value) {
    return value < 10
        ? "00$value"
        : value < 100
            ? "0$value"
            : value.toString();
  }
}
