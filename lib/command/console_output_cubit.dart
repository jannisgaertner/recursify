import 'dart:developer';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsoleCubit extends Cubit<ConsoleState> {
  ConsoleCubit() : super(ConsoleState([]));

  void addTextOutput(String text) {
    emit(state.copyWith(ConsoleOutput(text)));
  }

  void addInfoText(String text) {
    emit(state.copyWith(ConsoleOutput(text, outputType: OutputType.info)));
  }

  void addErrorOutput(String text) {
    emit(state.copyWith(ConsoleOutput(text, outputType: OutputType.error)));
  }

  void clear() {
    emit(ConsoleState([]));
  }
}

class ConsoleState {
  List<ConsoleOutput> _outputs = [];

  ConsoleState(List<ConsoleOutput> outputs) : _outputs = outputs;

  ConsoleState copyWith(ConsoleOutput output) {
    _outputs.add(output);
    return ConsoleState(_outputs);
  }

  String get text => _outputs.map((e) => e.text).join('\n\n\n');

  RichText get richtext {
    return RichText(
      overflow: TextOverflow.visible,
      text: TextSpan(
        style: TextStyle(
          fontFamily: 'Roboto Mono',
          fontSize: 16,
          color: Colors.black,
        ),
        children: _outputs.map((e) => e.textSpan).toList(),
      ),
    );
  }
}

class ConsoleOutput {
  final String text;
  final OutputType type;

  ConsoleOutput(
    this.text, {
    OutputType? outputType,
  }) : this.type = outputType ?? OutputType.text;

  InlineSpan get textSpan {
    switch (type) {
      case OutputType.text:
        return _span();
      case OutputType.info:
        return _span(Colors.blue['normal']);
      case OutputType.error:
        return _span(Colors.red['normal']);
    }
  }

  TextSpan _span([Color? color]) => TextSpan(
        text: text + "\n\n\n",
        style: TextStyle(
          color: color,
          fontFamily: 'Roboto Mono',
        ),
      );
}

enum OutputType {
  text,
  info,
  error,
}
