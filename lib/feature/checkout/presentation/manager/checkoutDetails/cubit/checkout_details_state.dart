part of 'checkout_details_cubit.dart';

@immutable
sealed class CheckoutDetailsState {}

final class CheckoutDetailsInitial extends CheckoutDetailsState {}

final class CheckoutDetailsLoading extends CheckoutDetailsState {}

final class CheckoutDetailsSuccess extends CheckoutDetailsState {}

final class CheckoutDetailsError extends CheckoutDetailsState {
  final String e;

  CheckoutDetailsError({required this.e});
}
