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

final class AddToWishListLoading extends WishListState {}

final class AddToWishListSuccess extends WishListState {}

final class AddToWishListError extends WishListState {
  final String e;

  AddToWishListError({required this.e});
}

final class RemoveFromWishListLoading extends WishListState {}

final class RemoveFromWishListSuccess extends WishListState {}

final class RemoveFromWishListError extends WishListState {
  final String e;

  RemoveFromWishListError({required this.e});
}
