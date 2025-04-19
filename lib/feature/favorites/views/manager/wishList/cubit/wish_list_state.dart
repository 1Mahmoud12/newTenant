part of 'wish_list_cubit.dart';

@immutable
sealed class WishListState {}

final class WishListInitial extends WishListState {}

final class WishListLoading extends WishListState {}

final class WishListSuccess extends WishListState {}

final class WishListError extends WishListState {
  final String e;

  WishListError({required this.e});
}
