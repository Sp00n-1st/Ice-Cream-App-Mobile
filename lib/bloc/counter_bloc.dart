import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'counter_event.dart';
part 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterInitial()) {
    on<IncrementPrice>((event, emit) {
      emit(state is CounterLoad
          ? CounterLoad(state.number + event.number)
          : CounterLoad(event.number));
    });
    on<DecrementPrice>((event, emit) {
      emit(state is CounterLoad
          ? CounterLoad(state.number - event.number)
          : const CounterLoad(-1));
    });
  }
}
