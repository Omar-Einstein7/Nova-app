import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_neumorphism.dart';
import '../../../../core/widgets/neumorphic_container.dart';

/// Small brand mark shown at the top of auth pages (Login / Register) with Neumorphic 3D styling.
/// [PLACEHOLDER: replace Icon with an Image.asset of the real logo]
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NeumorphicContainer(
          shape: BoxShape.circle,
          width: 88,
          height: 88,
          distance: 6,
          blur: 14,
          color: AppColors.surface,
          child: Center(
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.primaryLight,
                    AppColors.primary,
                    AppColors.primaryDark,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: AppNeumorphism.primaryGlowShadows(distance: 3, blur: 8),
              ),
              child: const Icon(
                Icons.auto_awesome,
                size: 28,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'نوفا',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}
