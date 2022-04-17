import 'dart:io';
import 'dart:ui' as ui;

class ProcessableImageFile {
  final File? file;
  final ui.Size? size;

  ProcessableImageFile(this.file, {this.size});

  double get aspectRatio {
    if (size == null) return 1;
    return (size?.width ?? 1) / (size?.height ?? 1);
  }

  bool get hasPicked => file != null;
}
