import 'package:flutter/material.dart';
import 'package:pocket_quake/utils/extensions.dart';

class DetailField extends StatelessWidget {
  final String label;
  final Widget value;
  final IconData? icon;
  const DetailField(
      {super.key, required this.label, required this.value, this.icon});

  @override
  Widget build(BuildContext context) {
    final detail = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: context.colors.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        value
      ],
    );

    if (icon != null) {
      return Row(
        children: [
          Icon(
            icon,
            size: 32,
            color: context.colors.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          detail
        ],
      );
    } else {
      return detail;
    }
  }
}
