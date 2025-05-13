part of 'payment_cubit.dart';

@immutable
sealed class PaymentState {}

final class PaymentInitial extends PaymentState {}

final class PaymentLoading extends PaymentState {}

final class PaymentSuccess extends PaymentState {}

final class PaymentError extends PaymentState {
  final String e;

  PaymentError({required this.e});
}

final class GetAllPaymentsLoading extends PaymentState {}

final class GetAllPaymentsSuccess extends PaymentState {}

final class GetAllPaymentsError extends PaymentState {
  final String e;

  GetAllPaymentsError({required this.e});
}

final class CreateSTCFirstLoading extends PaymentState {}

final class CreateSTCFirstSuccess extends PaymentState {}

final class CreateSTCFirstError extends PaymentState {
  final String e;

  CreateSTCFirstError({required this.e});
}

final class CreateSTCSecondLoading extends PaymentState {}

final class CreateSTCSecondSuccess extends PaymentState {}

final class CreateSTCSecondError extends PaymentState {
  final String e;

  CreateSTCSecondError({required this.e});
}

final class CreateCreditLoading extends PaymentState {}

final class CreateCreditSuccess extends PaymentState {}

final class CreateCreditError extends PaymentState {
  final String e;

  CreateCreditError({required this.e});
}
