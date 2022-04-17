import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../recursive_image_processor.dart';
import '../image_picker/image_picker_cubit.dart';
import 'recursion_state.dart';

class RecursionCubit extends Cubit<RecursionState> {
  late final RecursiveImageProcessor _processor;
  ImagePickerCubit? _imagePickerCubit;

  RecursionCubit(ImagePickerCubit? imagePickerCubit) : super(RecursionState()) {
    if (imagePickerCubit != null) _imagePickerCubit = imagePickerCubit;
    _processor = RecursiveImageProcessor(_imagePickerCubit, this);
  }

  ImagePickerCubit? get picker => _imagePickerCubit;

  set picker(ImagePickerCubit? value) {
    _imagePickerCubit = value;
    _processor.picker = value;
  }

  void startProcessing() {
    _processor.start(state);
    emit(state.copyWith(isProcessing: true));
  }

  void endProcessing() {
    emit(state.copyWith(isProcessing: false));
  }

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
        return state.recursionDepth == RecursionState.maxRecursionDepth
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
    this._processor.reset();
    emit(RecursionState());
  }

  setRelChildSize(double value) => emit(state.copyWith(relChildSize: value));

  setRelChildOffsetY(double value) =>
      emit(state.copyWith(relChildOffsetY: value));

  setRelChildOffsetX(double value) =>
      emit(state.copyWith(relChildOffsetX: value));
}
