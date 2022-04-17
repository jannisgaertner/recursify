import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    _processor!.start().listen((int? recFrameIndex) {
      if (recFrameIndex == null) {
        emit(ProcessingVideoExport());
        return;
      }
      emit(ProcessingRecursiveFrames(recFrameIndex, settings.recursionDepth));
    })
      ..onError((Object error) {
        emit(ProcessingError(errorMessage: error.toString()));
      })
      ..onDone(() {
        emit(ProcessingFinished(success: true));
      });
  }

  void endProcessing() {
    emit(ProcessingFinished());
  }

  void clear() {
    emit(ProcessingInitial());
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

  ProcessingFinished({this.success = false});
}

class ProcessingError extends ProcessingState {
  final String? errorMessage;

  ProcessingError({this.errorMessage});
}
