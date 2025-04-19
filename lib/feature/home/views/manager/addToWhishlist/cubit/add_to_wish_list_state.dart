part of 'add_to_wish_list_cubit.dart';

@immutable
sealed class AddToWishListState {}

final class AddToWishListInitial extends AddToWishListState {}

final class AddToWishListLoading extends AddToWishListState {}

final class AddToWishListSuccess extends AddToWishListState {}

final class AddToWishListError extends AddToWishListState {
  final String e;

  AddToWishListError({required this.e});
}
