part of 'order_details_cubit.dart';

abstract class OrderDetailsState {}

class OrderDetailsInitial extends OrderDetailsState {}

class OrderDetailsLoading extends OrderDetailsState {}

class OrderDetailsSuccess extends OrderDetailsState {
  final OrderDetailData order;

  OrderDetailsSuccess(this.order);
}

class OrderDetailsError extends OrderDetailsState {
  final String error;

  OrderDetailsError(this.error);
}
