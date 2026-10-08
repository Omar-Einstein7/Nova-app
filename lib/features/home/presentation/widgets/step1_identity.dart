import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_neumorphism.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/neumorphic_container.dart';
import '../../../children/presentation/cubit/child_form_cubit.dart';
import '../../../children/presentation/cubit/child_form_state.dart';

/// Step 1: Name, birth date, avatar selection with Neumorphic styling.
class Step1Identity extends StatefulWidget {
  const Step1Identity({super.key, required this.formKey});
  final GlobalKey<FormState> formKey;

  @override
  State<Step1Identity> createState() => _Step1IdentityState();
}

class _Step1IdentityState extends State<Step1Identity> {
  late final TextEditingController _nameCtrl;

  @override
  void initState() {
    super.initState();
    final name = context.read<ChildFormCubit>().state.name;
    _nameCtrl = TextEditingController(text: name);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cubit = context.read<ChildFormCubit>();

    return BlocBuilder<ChildFormCubit, ChildFormState>(
      builder: (context, state) {
        return Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Name ───────────────────────────────────────────────────────
              Text(l.childNameLabel, style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              AppTextField(
                key: const Key('child_name_field'),
                controller: _nameCtrl,
                hint: l.childNameHint,
                onChanged: cubit.setName,
                validator: (v) {
                  final s = (v ?? '').trim();
                  if (s.isEmpty) return l.validationNameRequired;
                  if (s.length > 40) return l.childNameTooLong;
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // ── Birth date ─────────────────────────────────────────────────
              Text(l.birthDateLabel, style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              _BirthDatePicker(
                selectedDate: state.birthDate,
                displayAge: cubit.currentAge,
                onPicked: cubit.setBirthDate,
              ),
              if (state.birthDate != null && cubit.currentAge != null) ...[
                const SizedBox(height: 6),
                _AgeValidationHint(age: cubit.currentAge!),
              ],
              const SizedBox(height: 28),

              // ── Avatar ─────────────────────────────────────────────────────
              Text(l.avatarLabel, style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              _AvatarGrid(
                selected: state.avatar,
                onSelect: cubit.setAvatar,
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Birth date picker ─────────────────────────────────────────────────────────

class _BirthDatePicker extends StatelessWidget {
  const _BirthDatePicker({
    required this.selectedDate,
    required this.displayAge,
    required this.onPicked,
  });
  final DateTime? selectedDate;
  final int? displayAge;
  final void Function(DateTime) onPicked;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return NeumorphicContainer(
      radius: 16,
      distance: 3,
      blur: 6,
      color: AppColors.surface,
      onTap: () => _pick(context),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        key: const Key('birth_date_picker'),
        children: [
          const Icon(Icons.calendar_today_outlined,
              color: AppColors.primary),
          const SizedBox(width: 12),
          Text(
            selectedDate != null
                ? '${selectedDate!.year}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.day.toString().padLeft(2, '0')}'
                    ' (${l.childAgeLabel(displayAge ?? 0)})'
                : l.selectBirthDate,
            style: AppTextStyles.bodyMedium.copyWith(
              color: selectedDate != null
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime(now.year - 6),
      firstDate: DateTime(now.year - 18),
      lastDate: DateTime(now.year - 3),
      locale: const Locale('ar'),
    );
    if (picked != null) onPicked(picked);
  }
}

class _AgeValidationHint extends StatelessWidget {
  const _AgeValidationHint({required this.age});
  final int age;

  @override
  Widget build(BuildContext context) {
    final valid = age >= 3 && age <= 18;
    final l = AppLocalizations.of(context);
    return Text(
      valid ? '' : l.childAgeOutOfRange,
      style: AppTextStyles.bodySmall.copyWith(
        color: valid ? AppColors.success : AppColors.gentleRetry,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

// ── Avatar grid ───────────────────────────────────────────────────────────────

/// [PLACEHOLDER: replace emojis with Image.asset from assets/avatars/]
class _AvatarGrid extends StatelessWidget {
  const _AvatarGrid({required this.selected, required this.onSelect});
  final String? selected;
  final void Function(String) onSelect;

  static const _avatars = [
    ('0', '🐱'),
    ('1', '🐶'),
    ('2', '🦊'),
    ('3', '🐼'),
    ('4', '🦁'),
    ('5', '🐸'),
    ('6', '🦋'),
    ('7', '🐧'),
    ('8', '🐨'),
    ('9', '🦄'),
    ('10', '🐰'),
    ('11', '🐻'),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      children: _avatars.map((pair) {
        final (key, emoji) = pair;
        final isSelected = selected == key;
        return NeumorphicContainer(
          key: Key('avatar_$key'),
          shape: BoxShape.circle,
          style: isSelected ? NeumorphicStyle.debossed : NeumorphicStyle.embossed,
          color: isSelected ? AppColors.surfaceVariant : AppColors.surface,
          distance: isSelected ? 2 : 4,
          blur: isSelected ? 4 : 8,
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 2.5)
              : null,
          onTap: () => onSelect(key),
          child: Center(
            child: Text(emoji, style: TextStyle(fontSize: isSelected ? 30 : 26)),
          ),
        );
      }).toList(),
    );
  }
}
