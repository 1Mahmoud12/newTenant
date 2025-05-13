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

final class GetAllPaymentsLoading extends ProcessToCheckoutState {}

final class GetAllPaymentsSuccess extends ProcessToCheckoutState {}

final class GetAllPaymentsError extends ProcessToCheckoutState {
  final String e;

  GetAllPaymentsError({required this.e});
}

final class CreateSTCFirstLoading extends ProcessToCheckoutState {}

final class CreateSTCFirstSuccess extends ProcessToCheckoutState {}

final class CreateSTCFirstError extends ProcessToCheckoutState {
  final String e;

  CreateSTCFirstError({required this.e});
}

final class CreateSTCSecondLoading extends ProcessToCheckoutState {}

final class CreateSTCSecondSuccess extends ProcessToCheckoutState {}

final class CreateSTCSecondError extends ProcessToCheckoutState {
  final String e;

  CreateSTCSecondError({required this.e});
}

final class CreateCreditLoading extends ProcessToCheckoutState {}

final class CreateCreditSuccess extends ProcessToCheckoutState {}

final class CreateCreditError extends ProcessToCheckoutState {
  final String e;

  CreateCreditError({required this.e});
}
