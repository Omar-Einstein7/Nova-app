import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Small brand mark shown at the top of auth pages (Login / Register).
/// [PLACEHOLDER: replace Icon with an Image.asset of the real logo]
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.30),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.auto_awesome,
            size: 34,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'نوفا',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
