import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class FeatureIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const FeatureIcon({
    Key? key,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            color: AppColors.primaryLighter,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 28,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
