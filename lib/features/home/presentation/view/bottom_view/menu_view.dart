import 'package:flutter/material.dart';
import 'package:orenda/app/constants/api_endpoints.dart';
import 'package:orenda/core/network/api_service.dart';
import 'package:orenda/core/service_locator.dart';

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  final ApiService _apiService = locator<ApiService>();
  List<Map<String, dynamic>> _products = [];
  final Map<String, int> _cart = {};
  bool _isLoading = true;
  bool _hasError = false;

  Widget _buildTextContent(String text) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final products = await _apiService.fetchProducts();
      setState(() {
        _products = products
            .map((item) => {
                  "id": item["_id"],
                  "name": item["name"],
                  "description": item["description"],
                  "price": item["price"],
                  "image":
                      "${ApiEndpoints.imageUrl}${item["imagePath"].split('/').last}",
                })
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  void _increaseQuantity(String productId) {
    setState(() {
      _cart[productId] = (_cart[productId] ?? 0) + 1;
    });
  }

  void _decreaseQuantity(String productId) {
    setState(() {
      if (_cart.containsKey(productId) && _cart[productId]! > 1) {
        _cart[productId] = _cart[productId]! - 1;
      } else {
        _cart.remove(productId);
      }
    });
  }

  Future<void> _placeOrder() async {
    if (_cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select at least one item to order."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    List<Map<String, dynamic>> orderItems = _cart.entries
        .map((entry) => {"productId": entry.key, "quantity": entry.value})
        .toList();

    try {
      await _apiService.placeOrder({"items": orderItems});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Order placed successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        _cart.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error placing order: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: SizedBox(
            height: 65,
            child: Image.asset(
              'assets/images/dark-theme-logo.jpg',
              fit: BoxFit.contain,
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.all_inbox), text: 'All'),
              Tab(icon: Icon(Icons.fastfood), text: 'Foods'),
              Tab(icon: Icon(Icons.local_cafe), text: 'Beverages'),
              Tab(icon: Icon(Icons.table_bar), text: 'Table - 7'),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.white,
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              _buildContent(context),
              _buildTextContent('Displaying foods'),
              _buildTextContent('Displaying beverages'),
              _buildTextContent('Displaying table - 7'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    final gridCardHeight = screenSize.height * (isTablet ? 0.45 : 0.36);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError) {
      return const Center(
          child: Text("Failed to load products",
              style: TextStyle(color: Colors.white)));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            onTap: _placeOrder,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 18.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6A1B9A), Color(0xFFE91E63)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pinkAccent.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'Place Order',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isTablet ? 4 : 2,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                    childAspectRatio: screenSize.width /
                        (gridCardHeight * (isTablet ? 4 : 2)),
                  ),
                  itemBuilder: (context, index) {
                    return _buildMenuItemCard(
                        _products[index], isTablet, gridCardHeight);
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItemCard(
      Map<String, dynamic> item, bool isTablet, double gridCardHeight) {
    String productId = item["id"];
    int quantity = _cart[productId] ?? 0;

    return Card(
      color: const Color.fromARGB(255, 9, 9, 9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.network(
              item["image"] as String,
              height: isTablet ? gridCardHeight * 0.6 : gridCardHeight * 0.5,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error, color: Colors.red),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item["name"] as String,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              item["description"] as String,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Rs. ${item["price"]}",
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                quantity == 0
                    ? GestureDetector(
                        onTap: () => _increaseQuantity(productId),
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(Icons.add,
                              color: Colors.black, size: 20),
                        ),
                      )
                    : Container(
                        height: 35,
                        width: 90,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 25,
                              height: 30,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: const Icon(Icons.remove,
                                    color: Colors.black, size: 18),
                                onPressed: () => _decreaseQuantity(productId),
                              ),
                            ),
                            SizedBox(
                              width: 30,
                              child: Center(
                                child: Text(
                                  "$quantity",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 25,
                              height: 30,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: const Icon(Icons.add,
                                    color: Colors.black, size: 18),
                                onPressed: () => _increaseQuantity(productId),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
