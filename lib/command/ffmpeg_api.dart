import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:process_run/shell.dart';

import 'console_output_cubit.dart';

class FfmpegAPI {
  late final Shell shell;
  static String ffmpeg = "./ffmpeg/bin/ffmpeg";

  FfmpegAPI() : shell = Shell(throwOnError: false);

  Future<bool> runShell(BuildContext context, String command) async {
    var res = await shell.run(command);
    if (res.outText.isNotEmpty) {
      BlocProvider.of<ConsoleCubit>(context).addTextOutput(res.outText);
    }
    if (res.errText.isNotEmpty) {
      BlocProvider.of<ConsoleCubit>(context).addErrorOutput(res.errText);
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

  Future<void> createVideo(BuildContext context) async {
    await runShell(context, 'cd');
    String options =
        "-framerate 25 -i img%.png \-c:v libx264 -pix_fmt yuv420p out.mp4";
    await runFfmpeg(context, options);
  }
}
