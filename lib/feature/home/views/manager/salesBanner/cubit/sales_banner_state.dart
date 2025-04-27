part of 'sales_banner_cubit.dart';

@immutable
sealed class SalesBannerState {}

final class SalesBannerInitial extends SalesBannerState {}

final class SalesBannerLoading extends SalesBannerState {}

final class SalesBannerSuccess extends SalesBannerState {}

final class SalesBannerError extends SalesBannerState {
  final String e;

  SalesBannerError({required this.e});
}
