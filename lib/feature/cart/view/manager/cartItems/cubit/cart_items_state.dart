part of 'cart_items_cubit.dart';

@immutable
sealed class CartItemsState {}

final class CartItemsInitial extends CartItemsState {}
final class CartItemsLoading extends CartItemsState {}
final class CartItemsSuccess extends CartItemsState {}
final class UpdateCartItems extends CartItemsState {}
final class CartItemsError extends CartItemsState {final String e;
  CartItemsError({required this.e});
}
