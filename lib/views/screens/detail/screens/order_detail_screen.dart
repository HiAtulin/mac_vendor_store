import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mac_vendor_store/controllers/order_controller.dart';
import 'package:mac_vendor_store/models/order.dart';
import 'package:mac_vendor_store/provider/order_provider.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  final Order order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  final OrderController orderController = OrderController();
  late Order currentOrder;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    currentOrder = widget.order;
    _loadOrderDetails();
  }

  Future<void> _loadOrderDetails() async {
    try {
      // 这里可以添加从API获取最新订单数据的逻辑
      // 暂时使用传递过来的订单数据
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error loading order details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(orderProvider);
    final updatedOrder = orders.firstWhere(
      (element) => element.id == currentOrder.id,
      orElse: () => currentOrder,
    );
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Order Detail')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          currentOrder.productName,
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: 335,
            height: 153,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(),
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    child: Container(
                      width: 336,
                      height: 154,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Color(0xFFEFF0F2)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            left: 13,
                            top: 9,
                            child: Container(
                              width: 78,
                              height: 78,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: Color(0xFFBCC5FF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Stack(
                                clipBehavior: Clip.antiAlias,
                                children: [
                                  Positioned(
                                    left: 10,
                                    top: 5,
                                    child: currentOrder.image.isNotEmpty
                                        ? Image.network(
                                            currentOrder.image,
                                            width: 58,
                                            height: 67,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Icon(
                                                    Icons.image_not_supported,
                                                    size: 40,
                                                  );
                                                },
                                          )
                                        : Icon(Icons.image, size: 40),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 101,
                            top: 14,
                            child: SizedBox(
                              width: 216,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: double.infinity,
                                            child: Text(
                                              currentOrder.productName,
                                              style: GoogleFonts.montserrat(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF222222),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              currentOrder.category,
                                              style: GoogleFonts.montserrat(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF222222),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            "\$${currentOrder.productPrice.toStringAsFixed(2)}",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF222222),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 13,
                            top: 113,
                            child: Container(
                              width: 100,
                              height: 25,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: updatedOrder.delivered == true
                                    ? Color(0xFF3C55EF)
                                    : updatedOrder.processing == true
                                    ? Colors.purple
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    left: 9,
                                    top: 2,
                                    child: Text(
                                      updatedOrder.delivered == true
                                          ? "Delivered"
                                          : updatedOrder.processing == true
                                          ? "Processing"
                                          : "Cancelled",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        letterSpacing: 1.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 115,
                            left: 298,
                            child: InkWell(
                              onTap: () async {
                                await orderController.deleteOrder(
                                  orderId: currentOrder.id,
                                  context: context,
                                );
                                Navigator.pop(context);
                              },
                              child: Image.asset(
                                'assets/icons/delete.png',
                                width: 20,
                                height: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              width: 336,
              height: 170,
              decoration: BoxDecoration(
                color: Color(0xFFF7F7F7),
                border: Border.all(color: Color(0xFFEFF0F2), width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivery Address',
                          style: GoogleFonts.montserrat(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF222222),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "${currentOrder.state} ${currentOrder.city} ${currentOrder.locality}",
                          style: GoogleFonts.lato(
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "To : ${currentOrder.fullName}",
                          style: GoogleFonts.roboto(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Order ID : ${currentOrder.id}",
                          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed:
                            updatedOrder.delivered ||
                                updatedOrder.processing == false
                            ? null
                            : () async {
                                await orderController
                                    .updateDeliveryStatus(
                                      id: updatedOrder.id,
                                      context: context,
                                    )
                                    .whenComplete(() {
                                      ref
                                          .read(orderProvider.notifier)
                                          .updateOrder(
                                            currentOrder.id,
                                            delivered: true,
                                          );
                                    });
                                setState(() {
                                  currentOrder = Order(
                                    id: currentOrder.id,
                                    fullName: currentOrder.fullName,
                                    email: currentOrder.email,
                                    state: currentOrder.state,
                                    city: currentOrder.city,
                                    locality: currentOrder.locality,
                                    productName: currentOrder.productName,
                                    productPrice: currentOrder.productPrice,
                                    quantity: currentOrder.quantity,
                                    category: currentOrder.category,
                                    image: currentOrder.image,
                                    buyerId: currentOrder.buyerId,
                                    vendorId: currentOrder.vendorId,
                                    processing: currentOrder.processing,
                                    delivered: true,
                                  );
                                });
                              },
                        child: Text(
                          updatedOrder.delivered
                              ? "Delivered"
                              : "Mark as Delivered?",
                          style: GoogleFonts.montserrat(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      TextButton(
                        onPressed:
                            updatedOrder.processing == false ||
                                updatedOrder.delivered
                            ? null
                            : () async {
                                await orderController
                                    .cancelOrder(
                                      id: currentOrder.id,
                                      context: context,
                                    )
                                    .whenComplete(() {
                                      ref
                                          .read(orderProvider.notifier)
                                          .updateOrder(
                                            currentOrder.id,
                                            processing: false,
                                          );
                                    });
                                setState(() {
                                  currentOrder = Order(
                                    id: currentOrder.id,
                                    fullName: currentOrder.fullName,
                                    email: currentOrder.email,
                                    state: currentOrder.state,
                                    city: currentOrder.city,
                                    locality: currentOrder.locality,
                                    productName: currentOrder.productName,
                                    productPrice: currentOrder.productPrice,
                                    quantity: currentOrder.quantity,
                                    category: currentOrder.category,
                                    image: currentOrder.image,
                                    buyerId: currentOrder.buyerId,
                                    vendorId: currentOrder.vendorId,
                                    processing: false,
                                    delivered: currentOrder.delivered,
                                  );
                                });
                              },
                        child: Text(
                          updatedOrder.processing == false
                              ? "Cancelled"
                              : "Cancel",
                          style: GoogleFonts.montserrat(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
