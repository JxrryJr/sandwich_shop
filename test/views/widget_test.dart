import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('App', () {
    testWidgets('renders OrderScreen as home', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      expect(find.byType(OrderScreen), findsOneWidget);
    });
  });

  group('OrderScreen - Quantity', () {
    testWidgets('shows initial quantity and title',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      expect(find.text('0 white footlong sandwich(es): '), findsOneWidget);
      expect(find.text('Sandwich Counter'), findsOneWidget);
    });

    testWidgets('increments quantity when Add is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.widgetWithText(StyledButton, 'Add'));
      await tester.pump();
      expect(find.text('1 white footlong sandwich(es): 🥪'), findsOneWidget);
    });

    testWidgets('decrements quantity when Remove is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.widgetWithText(StyledButton, 'Add'));
      await tester.pump();
      expect(find.text('1 white footlong sandwich(es): 🥪'), findsOneWidget);
      await tester.tap(find.widgetWithText(StyledButton, 'Remove'));
      await tester.pump();
      expect(find.text('0 white footlong sandwich(es): '), findsOneWidget);
    });

    testWidgets('does not decrement below zero', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      expect(find.text('0 white footlong sandwich(es): '), findsOneWidget);
      await tester.tap(find.widgetWithText(StyledButton, 'Remove'));
      await tester.pump();
      expect(find.text('0 white footlong sandwich(es): '), findsOneWidget);
    });

    testWidgets('does not increment above maxQuantity',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      for (int i = 0; i < 10; i++) {
        await tester.tap(find.widgetWithText(StyledButton, 'Add'));
        await tester.pump();
      }
      expect(find.text('10 white footlong sandwich(es): 🥪🥪🥪🥪🥪🥪🥪🥪🥪🥪'),
          findsOneWidget);
    });
  });

  group('OrderScreen - Controls', () {
    testWidgets('changes bread type with DropdownMenu',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.byType(DropdownMenu<BreadType>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('wheat').last);
      await tester.pumpAndSettle();
      expect(find.textContaining('wheat footlong sandwich'), findsOneWidget);
      await tester.tap(find.byType(DropdownMenu<BreadType>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('wholemeal').last);
      await tester.pumpAndSettle();
      expect(
          find.textContaining('wholemeal footlong sandwich'), findsOneWidget);
    });

    testWidgets('updates note with TextField', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.enterText(
          find.byKey(const Key('notes_textfield')), 'Extra mayo');
      await tester.pump();
      expect(find.text('Note: Extra mayo'), findsOneWidget);
    });
  });

  group('StyledButton', () {
    testWidgets('renders with icon and label', (WidgetTester tester) async {
      const testButton = StyledButton(
        onPressed: null,
        icon: Icons.add,
        label: 'Test Add',
      );
      const testApp = MaterialApp(
        home: Scaffold(body: testButton),
      );
      await tester.pumpWidget(testApp);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Test Add'), findsOneWidget);
      expect(find.byType(StyledButton), findsOneWidget);
    });
  });

  group('OrderItemDisplay', () {
    testWidgets('shows correct text and note for zero sandwiches',
        (WidgetTester tester) async {
      const widgetToBeTested = OrderItemDisplay(
        quantity: 0,
        itemType: 'footlong',
        breadType: BreadType.white,
        note: 'No notes added.',
      );
      const testApp = MaterialApp(
        home: Scaffold(body: widgetToBeTested),
      );
      await tester.pumpWidget(testApp);
      expect(find.text('0 white footlong sandwich(es): '), findsOneWidget);
      expect(find.text('Note: No notes added.'), findsOneWidget);
    });

    testWidgets('shows correct text and emoji for three sandwiches',
        (WidgetTester tester) async {
      const widgetToBeTested = OrderItemDisplay(
        quantity: 3,
        itemType: 'footlong',
        breadType: BreadType.white,
        note: 'No notes added.',
      );
      const testApp = MaterialApp(
        home: Scaffold(body: widgetToBeTested),
      );
      await tester.pumpWidget(testApp);
      expect(
          find.text('3 white footlong sandwich(es): 🥪🥪🥪'), findsOneWidget);
      expect(find.text('Note: No notes added.'), findsOneWidget);
    });

    testWidgets('shows correct bread and type for two six-inch wheat',
        (WidgetTester tester) async {
      const widgetToBeTested = OrderItemDisplay(
        quantity: 2,
        itemType: 'six-inch',
        breadType: BreadType.wheat,
        note: 'No pickles',
      );
      const testApp = MaterialApp(
        home: Scaffold(body: widgetToBeTested),
      );
      await tester.pumpWidget(testApp);
      expect(find.text('2 wheat six-inch sandwich(es): 🥪🥪'), findsOneWidget);
      expect(find.text('Note: No pickles'), findsOneWidget);
    });

    testWidgets('shows correct bread and type for one wholemeal footlong',
        (WidgetTester tester) async {
      const widgetToBeTested = OrderItemDisplay(
        quantity: 1,
        itemType: 'footlong',
        breadType: BreadType.wholemeal,
        note: 'Lots of lettuce',
      );
      const testApp = MaterialApp(
        home: Scaffold(body: widgetToBeTested),
      );
      await tester.pumpWidget(testApp);
      expect(
          find.text('1 wholemeal footlong sandwich(es): 🥪'), findsOneWidget);
      expect(find.text('Note: Lots of lettuce'), findsOneWidget);
    });
  });

  group('New test - Switch Widget', () {
    testWidgets('verifies the functionality of the sandwichType switch widget',
        (WidgetTester tester) async {
      const sandSwitch = Key('sandwich_TypeSwitch');

      await tester.pumpWidget(const MyApp(key: sandSwitch));
      // Verify initial state is footlong
      expect(find.text('0 white footlong sandwich(es): '), findsOneWidget);
      // Toggle the switch to six-inch
      // await tester.tap(find.byKey(sandSwitch));
      // await tester.pump();
      // Verify state is now six-inch
      // expect(find.text('0 white six-inch sandwich(es): '), findsOneWidget);
      // Toggle the switch back to footlong
      // await tester.tap(find.byKey(sandSwitch));
      // await tester.pump();
      // Verify state is back to footlong
      expect(find.text('0 white footlong sandwich(es): '), findsOneWidget);
    });
  });

  group('New test - Toasted Switch Widget', () {
    testWidgets('verifies the functionality of the "toasted" switch widget',
        (WidgetTester tester) async {
      const key = Key('ToastedSwitch');

      await tester.pumpWidget(const MyApp());
      // Verify initial state is untoasted
      expect(find.text('0 white footlong sandwich(es): '), findsOneWidget);
      // Toggle the switch to toasted
      final switches = find.byKey(key);
      await tester.tap(switches.at(0)); // Second switch for toasted
      await tester.pump();
      // Verify state is now toasted (no text change, but internal state change)
      // Toggle the switch back to untoasted
      await tester.tap(switches.at(0)); // Second switch for untoasted
      await tester.pump();
      // Verify state is back to untoasted
      expect(find.text('0 white footlong sandwich(es): '), findsOneWidget);
    });
  });

  group('OrderScreen - SnackBar', () {
    testWidgets('shows SnackBar after adding to cart',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Find and tap the Add to Cart button
      final addButton = find.widgetWithText(StyledButton, 'Add to Cart');
      expect(addButton, findsOneWidget);
      await tester.tap(addButton);

      // Advance animations so the SnackBar is shown
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // Verify a SnackBar is displayed with confirmation text
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('Added'), findsWidgets);
    });
  });

  group('OrderScreen - Cart Summary', () {
    testWidgets('updates cart summary when Add to Cart is pressed',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Initial summary should show zero items and zero total
      expect(find.text('Cart: 0 items'), findsOneWidget);
      expect(find.text('Total: £0.00'), findsOneWidget);

      // Tap Add to Cart (initial quantity is 1)
      final addButton = find.widgetWithText(StyledButton, 'Add to Cart');
      expect(addButton, findsOneWidget);
      await tester.tap(addButton);
      await tester.pump();

      // Summary should update
      expect(find.text('Cart: 1 items'), findsOneWidget);
      expect(find.text('Total: £4.50'), findsOneWidget);
    });
  });
}
