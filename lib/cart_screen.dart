import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:havaizaada_marketplace/features/product/presentation/bloc/product_bloc.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 250, 225, 235),
      appBar: AppBar(title: Text("Shopping Cart")),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoaded && state.cart.isNotEmpty) {
            // Group products by their unique ID
            final Map<String, Map<String, dynamic>> groupedCart = {};
            state.cart.forEach((product) {
              final productId = product['id'].toString();
              if (groupedCart.containsKey(productId)) {
                groupedCart[productId]!['quantity']++;
              } else {
                groupedCart[productId] = {
                  'product': product,
                  'quantity': 1,
                };
              }
            });

            double totalPrice = 0;
            final cartItems = groupedCart.values.toList();

            // Calculate the total price
            cartItems.forEach((item) {
              final discountedPrice = item['product']['price'] *
                  (1 - item['product']['discountPercentage'] / 100);
              totalPrice += discountedPrice * item['quantity'];
            });

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      final product = item['product'];
                      final quantity = item['quantity'];
                      final discountedPrice = (product['price'] *
                              (1 - product['discountPercentage'] / 100))
                          .toStringAsFixed(2);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            // Product Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                product['thumbnail'],
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 12),
                            // Product Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['title'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    product['brand'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        "₹${product['price']}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "₹${discountedPrice}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "${product['discountPercentage']}% OFF",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 12),
                            // Quantity Controls
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    if (quantity > 1) {
                                      // Update the cart quantity by decreasing it
                                      context.read<ProductBloc>().add(
                                            RemoveFromCart(product),
                                          );
                                    } else {
                                      // Remove the product from cart if quantity reaches 0
                                      context.read<ProductBloc>().add(
                                            UpdateCartQuantity(product, 0),
                                          );
                                    }
                                  },
                                ),
                                Text("$quantity"),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    // Update the cart quantity by increasing it
                                    context.read<ProductBloc>().add(
                                          AddToCart(product),
                                        );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Total Price fixed at the bottom
                Container(
                  padding: EdgeInsets.all(16),
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Total text and total price in a column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Amount Price",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.normal),
                          ),
                          Text(
                            "\₹${totalPrice.toStringAsFixed(2)}",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      // Checkout button on the right
                      ElevatedButton(
                        onPressed: () {
                          // Handle checkout logic
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 230, 30, 95),
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize
                              .min, // Makes the button adapt to its content size
                          children: [
                            Text(
                              "Checkout",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                "${cartItems.fold<int>(0, (sum, item) => sum + (item['quantity'] as int))}",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 230, 30, 95),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return Center(child: Text("Cart is empty."));
        },
      ),
    );
  }
}
