import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/view_models/cart.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/checkout_screen.dart';
import 'package:sandwich_shop/views/styled_button.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final PricingRepository _pricing = PricingRepository();

  double _lineTotal(Sandwich sandwich, int qty) {
    try {
      return _pricing.calculatePrice(
          quantity: qty, isFootlong: sandwich.isFootlong);
    } catch (_) {
      return (qty * 4.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final entries = cart.items.entries.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart', style: heading1),
      ),
      body: entries.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('Your cart is empty', style: heading1),
                  SizedBox(height: 8),
                  Text('Total: £0.00', key: Key('cart-total')),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final sandwich = entries[index].key;
                      final qty = entries[index].value;
                      final line = _lineTotal(sandwich, qty);
                      final unit = qty > 0 ? line / qty : 0.0;
                      final title =
                          '${sandwich.name} — ${sandwich.breadType.name} — ${sandwich.isFootlong ? 'footlong' : 'six-inch'}';

                      return ListTile(
                        title: Text(title),
                        subtitle: Text(
                            'Unit: £${unit.toStringAsFixed(2)}  Line: £${line.toStringAsFixed(2)}',
                            key: Key('line-total-$index')),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              key: Key('dec-$index'),
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                cart.remove(sandwich, quantity: 1);
                              },
                            ),
                            Text('$qty', key: Key('qty-$index')),
                            IconButton(
                              key: Key('inc-$index'),
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                cart.add(sandwich, quantity: 1);
                              },
                            ),
                            IconButton(
                              key: Key('del-$index'),
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                final removedQty = cart.getQuantity(sandwich);
                                if (removedQty > 0) {
                                  cart.remove(sandwich, quantity: removedQty);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text('Item removed'),
                                      action: SnackBarAction(
                                        label: 'UNDO',
                                        onPressed: () {
                                          cart.add(sandwich,
                                              quantity: removedQty);
                                        },
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Cart: ${cart.countOfItems} items',
                          style: normalText),
                      Text('Total: £${cart.totalPrice.toStringAsFixed(2)}',
                          key: const Key('cart-total'), style: heading1),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: StyledButton(
                      key: const Key('checkout-btn'),
                      onPressed: _navigateToCheckout,
                      icon: Icons.payment,
                      label: 'Checkout',
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _navigateToCheckout() async {
    final cart = Provider.of<Cart>(context, listen: false);

    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(cart: cart),
      ),
    );

    if (result != null && mounted) {
      // Clear cart (will notify listeners)
      cart.clear();

      final String orderId = result['orderId'] as String? ?? '';
      final String estimatedTime = result['estimatedTime'] as String? ?? '';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Order $orderId confirmed! Estimated time: $estimatedTime'),
          duration: const Duration(seconds: 4),
          backgroundColor: Colors.green,
        ),
      );

      // Pop the cart screen to return to the previous screen (orders/home)
      Navigator.pop(context);
    }
  }
}
