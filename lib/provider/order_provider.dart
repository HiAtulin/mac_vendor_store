

import 'package:flutter_riverpod/legacy.dart';
import 'package:mac_vendor_store/models/order.dart';

class OrderProvider extends StateNotifier<List<Order>> {
  OrderProvider() : super([]);
  void setOrders(List<Order> orders) {
    state = orders;
  }
}


final orderProvider = StateNotifierProvider<OrderProvider, List<Order>>(
  (ref) => OrderProvider(),
);