import 'dart:io';

import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImagePickerCubit extends Cubit<File?> {
  ImagePickerCubit() : super(null);

  File? pickImage() {
    final file = OpenFilePicker()
      ..filterSpecification = {'PNG-Bild Dateien (*.png)': '*.png'}
      ..defaultFilterIndex = 0
      ..defaultExtension = 'png'
      ..title = 'Bild für Recursify auswählen';

    final result = file.getFile();
    if (result != null) {
      print(result.path);
    }
    emit(result);
    return result;
  }

  void clear() => emit(null);

  bool get isPicked => state != null;
}
