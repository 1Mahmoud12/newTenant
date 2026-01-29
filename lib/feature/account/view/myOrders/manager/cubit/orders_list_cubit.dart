import 'package:dobzz_seller/feature/account/view/myOrders/data/dataSource/orders_list_data_source.dart';
import 'package:dobzz_seller/feature/account/view/myOrders/data/models/orders_list_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'orders_list_state.dart';

class OrdersListCubit extends Cubit<OrdersListState> {
  OrdersListCubit() : super(OrdersListInitial());

  // Toggle this to use dummy data (true) or real API (false)
  static const bool useDummyData = true;

  Future<void> fetchOrders() async {
    emit(OrdersListLoading());

    // Use dummy data if flag is true
    if (useDummyData) {
      await Future.delayed(const Duration(seconds: 1)); // Simulate API delay
      emit(OrdersListSuccess(orders: _getDummyOrders()));
      return;
    }

    // Otherwise fetch from real API
    final result = await OrdersListDataSource.getOrdersList();

    result.fold(
      (failure) => emit(OrdersListError(failure.errMessage)),
      (ordersModel) {
        final orders = ordersModel.data?.data ?? [];
        emit(OrdersListSuccess(orders: orders));
      },
    );
  }

  List<OrderItem> _getDummyOrders() {
    return [
      OrderItem(
        id: 106,
        orderDate: '2024-06-12 05:04:28',
        deliveryDate: null,
        productOrderId: '8620240612050428',
        date: '2024-06-12 05:04:28',
        amount: 120.36,
        deliveryId: 0,
        deliveredStatus: 0,
        returnStatus: 0,
        rewardPoints: 12,
        themeId: 'grocery',
        demoField: 'demo_field',
        deliveredStatusString: 'Pending',
        deliveredImage: '',
        orderIdString: '#8620240612050428',
        returnDate: '2024-06-12',
        userName: 'John Doe',
      ),
      OrderItem(
        id: 107,
        orderDate: '2024-06-12 05:19:55',
        deliveryDate: '2024-06-15 10:30:00',
        productOrderId: '8620240612051955',
        date: '2024-06-12 05:19:55',
        amount: 49.98,
        deliveryId: 1,
        deliveredStatus: 1,
        returnStatus: 0,
        rewardPoints: 5,
        themeId: 'grocery',
        demoField: 'demo_field',
        deliveredStatusString: 'Delivered',
        deliveredImage: '',
        orderIdString: '#8620240612051955',
        returnDate: '2024-06-12',
        userName: 'Jane Smith',
      ),
      OrderItem(
        id: 108,
        orderDate: '2024-06-13 14:22:10',
        deliveryDate: null,
        productOrderId: '8620240613142210',
        date: '2024-06-13 14:22:10',
        amount: 85.50,
        deliveryId: 0,
        deliveredStatus: 2,
        returnStatus: 0,
        rewardPoints: 8,
        themeId: 'grocery',
        demoField: 'demo_field',
        deliveredStatusString: 'Processing',
        deliveredImage: '',
        orderIdString: '#8620240613142210',
        returnDate: '2024-06-13',
        userName: 'Mike Johnson',
      ),
      OrderItem(
        id: 109,
        orderDate: '2024-06-14 09:15:33',
        deliveryDate: null,
        productOrderId: '8620240614091533',
        date: '2024-06-14 09:15:33',
        amount: 200.75,
        deliveryId: 0,
        deliveredStatus: 3,
        returnStatus: 0,
        rewardPoints: 20,
        themeId: 'grocery',
        demoField: 'demo_field',
        deliveredStatusString: 'Shipped',
        deliveredImage: '',
        orderIdString: '#8620240614091533',
        returnDate: '2024-06-14',
        userName: 'Sarah Williams',
      ),
      OrderItem(
        id: 110,
        orderDate: '2024-06-15 16:45:12',
        deliveryDate: null,
        productOrderId: '8620240615164512',
        date: '2024-06-15 16:45:12',
        amount: 35.20,
        deliveryId: 0,
        deliveredStatus: -1,
        returnStatus: 0,
        rewardPoints: 0,
        themeId: 'grocery',
        demoField: 'demo_field',
        deliveredStatusString: 'Cancelled',
        deliveredImage: '',
        orderIdString: '#8620240615164512',
        returnDate: '2024-06-15',
        userName: 'Tom Brown',
      ),
    ];
  }
}
