import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:developer';

import 'console_output_cubit.dart';

class Console extends StatelessWidget {
  Console({
    Key? key,
  }) : super(key: key);

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
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
