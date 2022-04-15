import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:process_run/shell.dart';

import 'console_output_cubit.dart';

class FfmpegAPI {
  late final Shell shell;
  static String ffmpeg = "./ffmpeg/bin/ffmpeg";

  FfmpegAPI() : shell = Shell(throwOnError: false);

  Future<bool> runShell(BuildContext context, String command) async {
    var res = await shell.run(
      command,
      onProcess: (process) async {
        log(process.pid.toString());
        BlocProvider.of<ConsoleCubit>(context).addInfoText(
          'Neuer Prozess mit PID ${process.pid.toString()}',
        );
        //process.stdout.asBroadcastStream().listen((line) {
        //  BlocProvider.of<ConsoleCubit>(context).addTextOutput(line.toString());
        //});
        await process.exitCode;
        BlocProvider.of<ConsoleCubit>(context).addInfoText(
          'Prozess mit PID ${process.pid.toString()} beendet mit Code ${process.exitCode.toString()}',
        );
      },
    );
    if (res.outText.isNotEmpty) {
      BlocProvider.of<ConsoleCubit>(context).addTextOutput(res.outText);
    }
    if (res.errText.isNotEmpty) {
      BlocProvider.of<ConsoleCubit>(context).addErrorOutput(res.errText);
      log('ERROR: $res');
      return false;
    }
    return true;
  }

  Future<bool> runFfmpeg(BuildContext context, String command) async {
    return await this.runShell(context, ffmpeg + " " + command);
  }

  Future<void> ffmpegVersion(BuildContext context) async {
    await this.runFfmpeg(context, "-version -verbose");
  }

  Future<void> pwd(BuildContext context) async {
    await this.runShell(context, "cd");
  }

  Future<void> ls(BuildContext context) async {
    await this.runShell(context, "dir");
  }

  Future<void> createVideo(
    BuildContext context,
    int framecount, {
    int outputWidth = 720,
  }) async {
    await runShell(context, 'cd');
    String options = "-framerate 25 -i 'img%0${framecount}d.png' " +
        "\-c:v libx264 -pix_fmt yuv420p -y " +
        "-vf scale=-2:$outputWidth out.mp4";
    bool success = await runFfmpeg(context, options);
    if (success) {
      await ls(context);
    }
  }
}
