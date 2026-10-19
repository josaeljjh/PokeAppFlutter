import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavCubit extends Cubit<int> {
  BottomNavCubit() : super(0);

  static const regionTab = 0;
  static const teamsTab = 1;

  void updateIndex(int index) => emit(index);
}
