import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'image_picker_state.dart';

class ImagePickerCubit extends Cubit<ProcessableImageFile> {
  ImagePickerCubit() : super(ProcessableImageFile(null));

  Future<File?> pickImage() async {
    final file = OpenFilePicker()
      ..filterSpecification = {'PNG-Bild Dateien (*.png)': '*.png'}
      ..defaultFilterIndex = 0
      ..defaultExtension = 'png'
      ..title = 'Bild für Recursify auswählen';

    final result = file.getFile();
    if (result != null) {
      log(result.path);
    }
    emit(ProcessableImageFile(result));
    ui.Size? size = await determineSizing();
    emit(ProcessableImageFile(result, size: size));
    return result;
  }

  Future<ui.Size?> determineSizing() async {
    if (!isPicked) return null;
    ui.Image decodedImage = await fluent.decodeImageFromList(
      state.file!.readAsBytesSync(),
    );
    log(decodedImage.width.toString());
    log(decodedImage.height.toString());

    return ui.Size(
      decodedImage.width.toDouble(),
      decodedImage.height.toDouble(),
    );
  }

  void clear() => emit(ProcessableImageFile(null));

  bool get isPicked => state.file != null;
}
