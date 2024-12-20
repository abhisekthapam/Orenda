import 'package:flutter/material.dart';
import 'package:orenda/views/theme_provider.dart';
import 'package:provider/provider.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final backgroundColor =
        themeProvider.isDarkMode ? Colors.grey[900] : Colors.white;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: SizedBox(
            height: 65,
            child: Image(
              image: AssetImage(
                Theme.of(context).brightness == Brightness.dark
                    ? 'assets/images/dark-theme-logo.jpg'
                    : 'assets/images/light-theme-logo.jpg',
              ),
              fit: BoxFit.contain,
            ),
          ),
          bottom: TabBar(
            tabs: const [
              Tab(icon: Icon(Icons.all_inbox), text: 'All'),
              Tab(icon: Icon(Icons.fastfood), text: 'Foods'),
              Tab(icon: Icon(Icons.local_cafe), text: 'Beverages'),
              Tab(icon: Icon(Icons.table_bar), text: 'Table - 7'),
            ],
            labelColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final gridCardHeight = screenHeight * (isTablet ? 0.45 : 0.36);

    final themeProvider = Provider.of<ThemeProvider>(context);

    return SingleChildScrollView(
      child: Container(
        color: themeProvider.isDarkMode ? Colors.black : Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.width > 600
                          ? gridCardHeight * 1.52
                          : gridCardHeight * 1,
                      width: double.infinity,
                      child: Image.asset(
                        'assets/images/special.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Today's Special",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Rich, comforting, hearty, aromatic.',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 10,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: screenWidth > 600 ? 4 : 2,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                  childAspectRatio: screenWidth /
                      (gridCardHeight * (screenWidth > 600 ? 4 : 2)),
                ),
                itemBuilder: (context, index) {
                  final List<Map<String, dynamic>> items = [
                    {
                      "image": "assets/images/burger.jpg",
                      "name": "Burger",
                      "description":
                          "Juicy, flavorful, hearty, satisfying, delicious.",
                      "price": 250
                    },
                    {
                      "image": "assets/images/steak.jpg",
                      "name": "Steak",
                      "description":
                          "Tender, savory, grilled, juicy, exquisite.",
                      "price": 1100
                    },
                    {
                      "image": "assets/images/sushi.jpg",
                      "name": "Sushi",
                      "description":
                          "Fresh, delicate, flavorful, artistic, refined.",
                      "price": 750
                    },
                    {
                      "image": "assets/images/ramen.jpg",
                      "name": "Ramen",
                      "description":
                          "Cheesy, savory, crispy, flavorful, satisfying.",
                      "price": 350
                    },
                    {
                      "image": "assets/images/salad.jpg",
                      "name": "Salad",
                      "description":
                          "Juicy, flavorful, hearty, satisfying, delicious.",
                      "price": 550
                    },
                    {
                      "image": "assets/images/sandwich.jpg",
                      "name": "Sandwich",
                      "description":
                          "Tender, savory, grilled, juicy, exquisite.",
                      "price": 200
                    },
                    {
                      "image": "assets/images/spaghetti.jpg",
                      "name": "Spaghetti",
                      "description":
                          "Fresh, delicate, flavorful, artistic, refined.",
                      "price": 150
                    },
                    {
                      "image": "assets/images/tacos.jpg",
                      "name": "Tacos",
                      "description":
                          "Cheesy, savory, crispy, flavorful, satisfying.",
                      "price": 350
                    },
                    {
                      "image": "assets/images/soup.jpg",
                      "name": "Soup",
                      "description":
                          "Cheesy, savory, crispy, flavorful, satisfying.",
                      "price": 350
                    },
                    {
                      "image": "assets/images/hotdog.jpg",
                      "name": "Hotdog",
                      "description":
                          "Cheesy, savory, crispy, flavorful, satisfying.",
                      "price": 350
                    },
                  ];

                  final Map<String, dynamic> item = items[index];

                  return Card(
                    color: themeProvider.isDarkMode
                        ? const Color.fromARGB(255, 9, 9, 9)
                        : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                          child: Image.asset(
                            item["image"] as String,
                            height: isTablet
                                ? gridCardHeight * 0.6
                                : gridCardHeight * 0.5,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            item["name"] as String,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            item["description"] as String,
                            style: TextStyle(
                              fontSize: 12,
                              color: themeProvider.isDarkMode
                                  ? Colors.white70
                                  : Colors.grey,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  "Rs. ${item["price"]}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: themeProvider.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: themeProvider.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                padding: const EdgeInsets.all(6),
                                child: Icon(
                                  Icons.add,
                                  color: themeProvider.isDarkMode
                                      ? Colors.black
                                      : Colors.white,
                                  size: 19,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextContent(String text) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
