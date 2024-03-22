import 'package:flutter/material.dart';

class DetailField extends StatelessWidget {
  final String label;
  final Widget value;
  final Widget? icon;

  const DetailField(
      {super.key, required this.label, required this.value, this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final detail = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        value
      ],
    );

    if (icon != null) {
      return Row(
        children: [icon!, const SizedBox(width: 12), detail],
      );
    } else {
      return detail;
    }
  }
}
