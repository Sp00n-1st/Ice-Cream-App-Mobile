part of 'counter_bloc.dart';

@immutable
abstract class CounterEvent {}

class IncrementPrice extends CounterEvent {
  final double number;
  IncrementPrice({this.number = 1});
}

class DecrementPrice extends CounterEvent {
  final double number;
  DecrementPrice({this.number = 1});
}
