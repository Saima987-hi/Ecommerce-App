import 'package:flutter/material.dart';

class CheckoutPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final List<bool> selectedItems;
  final VoidCallback onOrderConfirmed;
  final VoidCallback onBackToCart;
  final VoidCallback onNavigateToHome;

  const CheckoutPage({
    super.key,
    required this.cartItems,
    required this.selectedItems,
    required this.onOrderConfirmed,
    required this.onBackToCart,
    required this.onNavigateToHome,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedPaymentMethod = 'cash';

  int get selectedTotalAmount {
    int total = 0;
    for (int i = 0; i < widget.cartItems.length; i++) {
      if (widget.selectedItems[i]) {
        var item = widget.cartItems[i];
        total += (item["price"] as int) * (item["qty"] as int);
      }
    }
    return total;
  }

  int get selectedCount => widget.selectedItems.where((e) => e).length;

  void _placeOrder() {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Order"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Are you sure you want to place this order?"),
            const SizedBox(height: 10),
            Text("Name: ${_nameController.text}"),
            Text("Phone: ${_phoneController.text}"),
            Text("Address: ${_addressController.text}"),
            Text("Payment: ${_selectedPaymentMethod == 'cash' ? 'Cash on Delivery' : 'Online Payment'}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onOrderConfirmed();
            ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Order placed successfully!",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          "Payment: ${_selectedPaymentMethod == 'cash' ? 'Cash on Delivery' : 'Online Payment'}",
          style: const TextStyle(fontSize: 14),
        ),
      ],
    ),
    backgroundColor: Colors.lightBlue, 
    duration: const Duration(seconds: 3),
  ),
);

            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: widget.onBackToCart,
        ),
        title: const Text("Checkout"),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Order Summary",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Items:", style: TextStyle(fontSize: 16, color: Colors.grey.shade700)),
                            Text("$selectedCount items", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total Amount:", style: TextStyle(fontSize: 16, color: Colors.grey.shade700)),
                            Text("¥ $selectedTotalAmount", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.lightBlue)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Customer Details",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.lightBlue),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: "Full Name", prefixIcon: Icon(Icons.person)),
                          validator: (value) => value!.isEmpty ? "Enter name" : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(labelText: "Phone Number", prefixIcon: Icon(Icons.phone)),
                          keyboardType: TextInputType.phone,
                          validator: (value) => value!.isEmpty ? "Enter phone number" : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _addressController,
                          decoration: const InputDecoration(labelText: "Delivery Address", prefixIcon: Icon(Icons.location_on)),
                          maxLines: 2,
                          validator: (value) => value!.isEmpty ? "Enter address" : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Payment Method", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.lightBlue)),
                        const SizedBox(height: 12),
                        RadioListTile<String>(
                          value: 'cash',
                          groupValue: _selectedPaymentMethod,
                          onChanged: (value) => setState(() => _selectedPaymentMethod = value!),
                          title: const Text("Cash on Delivery"),
                          secondary: const Icon(Icons.money),
                        ),
                        RadioListTile<String>(
                          value: 'online',
                          groupValue: _selectedPaymentMethod,
                          onChanged: (value) => setState(() => _selectedPaymentMethod = value!),
                          title: const Text("Online Payment"),
                          secondary: const Icon(Icons.payment),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              
              if (selectedCount > 0)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _placeOrder,
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: const Text("Place Order", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
