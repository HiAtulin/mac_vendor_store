import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_vendor_store/controllers/order_controller.dart';
import 'package:mac_vendor_store/provider/order_provider.dart';
import 'package:mac_vendor_store/provider/total_earning_provider.dart';
import 'package:mac_vendor_store/provider/vendor_provider.dart';

class EarningsScreen extends ConsumerStatefulWidget {
  const EarningsScreen({super.key});

  @override
  ConsumerState<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends ConsumerState<EarningsScreen> {
  @override
  initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    final vendor = ref.read(vendorProvider);
    if (vendor != null) {
      final OrderController orderController = OrderController();
      try {
        final orders = await orderController.loadOrders(vendorId: vendor.id);
        ref.read(orderProvider.notifier).setOrders(orders);
        ref.read(totalEarningProvider.notifier).calculateEarnings(orders);
      } catch (e) {
        print("Error loading orders: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vendor = ref.watch(vendorProvider);
    final earnings = ref.watch(totalEarningProvider);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.purple,
              child: Text(
                vendor!.fullName[0].toUpperCase(),
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 10),
            SizedBox(
              width: 200,
              child: Text(
                "Welcome, ${vendor.fullName}",
                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Total Orders",
                style: GoogleFonts.montserrat(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                earnings['totalOrders'].toString(),
                style: GoogleFonts.montserrat(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Total Earnings",
                style: GoogleFonts.montserrat(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                '\$${earnings['totalEarnings'].toStringAsFixed(2)}',
                style: GoogleFonts.montserrat(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
