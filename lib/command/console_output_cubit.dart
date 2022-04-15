import 'package:flutter_bloc/flutter_bloc.dart';

class ConsoleCubit extends Cubit<ConsoleState> {
  ConsoleCubit() : super(ConsoleState([]));

  void addTextOutput(String text) {
    emit(state.copyWith(ConsoleOutput(text)));
  }

  void addErrorOutput(String text) {
    emit(state.copyWith(ConsoleOutput(text, isError: true)));
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
}

class ConsoleOutput {
  final String text;
  final bool isError;

  ConsoleOutput(
    this.text, {
    this.isError = false,
  });
}
