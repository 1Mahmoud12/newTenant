part of 'delete_from_cart_cubit.dart';

@immutable
sealed class DeleteFromCartState {}

final class DeleteFromCartInitial extends DeleteFromCartState {}

final class DeleteFromCartLoading extends DeleteFromCartState {}

final class DeleteFromCartSuccess extends DeleteFromCartState {}

final class DeleteFromCartError extends DeleteFromCartState {
  final String e;

  DeleteFromCartError({required this.e});
}
