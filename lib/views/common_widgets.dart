import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/view_models/cart.dart';
import 'package:sandwich_shop/views/cart_screen.dart';
import 'package:sandwich_shop/views/app_styles.dart';

class Logo extends StatelessWidget {
  final double height;
  const Logo({Key? key, this.height = 56}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: height,
        child: Image.asset('assets/images/logo.png'),
      ),
    );
  }
}

class CartIndicator extends StatelessWidget {
  final bool showCount;
  const CartIndicator({Key? key, this.showCount = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.shopping_cart),
                if (showCount) const SizedBox(width: 4),
                if (showCount) Text('${cart.countOfItems}'),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final double logoHeight;

  const CommonAppBar({Key? key, required this.title, this.actions, this.logoHeight = 56}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Logo(height: logoHeight),
      title: Text(title, style: AppStyles.heading1),
      actions: actions ?? [const CartIndicator()],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
