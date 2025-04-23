part of 'slider_cubit.dart';

@immutable
sealed class SliderState {}

final class SliderInitial extends SliderState {}
final class SliderLoading extends SliderState {}
final class SliderSuccess extends SliderState {}
final class SliderError extends SliderState {final String e; SliderError({required this.e});}
