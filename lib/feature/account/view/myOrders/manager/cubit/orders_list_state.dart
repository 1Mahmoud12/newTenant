part of 'orders_list_cubit.dart';

sealed class OrdersListState {}

class OrdersListInitial extends OrdersListState {}

class OrdersListLoading extends OrdersListState {}

class OrdersListSuccess extends OrdersListState {
  final List<OrderItem> orders;

  OrdersListSuccess({required this.orders});
}

class OrdersListError extends OrdersListState {
  final String message;

  OrdersListError(this.message);
}
