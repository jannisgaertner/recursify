import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:process_run/shell.dart';

import 'package:flutter/material.dart';
import 'package:recursify/command/console_output_cubit.dart';
import 'package:recursify/command/ffmpeg_api.dart';

import 'command/console.dart';

void main() {
  runApp(RecursifyApp());
}

class RecursifyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ConsoleCubit>(
      create: (context) => ConsoleCubit(),
      child: MaterialApp(
        title: 'Flutter Demo',
        home: Scaffold(
          appBar: AppBar(
            title: Text('Flutter Demo'),
          ),
          body: Center(
            child: AppBody(),
          ),
        ),
      ),
    );
  }
}

class AppBody extends StatelessWidget {
  const AppBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Console(),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OutlinedButton(
                  onPressed: () => FfmpegAPI().pwd(context),
                  child: Text("Working Directory"),
                ),
                SizedBox(height: 20),
                OutlinedButton(
                  onPressed: () => FfmpegAPI().ls(context),
                  child: Text("List Files"),
                ),
                SizedBox(height: 20),
                OutlinedButton(
                  onPressed: () => FfmpegAPI().ffmpegVersion(context),
                  child: Text("FFMPEG Version"),
                ),
                SizedBox(height: 20),
                OutlinedButton(
                  onPressed: () => FfmpegAPI().createVideo(context),
                  child: Text("Video aus Bildern erstellen"),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
