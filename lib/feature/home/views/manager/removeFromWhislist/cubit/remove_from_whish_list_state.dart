part of 'remove_from_whish_list_cubit.dart';

@immutable
sealed class RemoveFromWhishListState {}

final class RemoveFromWhishListInitial extends RemoveFromWhishListState {}

final class RemoveFromWhishListLoading extends RemoveFromWhishListState {}

final class RemoveFromWhishListSuccess extends RemoveFromWhishListState {}

final class RemoveFromWhishListError extends RemoveFromWhishListState {
  final String e;

  RemoveFromWhishListError({required this.e});
}
