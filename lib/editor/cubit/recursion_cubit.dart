import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../image_picker/image_picker_cubit.dart';
import 'recursion_state.dart';

class RecursionCubit extends Cubit<ExportSettings> {

  RecursionCubit(
  ) : super(ExportSettings());

  void setDepth(double value) {
    emit(state.copyWith(recursionDepth: value.toInt()));
  }

  void setFrameCount(double value) {
    emit(state.copyWith(frameCount: value.toInt()));
  }

  static List<String> get titles => [
        "Dateipfad",
        "Tiefe der Rekursion",
        "Länge des Videos",
        "Framerate",
        "Auflösung",
      ];

  String getValue(String e, BuildContext context) {
    switch (e) {
      case "Dateipfad":
        return BlocProvider.of<ImagePickerCubit>(context).state.file?.path ??
            "unbekannt";
      case "Tiefe der Rekursion":
        return state.recursionDepth == ExportSettings.maxRecursionDepth
            ? "unendlich"
            : state.recursionDepth.toString() + " Ebenen";
      case "Länge des Videos":
        return state.frameCount.toString() + " Frames";
      case "Framerate":
        return state.frameRate.toString() + " FPS";
      case "Auflösung":
        return state.size.width.toString() +
            " * " +
            state.size.height.toString() +
            " px";
      default:
        return "";
    }
  }

  void clear() {
    emit(ExportSettings());
  }

  setRelChildSize(double value) => emit(state.copyWith(relChildSize: value));

  setRelChildOffsetY(double value) =>
      emit(state.copyWith(relChildOffsetY: value));

  setRelChildOffsetX(double value) =>
      emit(state.copyWith(relChildOffsetX: value));

  void setResolution(Size size) {
    emit(state.copyWith(size: size));
  }
}
