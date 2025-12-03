import 'package:flutter/material.dart';

class TransactionLoadingState extends StatelessWidget {
  const TransactionLoadingState({super.key, required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator(color: colorScheme.primary));
  }
}
