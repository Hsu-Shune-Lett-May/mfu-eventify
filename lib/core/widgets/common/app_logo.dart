import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/app_colors.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showBadge;

  const AppLogo({
    super.key,
    this.size = 128,
    this.showBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(size * 0.25),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowDark,
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            LucideIcons.calendar,
            size: size * 0.5,
            color: AppColors.white,
          ),
        ),
        if (showBadge)
          Positioned(
            top: -size * 0.0625,
            right: -size * 0.0625,
            child: Container(
              width: size * 0.375,
              height: size * 0.375,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.background,
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowDark,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                LucideIcons.bell,
                size: size * 0.1875,
                color: AppColors.white,
              ),
            ),
          ),
      ],
    );
  }
}