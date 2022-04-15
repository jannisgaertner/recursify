import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../recursive_image_processor.dart';
import 'image_picker/image_picker_cubit.dart';

class RecursionCubit extends Cubit<RecursionState> {

  late final RecursiveImageProcessor _processor;

  RecursionCubit() : super(RecursionState()) {
    _processor = RecursiveImageProcessor();
  }

  void startProcessing() {
    _processor.start(state);
    emit(state.copyWith(isProcessing: true));
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
      default:
        return "";
    }
  }
}

class RecursionState {
  final bool isProcessing;

  // recursion
  static final int maxRecursionDepth = 100;
  static final int maxFrameCount = 200;
  final int recursionDepth;
  final int frameCount;
  final int frameRate; // TODO

  // positioning
  final double relChildSize;
  final double relChildOffsetX;
  final double relChildOffsetY;

  RecursionState({
    this.isProcessing = false,
    this.recursionDepth = 0,
    this.frameCount = 25,
    this.frameRate = 25,
    this.relChildSize = 0.9,
    this.relChildOffsetX = 0,
    this.relChildOffsetY = 0,
  }) : assert(relChildSize <= 1 && relChildSize >= 0);

  RecursionState copyWith({
    bool? isProcessing,
    int? recursionDepth,
    int? frameCount,
    int? frameRate,
    double? relChildSize,
    double? relChildOffsetX,
    double? relChildOffsetY,
  }) {
    return RecursionState(
      isProcessing: isProcessing ?? this.isProcessing,
      recursionDepth: recursionDepth ?? this.recursionDepth,
      frameCount: frameCount ?? this.frameCount,
      frameRate: frameRate ?? this.frameRate,
      relChildSize: relChildSize ?? this.relChildSize,
      relChildOffsetX: relChildOffsetX ?? this.relChildOffsetX,
      relChildOffsetY: relChildOffsetY ?? this.relChildOffsetY,
    );
  }
}