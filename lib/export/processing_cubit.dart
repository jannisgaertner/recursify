import 'dart:developer';
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../console/ffmpeg_api.dart';
import '../editor/cubit/recursion_cubit.dart';
import '../editor/cubit/recursion_state.dart';
import '../editor/image_picker/image_picker_cubit.dart';
import '../editor/image_picker/image_picker_state.dart';
import '../recursive_image_processor.dart';

class ProcessingCubit extends Cubit<ProcessingState> {
  final FfmpegAPI _ffmpeg;
  RecursiveImageProcessor? _processor;

  ProcessingCubit(this._ffmpeg) : super(ProcessingInitial());

  void start(BuildContext context) {
    ExportSettings settings = BlocProvider.of<RecursionCubit>(context).state;
    ProcessableImageFile imageFile =
        BlocProvider.of<ImagePickerCubit>(context).state;
    this.startProcessing(settings, imageFile);
  }

  void startProcessing(ExportSettings settings, ProcessableImageFile image) {
    if (!image.hasPicked) {
      emit(ProcessingError(errorMessage: "Keine Bilddatei ausgewählt!"));
      return;
    }

    _processor = RecursiveImageProcessor(
      image: image,
      settings: settings,
      ffmpeg: _ffmpeg,
    );

    String filepath = "";
    _processor!.start().listen((dynamic recFrameIndex) {
      log("Processor update: $recFrameIndex");
      if (recFrameIndex == null) {
        emit(ProcessingVideoExport());
        return;
      } else if (recFrameIndex is int) {
      emit(ProcessingRecursiveFrames(recFrameIndex, settings.recursionDepth));
      } else if (recFrameIndex is String) {
        filepath = recFrameIndex;
      }
    })
      ..onError((Object error) {
        emit(ProcessingError(errorMessage: error.toString()));
      })
      ..onDone(() {
        emit(ProcessingFinished(success: true, filePath: filepath));
      });
  }

  void endProcessing() {
    emit(ProcessingFinished());
  }

  void clear() {
    emit(ProcessingInitial());
  }

  void openVideo() async {
    if (this.state is ProcessingFinished) {
      String? path = (this.state as ProcessingFinished).filePath;
      if (path == null) {
        log("Pfad nicht vorhanden");
        return;
      }
      final Uri uri = Uri.file(path);

      if (await File(uri.toFilePath()).exists()) {
        if (!await launch(uri.toString())) {
          throw 'Could not launch $uri';
        }
      } else {
        log("File does not exist");
      }
    } else {
      log("current status is not 'ProcessingFinished': ${this.state}");
    }
  }
}

class ProcessingState {
  ProcessingState();

  bool get isProcessing => this is ProcessingCurrently;
}

class ProcessingInitial extends ProcessingState {}

abstract class ProcessingCurrently extends ProcessingState {
  final double? progress;

  ProcessingCurrently(this.progress);
  String get label;
}

class ProcessingRecursiveFrames extends ProcessingCurrently {
  final int index, total;
  ProcessingRecursiveFrames(this.index, this.total) : super(index / total);

  @override
  String get label =>
      "Generiere rekursive Frames: $index von $total " +
      "(${(progress! * 100).toStringAsPrecision(4)}%)";
}

class ProcessingVideoExport extends ProcessingCurrently {
  ProcessingVideoExport() : super(null);

  @override
  String get label => "Video wird exportiert...";
}

class ProcessingFinished extends ProcessingState {
  bool success;
  String? filePath;

  ProcessingFinished({this.success = false, this.filePath});
}

class ProcessingError extends ProcessingState {
  final String? errorMessage;

  ProcessingError({this.errorMessage});
}
