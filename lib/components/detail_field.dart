import 'package:flutter/material.dart';

class DetailField extends StatelessWidget {
  final String label;
  final Widget value;

  const DetailField({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface)),
      const SizedBox(height: 4),
      value
    ]);
  }
}
