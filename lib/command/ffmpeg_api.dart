import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:process_run/shell.dart';
import 'package:recursify/recursive_image_processor.dart';

import 'console_output_cubit.dart';

class FfmpegAPI {
  late final Shell shell;
  static String ffmpeg = "./ffmpeg/bin/ffmpeg";

  FfmpegAPI() : shell = Shell(throwOnError: false) {
    _init();
  }

  void _init() async {
    await createFolder();
    await runShell(null, 'cd export');
  }

  Future<bool> runShell(BuildContext? context, String command) async {
    var res = await shell.run(
      command,
      onProcess: (process) async {
        log(process.pid.toString());
        if (context != null)
          BlocProvider.of<ConsoleCubit>(context).addInfoText(
          'Neuer Prozess mit PID ${process.pid.toString()}',
        );
        //process.stdout.asBroadcastStream().listen((line) {
        //  BlocProvider.of<ConsoleCubit>(context).addTextOutput(line.toString());
        //});
        process.exitCode.asStream().listen((event) async {
          await Future.delayed(Duration(milliseconds: 100));
          if (context != null)
            BlocProvider.of<ConsoleCubit>(context).addInfoText(
              'Prozess mit PID ${process.pid.toString()} beendet mit Code ${event.toString()}',
            );
        });
      },
    );
    if (res.outText.isNotEmpty && context != null) {
      BlocProvider.of<ConsoleCubit>(context).addTextOutput(res.outText);
    }
    if (res.errText.isNotEmpty) {
      if (context != null)
        BlocProvider.of<ConsoleCubit>(context).addErrorOutput(res.errText);
      log('ERROR: $res');
      return false;
    }
    return true;
  }

  Future<bool> runFfmpeg(BuildContext? context, String command) async {
    return await this.runShell(context, ffmpeg + " " + command);
  }

  Future<void> ffmpegVersion(BuildContext? context) async {
    await this.runFfmpeg(context, "-version -verbose");
  }

  Future<void> pwd(BuildContext? context) async {
    await this.runShell(context, "cd");
  }

  Future<void> ls(BuildContext? context) async {
    await this.runShell(context, "dir");
  }

  Future<String?> createVideo(
    BuildContext? context, {
    required int framecount,
    required int recursionLevel,
    int framerate = 25,
    int outputWidth = 720,
  }) async {
    await runShell(context, 'cd');
    String imgFiles = "";
    for (int i = 1; i < math.min(recursionLevel, framecount); i++) {
      imgFiles += "|img_${RecursiveImageProcessor.paddedInt(i)}.png";
    }
    if (framecount > recursionLevel) {
      for (var i = recursionLevel; i < framecount; i++) {
        imgFiles +=
            "|img_${RecursiveImageProcessor.paddedInt(recursionLevel - 1)}.png";
      }
    }
    imgFiles = imgFiles.substring(1);
    String options = "-framerate $framerate -i 'concat:$imgFiles' " +
        "\-c:v libx264 -pix_fmt yuv420p -y " +
        "-vf scale=-2:$outputWidth out.mp4";
    bool success = await runFfmpeg(context, options);
    if (success) {
      await ls(context);
      return "out.mp4";
    }
    return null;
  }

  Future<void> createFolder() {
    return shell.run('mkdir -p export');
  }
}
