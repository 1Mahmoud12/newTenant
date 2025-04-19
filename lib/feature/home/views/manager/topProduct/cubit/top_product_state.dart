part of 'top_product_cubit.dart';

@immutable
sealed class TopProductState {}

final class TopProductInitial extends TopProductState {}

final class TopProductLoading extends TopProductState {}

final class TopProductSuccess extends TopProductState {}

final class TopProductError extends TopProductState {
  final String e;

  TopProductError({required this.e});
}
