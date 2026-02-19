import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class EventInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final double iconSize;

  const EventInfoRow({
    Key? key,
    required this.icon,
    required this.text,
    this.iconSize = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: iconSize,
          color: AppColors.primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
