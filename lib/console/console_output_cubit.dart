import 'package:flutter_bloc/flutter_bloc.dart';

import 'console_output.dart';
import 'console_state.dart';
import 'output_type.dart';

class ConsoleCubit extends Cubit<ConsoleState> {
  ConsoleCubit() : super(ConsoleState([]));

  void addMessage(String message, OutputType type) {
    switch (type) {
      case OutputType.text:
        addTextOutput(message);
        break;
      case OutputType.error:
        addErrorOutput(message);
        break;
      case OutputType.info:
        addInfoOutput(message);
        break;
      default:
    }
  }

  void addTextOutput(String text) {
    emit(state.copyWith(ConsoleOutput(text)));
  }

  void addInfoOutput(String text) {
    emit(state.copyWith(ConsoleOutput(text, outputType: OutputType.info)));
  }

  void addErrorOutput(String text) {
    emit(state.copyWith(ConsoleOutput(text, outputType: OutputType.error)));
  }

  void clear() {
    emit(ConsoleState([]));
  }
}

