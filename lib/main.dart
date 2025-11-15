import 'package:flutter/material.dart';
import 'views/app_styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Sandwich Shop',
      home: OrderScreen(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}

class OrderItemDisplay extends StatelessWidget {
  final String itemType;
  final int quantity;
  final String note;

  const OrderItemDisplay(this.quantity, this.itemType, this.note, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
            // color: Colors.blue,
            // height: 100,
            // width: 300,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    '$quantity $itemType sandwich(es): ${List.filled(quantity, '🥪').join()}'),
                if (note.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('Note: $note',
                        style: const TextStyle(fontStyle: FontStyle.italic)),
                  ),
              ],
            )),
      ],
    );
  }
}

class OrderScreen extends StatefulWidget {
  final int maxQuantity;

  const OrderScreen({super.key, this.maxQuantity = 10});

  @override
  State<OrderScreen> createState() {
    return _OrderScreenState();
  }
}

class _OrderScreenState extends State<OrderScreen> {
  int _quantity = 0;
  String _note = '';
  String _selctedSize = 'Footlong';

  static const List<String> _sizes = <String>['6-inch', 'Footlong'];

  void _increaseQuantity() {
    if (_quantity < widget.maxQuantity) {
      setState(() => _quantity++);
    }
    if (_quantity == 10) {
      setState(() => _note = 'Maximum quantity reached');
    }
  }

  void _decreaseQuantity() {
    if (_quantity > 0) {
      setState(() => _quantity--);
    }
    if (_quantity == 0) {
      setState(() => _note = 'cannot go below zero');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sandwich counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Add a note to your order',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _note = value;
                  });
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: DropdownButton<String>(
                value: _selctedSize,
                items: _sizes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selctedSize = newValue!;
                  });
                },
              ),
            ),
            OrderItemDisplay(
              _quantity,
              'Footlong',
              _note,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: StyledButton(
                    onPressed: _quantity < widget.maxQuantity
                        ? _increaseQuantity
                        : null,
                    icon: Icons.add,
                    label: 'Add',
                  ),
                ),
                SizedBox(
                  child: StyledButton(
                    onPressed: _quantity > 0 ? _decreaseQuantity : null,
                    icon: Icons.remove,
                    label: 'Remove',
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

class StyledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;

  const StyledButton(
      {super.key, this.onPressed, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.grey,
        disabledForegroundColor: Colors.black38,
      ),
      icon: Icon(icon),
      label: Text(label),
    );
  }
}

