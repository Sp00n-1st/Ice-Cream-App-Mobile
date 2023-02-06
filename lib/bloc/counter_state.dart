part of 'counter_bloc.dart';

@immutable
abstract class CounterState {
  final double number;
  const CounterState(this.number);
}

class CounterInitial extends CounterState {
  const CounterInitial() : super(0);
}

class CounterLoad extends CounterState {
  const CounterLoad(double number) : super(number);
}
