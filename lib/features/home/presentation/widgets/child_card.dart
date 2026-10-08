import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_neumorphism.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/neumorphic_container.dart';
import '../../../children/domain/entities/child.dart';

/// Card representing a single child on the HomePage with Neumorphic styling.
class ChildCard extends StatelessWidget {
  const ChildCard({
    super.key,
    required this.child,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final Child child;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return NeumorphicContainer(
      onTap: onTap,
      radius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      color: AppColors.surface,
      child: Row(
        children: [
          // Neumorphic circular avatar
          _AvatarWidget(avatar: child.avatar, name: child.name),
          const SizedBox(width: 16),
          // Name + age
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  child.name,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  l.childAgeLabel(child.age),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Overflow menu
          PopupMenuButton<_CardAction>(
            key: Key('child_card_menu_${child.id}'),
            icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: AppColors.surface,
            elevation: 4,
            onSelected: (action) {
              if (action == _CardAction.edit) onEdit();
              if (action == _CardAction.delete) onDelete();
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: _CardAction.edit,
                child: Text(l.edit, style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
              PopupMenuItem(
                value: _CardAction.delete,
                child: Text(
                  l.delete,
                  style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum _CardAction { edit, delete }

/// [PLACEHOLDER: replace emoji with real avatar asset from assets/avatars/]
class _AvatarWidget extends StatelessWidget {
  const _AvatarWidget({required this.avatar, required this.name});
  final String? avatar;
  final String name;

  static const List<String> _emojis = [
    '🐱',
    '🐶',
    '🦊',
    '🐼',
    '🦁',
    '🐸',
    '🦋',
    '🐧',
    '🐨',
    '🦄',
    '🐰',
    '🐻',
  ];

  @override
  Widget build(BuildContext context) {
    final emoji = avatar != null && int.tryParse(avatar!) != null
        ? _emojis[int.parse(avatar!) % _emojis.length]
        : (name.isNotEmpty
            ? _emojis[name.codeUnitAt(0) % _emojis.length]
            : '🌟');

    return NeumorphicContainer(
      shape: BoxShape.circle,
      width: 56,
      height: 56,
      distance: 3,
      blur: 6,
      color: AppColors.surfaceVariant.withValues(alpha: 0.6),
      child: Center(
        child: Text(emoji, style: const TextStyle(fontSize: 28)),
      ),
    );
  }
}
