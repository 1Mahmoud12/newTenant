part of 'process_to_checkout_cubit.dart';

@immutable
sealed class ProcessToCheckoutState {}

final class ProcessToCheckoutInitial extends ProcessToCheckoutState {}

final class ProcessToCheckoutLoading extends ProcessToCheckoutState {}

final class ProcessToCheckoutSuccess extends ProcessToCheckoutState {}

final class ProcessToCheckoutError extends ProcessToCheckoutState {
  final String e;
  ProcessToCheckoutError({required this.e});
}
