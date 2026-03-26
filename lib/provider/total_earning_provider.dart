import 'package:flutter_riverpod/legacy.dart';
import 'package:mac_vendor_store/models/order.dart';

class TotalEarningProvider extends StateNotifier<Map<String, dynamic>> {
  TotalEarningProvider() : super({'totalEarnings': 0.0, 'totalOrders': 0});
  void calculateEarnings(List<Order> orders) {
    double earnings = 0.0;
    int orderCount = 0;
    for (Order order in orders) {
      if (order.delivered) {
        earnings += order.productPrice * order.quantity;
        orderCount++;
      }
    }
    state = {'totalEarnings': earnings, 'totalOrders': orderCount};
  }
}

final totalEarningProvider =
    StateNotifierProvider<TotalEarningProvider, Map<String, dynamic>>(
      (ref) => TotalEarningProvider(),
    );
