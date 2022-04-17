import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:process_run/shell.dart';

import '../recursive_image_processor.dart';
import 'console_output_cubit.dart';
import 'output_type.dart';

class FfmpegAPI {
  late final Shell shell;
  static String ffmpeg = "./ffmpeg/bin/ffmpeg";
  final ConsoleCubit? _console;

  FfmpegAPI()
      : shell = Shell(throwOnError: false),
        _console = null;

  FfmpegAPI.withConsole(ConsoleCubit console)
      : shell = Shell(throwOnError: false),
        _console = console;

/*
  void _init() async {
    await runShell('''
:: check the name of the current directory
:: if it is 'export' exit this script
for %%I in (.) do set CurrDirName=%%~nxI
if "%CurrDirName%"=="export" goto :eof

:: Check if folder export exists
IF NOT EXIST "%~dp0export" (
    echo "The export folder doesn't exist."
    :: create folder
    mkdir "%~dp0export"
)

:: navigate to the export folder
cd "%~dp0export"
''');
  }
*/

  /// providing a BuildContext will be preferred over the console variable
  void _printToConsole(
    String? message, {
    OutputType type = OutputType.text,
    BuildContext? context,
  }) {
    if (message == null || message.isEmpty) return;

    ConsoleCubit consoleCubit;
    if (context != null) {
      consoleCubit = BlocProvider.of<ConsoleCubit>(context);
    } else if (_console != null) {
      consoleCubit = _console!;
    } else {
      return;
    }

    consoleCubit.addMessage(message, type);
  }

  Future<bool> runShell(String command, {BuildContext? context}) async {
    var res = await shell.run(
      command,
      onProcess: (process) async {
        log(process.pid.toString());
        _printToConsole(
          'Neuer Prozess mit PID ${process.pid.toString()}',
          context: context,
          type: OutputType.info,
        );
        process.exitCode.asStream().listen((event) async {
          await Future.delayed(Duration(milliseconds: 100));
          _printToConsole(
            'Prozess mit PID ${process.pid.toString()} beendet mit Code ${event.toString()}',
            type: OutputType.info,
            context: context,
          );
        });
      },
    );
    _printToConsole(res.outText, context: context);
    _printToConsole(res.errText, type: OutputType.error, context: context);
    return res.errText.isEmpty;
  }

  Future<bool> hasFfmpeg({BuildContext? context}) async {
    bool hasVersion = await ffmpegVersion();
    _printToConsole(hasVersion.toString(), context: context);
    return hasVersion;
  }

  Future<bool> runFfmpeg(String command, {BuildContext? context}) async {
    return await this.runShell(ffmpeg + " " + command, context: context);
  }

  Future<bool> ffmpegVersion({BuildContext? context}) async {
    return await this.runFfmpeg("-version -verbose", context: context);
  }

  Future<void> pwd({BuildContext? context}) async {
    await this.runShell("cd", context: context);
  }

  Future<void> ls({BuildContext? context}) async {
    await this.runShell("dir", context: context);
  }

  Future<String?> createVideo({
    required int framecount,
    required int recursionLevel,
    int framerate = 25,
    int outputWidth = 720,
    BuildContext? context,
  }) async {
    await pwd(context: context);
    String imgFiles = "";
    for (int i = 1; i < math.min(recursionLevel, framecount); i++) {
      imgFiles += "|export/img_${RecursiveImageProcessor.paddedInt(i)}.png";
    }
    if (framecount > recursionLevel) {
      for (var i = recursionLevel; i < framecount; i++) {
        imgFiles +=
            "|export/img_${RecursiveImageProcessor.paddedInt(recursionLevel - 1)}.png";
      }
    }
    imgFiles = imgFiles.substring(1);
    String options = "-framerate $framerate -i 'concat:$imgFiles' " +
        "\-c:v libx264 -pix_fmt yuv420p -y " +
        "-vf scale=-2:$outputWidth out.mp4";
    //bool success =
    await runFfmpeg(options, context: context);
    //if (success) {
    //  await ls(context: context);
    //  return "out.mp4";
    // }
    return "out.mp4";
  }
}
