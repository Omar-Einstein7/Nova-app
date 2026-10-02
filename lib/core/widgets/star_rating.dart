import "package:flutter/material.dart";
import "../theme/app_colors.dart";

/// Star rating display widget (1-3 stars, read-only).
class StarRating extends StatelessWidget {
  const StarRating({
    super.key,
    required this.stars,
    this.maxStars = 3,
    this.size = 32.0,
  }) : assert(stars >= 0 && stars <= maxStars);

  final int stars;
  final int maxStars;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxStars, (i) {
        return Icon(
          i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
          color: i < stars ? AppColors.starFilled : AppColors.starEmpty,
          size: size,
        );
      }),
    );
  }
}
