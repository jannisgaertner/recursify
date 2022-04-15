import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConsoleCubit extends Cubit<ConsoleState> {
  ConsoleCubit() : super(ConsoleState([]));

  void addTextOutput(String text) {
    emit(state.copyWith(ConsoleOutput(text)));
  }

  void addInfoText(String text) {
    emit(state.copyWith(ConsoleOutput(text, type: OutputType.info)));
  }

  void addErrorOutput(String text) {
    emit(state.copyWith(ConsoleOutput(text, type: OutputType.error)));
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
      text: TextSpan(
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
    this.type = OutputType.text,
  });

  InlineSpan get textSpan {
    switch (type) {
      case OutputType.text:
        return TextSpan(
          text: text,
          style: TextStyle(
            fontFamily: 'Roboto Mono',
          ),
        );
      case OutputType.info:
        return TextSpan(
          text: text,
          style: TextStyle(
            color: Colors.blue['500'],
            fontFamily: 'Roboto Mono',
          ),
        );
      case OutputType.error:
        return TextSpan(
          text: text,
          style: TextStyle(
            color: Colors.red['500'],
            fontFamily: 'Roboto Mono',
          ),
        );
    }
  }
}

enum OutputType {
  text,
  info,
  error,
}
