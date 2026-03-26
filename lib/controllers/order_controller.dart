import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mac_vendor_store/global_variables.dart';
import 'package:mac_vendor_store/models/order.dart';
import 'package:mac_vendor_store/services/manage_http_response.dart';

class OrderController {
  Future<List<Order>> loadOrders({required String vendorId}) async {
    try {
      http.Response response = await http.get(
        Uri.parse('$uri/api/orders/vendors/$vendorId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Order> orders = data
            .map((order) => Order.fromJson(order))
            .toList();
        return orders;
      } else {
        throw Exception("Failed loading orders");
      }
    } catch (e) {
      throw Exception("Error loading orders");
    }
  }

  Future<void> deleteOrder({required String orderId, required context}) async {
    try {
      http.Response response = await http.delete(
        Uri.parse('$uri/api/orders/$orderId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, "Order deleted successfully");
        },
      );
    } catch (e) {
      showSnackBar(context, "Error deleting order $e");
    }
  }

  Future<void> updateDeliveryStatus({
    required String id,
    required context,
  }) async {
    try {
      http.Response response = await http.patch(
        Uri.parse('$uri/api/orders/$id/delivered'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'delivered': true, 'processing': false}),
      );
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, "Order delivered successfully");
        },
      );
    } catch (e) {
      showSnackBar(context, "Error updating delivery status $e");
    }
  }

  Future<void> cancelOrder({required String id, required context}) async {
    try {
      http.Response response = await http.patch(
        Uri.parse('$uri/api/orders/$id/processing'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'processing': false, 'delivered': false}),
      );
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, "Order canceled successfully");
        },
      );
    } catch (e) {
      showSnackBar(context, "Error updating processing status $e");
    }
  }
}
