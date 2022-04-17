import 'package:fluent_ui/fluent_ui.dart';

class ExportSettings {
  // recursion
  static final int maxRecursionDepth = 100;
  static final int maxFrameCount = 25 * 60; // 1 min at 25 fps
  final int recursionDepth;
  final int frameCount;
  final int frameRate; // TODO

  // positioning
  final double relChildSize;
  final double relChildOffsetX;
  final double relChildOffsetY;

  // resolution
  final Size size;

  ExportSettings({
    this.recursionDepth = 0,
    this.frameCount = 25,
    this.frameRate = 25,
    this.relChildSize = 0.9,
    this.relChildOffsetX = 0.05,
    this.relChildOffsetY = 0.05,
    this.size = const Size(1280, 720),
  }) : assert(relChildSize <= 1 && relChildSize >= 0);

  ExportSettings copyWith({
    int? recursionDepth,
    int? frameCount,
    int? frameRate,
    double? relChildSize,
    double? relChildOffsetX,
    double? relChildOffsetY,
    Size? size,
  }) {
    return ExportSettings(
      recursionDepth: recursionDepth ?? this.recursionDepth,
      frameCount: frameCount ?? this.frameCount,
      frameRate: frameRate ?? this.frameRate,
      relChildSize: relChildSize ?? this.relChildSize,
      relChildOffsetX: relChildOffsetX ?? this.relChildOffsetX,
      relChildOffsetY: relChildOffsetY ?? this.relChildOffsetY,
      size: size ?? this.size,
    );
  }
}
