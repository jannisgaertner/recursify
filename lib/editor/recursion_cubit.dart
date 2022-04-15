import 'package:flutter_bloc/flutter_bloc.dart';

class RecursionCubit extends Cubit<RecursionState> {
  RecursionCubit() : super(RecursionState());

  void setDepth(double value) {
    emit(state.copyWith(recursionDepth: value.toInt()));
  }

  void setFrameCount(double value) {
    emit(state.copyWith(frameCount: value.toInt()));
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
