part of 'discount_cubit.dart';

@immutable
sealed class DiscountState {}

final class DiscountInitial extends DiscountState {}

final class DiscountLoading extends DiscountState {}

final class DiscountSuccess extends DiscountState {}

final class DiscountError extends DiscountState {
  final String e;
  DiscountError({required this.e});
}
