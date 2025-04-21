part of 'state_cubit.dart';

@immutable
sealed class StateState {}

final class StateInitial extends StateState {}

final class StateLoading extends StateState {}

final class StateSuccess extends StateState {}

final class StateError extends StateState {
  final String e;
  StateError({required this.e});
}
