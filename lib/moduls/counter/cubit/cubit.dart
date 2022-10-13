

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/moduls/counter/cubit/states.dart';

class ConterCubit extends Cubit<CounterStates>
{
  ConterCubit():super(CounterInitialState());



  static ConterCubit get(context)=>BlocProvider.of(context);
  int counter=1;

  void minus()
  {
    counter--;
    emit(CounterMinusState(counter));
  }
  void plus()
  {
    counter++;
    emit(CounterPlusState(counter));
  }
}