import 'package:flutter_bloc/flutter_bloc.dart';

class NavCubit extends Cubit<int> {
  NavCubit() : super(0);

  void setIndex(int index) => emit(index);

  void next() => emit(state + 1);

  void previous() => emit(state - 1);

  void reset() => emit(0);
}
