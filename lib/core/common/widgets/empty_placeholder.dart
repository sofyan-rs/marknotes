import 'package:flutter/material.dart';

class EmptyPlaceholder extends StatelessWidget {
  const EmptyPlaceholder({
    super.key,
    required this.icon,
    required this.message,
  });

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 100),
          Icon(icon, size: 100, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 20),
          Text(message, style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
