import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_neumorphism.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/neumorphic_card.dart';
import '../../../../core/widgets/neumorphic_container.dart';
import '../../../../core/widgets/parent_gate_dialog.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../auth/domain/usecases/update_name_use_case.dart';
import '../../../auth/domain/usecases/delete_account_use_case.dart';
import '../cubit/settings_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<SettingsCubit>(),
      child: const _SettingsView(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('الإعدادات', style: TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settings) {
          return ListView(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            children: [
              // ── Experience ──────────────────────────────────────────────────
              const _SectionHeader(title: 'تجربة التعلم'),
              _SettingsCard(children: [
                _SwitchTile(
                  icon: Icons.volume_up_rounded,
                  title: 'الأصوات',
                  subtitle: 'تشغيل أصوات ردود الفعل',
                  value: settings.soundOn,
                  onChanged: (v) => context.read<SettingsCubit>().setSoundOn(v),
                ),
                const Divider(height: 1, indent: 56),
                _SwitchTile(
                  icon: Icons.record_voice_over_rounded,
                  title: 'قراءة الأسئلة',
                  subtitle: 'قراءة الأسئلة تلقائياً بالصوت',
                  value: settings.ttsOn,
                  onChanged: (v) => context.read<SettingsCubit>().setTtsOn(v),
                ),
                const Divider(height: 1, indent: 56),
                _SwitchTile(
                  icon: Icons.accessibility_new_rounded,
                  title: 'تقليل الحركة',
                  subtitle: 'إيقاف الرسوم المتحركة المعقدة',
                  value: settings.reduceMotion,
                  onChanged: (v) =>
                      context.read<SettingsCubit>().setReduceMotion(v),
                ),
              ]),
              const SizedBox(height: AppSpacing.lg),

              // ── Font scale ──────────────────────────────────────────────────
              const _SectionHeader(title: 'حجم النص'),
              _FontScaleCard(currentScale: settings.fontScale),
              const SizedBox(height: AppSpacing.lg),

              // ── Account ─────────────────────────────────────────────────────
              const _SectionHeader(title: 'الحساب'),
              _SettingsCard(children: [
                _AccountNameTile(),
                const Divider(height: 1, indent: 56),
                _LogoutTile(),
                const Divider(height: 1, indent: 56),
                _DeleteAccountTile(),
              ]),
              const SizedBox(height: AppSpacing.lg),

              // ── About ────────────────────────────────────────────────────────
              const _SectionHeader(title: 'عن التطبيق'),
              _SettingsCard(children: [
                _AboutTile(
                  icon: Icons.description_outlined,
                  title: 'شروط الاستخدام',
                  // [PLACEHOLDER: terms URL]
                  url: 'https://example.com/terms',
                ),
                const Divider(height: 1, indent: 56),
                _AboutTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'سياسة الخصوصية',
                  // [PLACEHOLDER: privacy URL]
                  url: 'https://example.com/privacy',
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.primary,
                  ),
                  title: const Text('الإصدار', style: TextStyle(fontWeight: FontWeight.w600)),
                  trailing: Text(
                    // [PLACEHOLDER: read from package_info_plus]
                    '1.0.0',
                    style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ]),
              const SizedBox(height: AppSpacing.xxl),

              // ── Disclaimer ─────────────────────────────────────────────────
              const Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.xl),
                child: Text(
                  'NOVA منصة تعليمية داعمة وليست أداة تشخيص.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Font scale card
// ─────────────────────────────────────────────────────────────────────────────

class _FontScaleCard extends StatelessWidget {
  const _FontScaleCard({required this.currentScale});
  final double currentScale;

  static const _levels = [
    (scale: 0.9, label: 'صغير'),
    (scale: 1.0, label: 'عادي'),
    (scale: 1.2, label: 'كبير'),
  ];

  @override
  Widget build(BuildContext context) {
    return NeumorphicCard(
      radius: 20,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Live preview inside sunken container
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: AppNeumorphism.debossedDecoration(
              color: AppColors.surfaceVariant,
              radius: 12,
            ),
            child: Text(
              'معاينة: مرحباً بك في نوفا',
              style:
                  AppTextStyles.bodyLarge.copyWith(fontSize: 16 * currentScale, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: _levels.map((lvl) {
              final isSelected = lvl.scale == currentScale;
              return Expanded(
                child: GestureDetector(
                  onTap: () =>
                      context.read<SettingsCubit>().setFontScale(lvl.scale),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: isSelected
                        ? BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: AppNeumorphism.primaryGlowShadows(distance: 2, blur: 6),
                          )
                        : AppNeumorphism.embossedDecoration(
                            color: AppColors.surface,
                            radius: 12,
                            distance: 2,
                            blur: 4,
                          ),
                    child: Column(
                      children: [
                        Text(
                          'أ',
                          style: TextStyle(
                            fontSize: 14 * lvl.scale,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? AppColors.textOnPrimary
                                : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          lvl.label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected
                                ? AppColors.textOnPrimary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Account tiles
// ─────────────────────────────────────────────────────────────────────────────

class _AccountNameTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final name = authState is AuthStateAuthenticated ? authState.user.name : '';

    return ListTile(
      leading:
          const Icon(Icons.person_outline_rounded, color: AppColors.primary),
      title: const Text('الاسم', style: TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(name, style: AppTextStyles.caption),
      trailing: const Icon(Icons.edit_outlined, size: 18),
      onTap: () => _showEditName(context, name),
    );
  }

  Future<void> _showEditName(BuildContext context, String currentName) async {
    final ctrl = TextEditingController(text: currentName);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تعديل الاسم'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: 'الاسم'),
          textDirection: TextDirection.rtl,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final name = ctrl.text.trim();
    if (name.length < 2 || name.length > 60) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الاسم يجب أن يكون 2-60 حرفاً.')),
      );
      return;
    }
    final result = await getIt<UpdateNameUseCase>()(name);
    if (!context.mounted) return;
    result.fold(
      (_) => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل التعديل. يرجى المحاولة مجدداً.')),
      ),
      (user) {
        context.read<AuthCubit>().onLoggedIn(user);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تحديث الاسم بنجاح.')),
        );
      },
    );
  }
}

class _LogoutTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout_rounded, color: AppColors.gentleRetry),
      title: const Text('تسجيل الخروج',
          style: TextStyle(color: AppColors.gentleRetry, fontWeight: FontWeight.w600)),
      onTap: () async {
        final passed = await showParentGate(context);
        if (!passed || !context.mounted) return;
        await context.read<AuthCubit>().logout();
      },
    );
  }
}

class _DeleteAccountTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.delete_forever_rounded,
          color: AppColors.gentleRetry),
      title: const Text(
        'حذف الحساب',
        style: TextStyle(color: AppColors.gentleRetry, fontWeight: FontWeight.w600),
      ),
      onTap: () => _confirmDelete(context),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final passed = await showParentGate(context);
    if (!passed || !context.mounted) return;

    final pwdCtrl = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('حذف الحساب نهائياً'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'سيُحذف حسابك وجميع بيانات الأطفال نهائياً. لا يمكن التراجع.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: pwdCtrl,
              obscureText: true,
              decoration:
                  const InputDecoration(labelText: 'كلمة المرور للتأكيد'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gentleRetry),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final result = await getIt<DeleteAccountUseCase>()(pwdCtrl.text.trim());
    if (!context.mounted) return;
    result.fold(
      (_) => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('فشل الحذف. تأكد من كلمة المرور وأعد المحاولة.')),
      ),
      (_) => context.read<AuthCubit>().onAccountDeleted(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// About tile (opens URL)
// ─────────────────────────────────────────────────────────────────────────────

class _AboutTile extends StatelessWidget {
  const _AboutTile({
    required this.icon,
    required this.title,
    required this.url,
  });

  final IconData icon;
  final String title;
  final String url;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.open_in_new_rounded, size: 18),
      onTap: () {
        // [PLACEHOLDER: url_launcher — add url_launcher to pubspec and call launchUrl]
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('رابط: $url')),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsetsDirectional.only(start: 4, bottom: AppSpacing.sm),
      child: Text(
        title,
        style: AppTextStyles.titleSmall.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return NeumorphicCard(
      radius: 20,
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(children: children),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: AppTextStyles.caption),
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.primary,
    );
  }
}
