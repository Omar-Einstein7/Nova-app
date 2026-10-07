import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../children/domain/entities/child.dart';

/// Card representing a single child on the HomePage.
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

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      color: AppColors.surface,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Avatar circle
              _AvatarWidget(avatar: child.avatar, name: child.name),
              const SizedBox(width: 14),
              // Name + age
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      child.name,
                      style: AppTextStyles.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l.childAgeLabel(child.age),
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              // Overflow menu
              PopupMenuButton<_CardAction>(
                key: Key('child_card_menu_${child.id}'),
                icon:
                    const Icon(Icons.more_vert, color: AppColors.textSecondary),
                onSelected: (action) {
                  if (action == _CardAction.edit) onEdit();
                  if (action == _CardAction.delete) onDelete();
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: _CardAction.edit,
                    child: Text(l.edit),
                  ),
                  PopupMenuItem(
                    value: _CardAction.delete,
                    child: Text(
                      l.delete,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
    // Map avatar key to an emoji for now [PLACEHOLDER: swap with Image.asset]
    final emoji = avatar != null && int.tryParse(avatar!) != null
        ? _emojis[int.parse(avatar!) % _emojis.length]
        : (name.isNotEmpty
            ? _emojis[name.codeUnitAt(0) % _emojis.length]
            : '🌟');

    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(emoji, style: const TextStyle(fontSize: 26)),
      ),
    );
  }
}
