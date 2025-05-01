part of 'main_cubit_cubit.dart';

@immutable
sealed class MainCubitState {}

final class MainCubitInitial extends MainCubitState {}
final class ChangeInitialState extends MainCubitState {}
