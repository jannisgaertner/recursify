import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'console_output_cubit.dart';
import 'console_state.dart';
import 'ffmpeg_api.dart';

class Console extends StatelessWidget {
  Console({
    Key? key,
  })  : ffmpeg = FfmpegAPI(),
        super(key: key);

  final FfmpegAPI ffmpeg;
  final ScrollController _scrollController = ScrollController();

  

  @override
  Widget build(BuildContext context) {

    Map<String, Function()> _buttons = {
      'FFMPEG vorhanden': () => ffmpeg.hasFfmpeg(context: context),
      'FFMPEG Version': () => ffmpeg.ffmpegVersion(context: context),
      'Arbeitsverzeichnis': () => ffmpeg.pwd(context: context),
      'Ordnerinhalt': () => ffmpeg.ls(context: context),
      'Video erstellen': () => ffmpeg.createVideo(
            context: context,
            framecount: 10,
            recursionLevel: 10,
          ),
    };

    return Container(
      color: FluentTheme.of(context).acrylicBackgroundColor,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          BlocBuilder<ConsoleCubit, ConsoleState>(
            builder: (context, state) {
              return SingleChildScrollView(
                controller: _scrollController,
                child: Container(
                  alignment: Alignment.bottomLeft,
                  margin: const EdgeInsets.all(20),
                  child: state.richtext,
                ),
              );
            },
          ),
          Container(
            alignment: Alignment.bottomRight,
            margin: const EdgeInsets.only(bottom: 60, right: 30),
            child: SizedBox(
              width: 150,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _buttons.keys.map((key) {
                  return Container(
                    child: Button(child: Text(key), onPressed: _buttons[key]),
                    margin: const EdgeInsets.only(bottom: 10),
                  );
                }).toList(),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            margin: const EdgeInsets.all(30),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => _scrollDown(),
                  icon: Icon(FluentIcons.chevron_down_end),
                  iconButtonMode: IconButtonMode.large,
                ),
                IconButton(
                  onPressed: () => _scrollUp(),
                  icon: Icon(FluentIcons.chevron_up_end),
                  iconButtonMode: IconButtonMode.large,
                ),
                IconButton(
                  onPressed: () =>
                      BlocProvider.of<ConsoleCubit>(context).clear(),
                  icon: Icon(FluentIcons.delete),
                  iconButtonMode: IconButtonMode.large,
                  //label: Text("Konsolenausgabe leeren"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  void _scrollUp() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }
}
