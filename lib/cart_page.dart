import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final List<bool> selectedItems;
  final Function(List<Map<String, dynamic>>, List<bool>) onUpdateCart;
  final VoidCallback onNavigateToHome;
  final VoidCallback onNavigateToCheckout;

  const CartPage({
    super.key,
    required this.cartItems,
    required this.selectedItems,
    required this.onUpdateCart,
    required this.onNavigateToHome,
    required this.onNavigateToCheckout,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<Map<String, dynamic>> _cartItems;
  late List<bool> _selectedItems;

  @override
  void initState() {
    super.initState();
    _cartItems = List.from(widget.cartItems);
    _selectedItems = List.from(widget.selectedItems);
  }

  int get selectedTotalAmount {
    int total = 0;
    for (int i = 0; i < _cartItems.length; i++) {
      if (_selectedItems[i]) {
        var item = _cartItems[i];
        total += (item["price"] as int) * (item["qty"] as int);
      }
    }
    return total;
  }

  int get selectedCount {
    return _selectedItems.where((element) => element).length;
  }

  void toggleSelection(int index) {
    setState(() {
      _selectedItems[index] = !_selectedItems[index];
    });
    widget.onUpdateCart(_cartItems, _selectedItems);
  }

  void selectAll() {
    setState(() {
      for (int i = 0; i < _selectedItems.length; i++) {
        _selectedItems[i] = true;
      }
    });
    widget.onUpdateCart(_cartItems, _selectedItems);
  }

  void deselectAll() {
    setState(() {
      for (int i = 0; i < _selectedItems.length; i++) {
        _selectedItems[i] = false;
      }
    });
    widget.onUpdateCart(_cartItems, _selectedItems);
  }

  void updateQuantity(int index, int change) {
    setState(() {
      var item = _cartItems[index];
      int newQty = (item["qty"] as int) + change;
      
      if (newQty < 1) {
        _cartItems.removeAt(index);
        _selectedItems.removeAt(index);
      } else {
        item["qty"] = newQty;
      }
    });
    widget.onUpdateCart(_cartItems, _selectedItems);
  }

  void removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
      _selectedItems.removeAt(index);
    });
    widget.onUpdateCart(_cartItems, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: widget.onNavigateToHome,
        ),
        title: const Text("My Cart"),
        centerTitle: true,
        actions: [
          if (selectedCount > 0)
            IconButton(
              icon: const Icon(Icons.payment, color: Colors.white),
              onPressed: widget.onNavigateToCheckout,
            ),
        ],
      ),
      body: Column(
        children: [
          if (_cartItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: selectAll,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue.shade100,
                      foregroundColor: Colors.lightBlue.shade800,
                    ),
                    child: const Text("Select All"),
                  ),
                  ElevatedButton(
                    onPressed: deselectAll,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue.shade100,
                      foregroundColor: Colors.lightBlue.shade800,
                    ),
                    child: const Text("Deselect All"),
                  ),
                ],
              ),
            ),
          Expanded(
            child: _cartItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 80,
                          color: Colors.lightBlue.shade200,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Your cart is empty",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: widget.onNavigateToHome,
                          child: const Text("Continue Shopping"),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      var item = _cartItems[index];
                      int itemTotal = (item["price"] as int) * (item["qty"] as int);

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        color: _selectedItems[index] ? Colors.lightBlue.shade50 : Colors.white,
                        child: ListTile(
                          leading: Checkbox(
                            value: _selectedItems[index],
                            onChanged: (value) {
                              toggleSelection(index);
                            },
                          ),
                          title: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  item["img"] as String,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 50,
                                      height: 50,
                                      color: Colors.grey.shade200,
                                      child: const Icon(Icons.image, color: Colors.grey),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  item["name"] as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("¥ ${item["price"]} each"),
                              Text(
                                "Total: ¥ $itemTotal",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.lightBlue.shade700,
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, color: Colors.blue),
                                onPressed: () => updateQuantity(index, -1),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.lightBlue.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "${item["qty"]}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add, color: Colors.blue),
                                onPressed: () => updateQuantity(index, 1),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => removeItem(index),
                              ),
                            ],
                          ),
                          onTap: () {
                            toggleSelection(index);
                          },
                        ),
                      );
                    },
                  ),
          ),
          if (_cartItems.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.lightBlue.shade50,
                border: Border(
                  top: BorderSide(color: Colors.lightBlue.shade100),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Selected: $selectedCount/${_cartItems.length}",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.lightBlue.shade800,
                        ),
                      ),
                      Text(
                        "Total: ¥ $selectedTotalAmount",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlue.shade800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: selectedCount > 0
                          ? widget.onNavigateToCheckout
                          : null,
                      child: Text(
                        selectedCount > 0
                            ? "Checkout ($selectedCount items)"
                            : "Select items to checkout",
                      ),
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
