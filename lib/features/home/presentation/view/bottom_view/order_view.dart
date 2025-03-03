import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orenda/core/network/api_service.dart';
import 'package:orenda/core/service_locator.dart';

class OrderView extends StatefulWidget {
  const OrderView({super.key});

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  final ApiService _apiService = locator<ApiService>();
  List<Map<String, dynamic>> _orders = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      final orders = await _apiService.getOrders();
      List<Map<String, dynamic>> filteredOrders =
          orders.where((order) => order["status"] == "Completed").toList();

      setState(() {
        _orders = filteredOrders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  String _formatDate(String timestamp) {
    try {
      final utcDateTime = DateTime.parse(timestamp).toUtc();
      final nepalTime = utcDateTime.add(const Duration(hours: 5, minutes: 45));

      return DateFormat('dd MMM yyyy, hh:mm a').format(nepalTime);
    } catch (e) {
      return "Invalid date";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Completed Orders"),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? const Center(
                  child: Text(
                    "Failed to load orders",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : _orders.isEmpty
                  ? const Center(
                      child: Text(
                        "No completed orders found",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: _orders.length,
                      itemBuilder: (context, index) {
                        return _buildOrderCard(_orders[index]);
                      },
                    ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order ID: ${order["_id"]}",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "Placed on: ${_formatDate(order["createdAt"])}",
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            Column(
              children: List.generate(
                order["items"].length,
                (i) {
                  final item = order["items"][i];
                  return ListTile(
                    leading: const Icon(Icons.fastfood, color: Colors.white70),
                    title: Text(
                      "${item["productId"]["name"]}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "Quantity: ${item["quantity"]}",
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: Text(
                      "Rs. ${item["productId"]["price"]}",
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(color: Colors.grey),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total: Rs. ${order["totalPrice"]}",
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Completed",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
