import 'dart:developer';
import 'dart:io';

import 'package:image/image.dart';

import 'console/ffmpeg_api.dart';
import 'editor/cubit/recursion_state.dart';
import 'editor/image_picker/image_picker_state.dart';

class RecursiveImageProcessor {
  final FfmpegAPI ffmpeg;
  final ExportSettings settings;
  final ProcessableImageFile image;

  int _frame = 1;
  String? _outputPath;

  RecursiveImageProcessor(
    {
    required this.ffmpeg,
    required this.image,
    required this.settings,
  }
  ) : assert(image.hasPicked);


  /// returns the current frame index as a Stream
  /// processes only recurion affected frames
  Stream<dynamic> start() async* {
    assert(image.hasPicked);

    yield 1;

    // save first frame
    await _saveImageFromFile(
      image.file!,
      width: settings.size.width.toInt(),
      height: settings.size.height.toInt(),
    );

    // kick off recursion
    Image? baseImg = decodeImage(image.file!.readAsBytesSync());
    if (baseImg == null) {
      log("Image is null");
      return;
    }
    int depth = settings.recursionDepth >= ExportSettings.maxRecursionDepth
        ? settings.frameCount
        : settings.recursionDepth;
    log("starting recursive processing of depth $depth");
    yield* _imageRecursion(baseImg, baseImg, settings);

    // save as video
    log("saving video");
    String? path = await _saveVideo(settings);
    if (path != null) yield path;
  }

  Stream<int?> _imageRecursion(
    Image baseImg,
    Image topImg,
    ExportSettings state,
  ) async* {
    int depth = settings.recursionDepth >= ExportSettings.maxRecursionDepth
        ? settings.frameCount
        : settings.recursionDepth;
    if (++_frame > depth) return;

    //Image copyInto(Image dst, Image src, {int dstX, int dstY, int srcX, int srcY, int srcW, int srcH, bool blend = true});
    //Copy an area of the src image into dst.
    //Returns the modified dst image.
    int srcX = (topImg.width * state.relChildOffsetX).toInt();
    int srcY = (topImg.height * state.relChildOffsetY).toInt();
    int srcW = (topImg.width * state.relChildSize).toInt();
    int srcH = (topImg.height * state.relChildSize).toInt();
    Image topImgScaled = copyResize(topImg, width: srcW, height: srcH);
    log("srcX: $srcX, srcY: $srcY, srcW: $srcW, srcH: $srcH");
    log("baseImg.width: ${baseImg.width}, baseImg.height: ${baseImg.height}");
    Image resImg =
        copyInto(baseImg, topImgScaled, srcX: 0, srcY: 0, center: true);

    File? res = await _saveImage(
      resImg,
      width: state.size.width.toInt(),
      height: state.size.height.toInt(),
    );
    if (res == null) return;

    log("recursion level $_frame successful");
    yield _frame;
    yield* _imageRecursion(baseImg, resImg, state);
  }

  Future<File?> _saveImageFromFile(File img, {int? width, int? height}) async {
    Image? decodedImage = decodeImage(await img.readAsBytes());
    if (decodedImage == null) {
      log("Failed to decode image");
      return null;
    }
    return await _saveImage(decodedImage, width: width, height: height);
  }

  Future<File?> _saveImage(Image img, {int? width, int? height}) async {
    String filename = "export/img_${paddedInt(_frame)}.png";
    Image sizedImage = copyResize(img, width: width, height: height);
    File saved = await File(filename).writeAsBytes(encodePng(sizedImage));
    return saved;
  }

  Future<String?> _saveVideo(ExportSettings state) async {
    _outputPath = await ffmpeg.createVideo(
      framecount: state.frameCount,
      recursionLevel: state.recursionDepth,
      framerate: state.frameRate,
      outputWidth: state.size.width.toInt(),
    );
    return _outputPath;
  }

  static String paddedInt(int value) {
    return value < 10
        ? "00$value"
        : value < 100
            ? "0$value"
            : value.toString();
  }

  void reset() {
    _frame = 1;
    _outputPath = null;
  }
}
