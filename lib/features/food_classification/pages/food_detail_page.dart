import 'package:flutter/material.dart';

class FoodDetailPage extends StatelessWidget {
  final String foodName;

  const FoodDetailPage({super.key, required this.foodName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      appBar: AppBar(title: Text('Food Detail Page')),
      body: Center(child: Text('ini adalah detail page: $foodName')),
    );
  }
}
