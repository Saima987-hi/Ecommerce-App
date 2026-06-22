import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  final Function(Map<String, dynamic>) onAddToCart;
  final VoidCallback onNavigateToCart;

  const HomePage({
    super.key,
    required this.cart,
    required this.onAddToCart,
    required this.onNavigateToCart,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> clothingProducts = [
    {"name": "Casual T-Shirt", "price": 1200, "img": "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500", },
    {"name": "Denim Jacket", "price": 4500, "img": "https://images.unsplash.com/photo-1495105787522-5334e3ffa0ef?w=500", },
    {"name": "Formal Shirt", "price": 2500, "img": "https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=500",},
    {"name": "Summer Dress", "price": 3800, "img": "https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=500", },
    {"name": "Hoodie", "price": 3200, "img": "https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=500",},
    {"name": "Leather Jacket", "price": 8900, "img": "https://images.unsplash.com/photo-1551028719-00167b16eac5?w=500",},
    {"name": "Cord Set","price": 2999, "img": "https://images.pexels.com/photos/6311397/pexels-photo-6311397.jpeg?w=500",},
    {"name": "Office Wear", "price": 3100, "img": "https://images.unsplash.com/photo-1517445312882-bc9910d016b7?w=500",},
    {"name": "Winter Coat", "price": 9500, "img": "https://images.unsplash.com/photo-1539533018447-63fcce2678e3?w=500",},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.home, color: Colors.white),
        title: const Text("Fashion Store",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: widget.onNavigateToCart,
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(4),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: 1.1,
        ),
        itemCount: clothingProducts.length,
        itemBuilder: (context, i) {
          final p = clothingProducts[i];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 10,
                  child: Image.network(
                    p['img'],
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade100,
                        child: const Icon(Icons.broken_image, color: Colors.grey),
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("¥${p['price']}",
                                style: const TextStyle(fontSize: 14, color: Colors.blue, fontWeight: FontWeight.bold)),
                            GestureDetector(
                              onTap: () {
                                widget.onAddToCart(Map<String, dynamic>.from(p)..addAll({"qty": 1}));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("${p['name']} added to cart!"),
                                    duration: const Duration(seconds: 1),
                                    backgroundColor: Colors.lightBlue,
                                  ),
                                );
                              },
                              child: const Icon(Icons.add_circle, size: 32, color: Colors.lightBlue),
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
        },
      ),
    );
  }
}