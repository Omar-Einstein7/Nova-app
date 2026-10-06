import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../children/domain/entities/child.dart';
import '../../../children/presentation/cubit/children_list_cubit.dart';
import '../../../children/presentation/cubit/children_list_state.dart';
import '../../../skills/presentation/cubit/skills_cubit.dart';
import '../widgets/child_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChildrenListCubit>(
          create: (_) => getIt<ChildrenListCubit>()..load(),
        ),
        BlocProvider<SkillsCubit>(
          create: (_) => getIt<SkillsCubit>()..load(),
        ),
      ],
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text(l.homeTitle, style: AppTextStyles.titleLarge.copyWith(color: Colors.white)),
        centerTitle: false,
        actions: [
          IconButton(
            key: const Key('home_settings_button'),
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            tooltip: AppLocalizations.of(context).settingsTitle,
            onPressed: () => context.pushNamed('settings'),
          ),
        ],
      ),
      body: BlocConsumer<ChildrenListCubit, ChildrenListState>(
        listener: (context, state) {
          if (state is ChildrenListStateError) {
            _showErrorSnackBar(context, state.failure);
          }
        },
        builder: (context, state) {
          return switch (state) {
            ChildrenListStateInitial() ||
            ChildrenListStateLoading() =>
              const LoadingView(),
            ChildrenListStateError(:final failure) => ErrorView(
                message: _failureMessage(context, failure),
                onRetry: () => context.read<ChildrenListCubit>().load(),
              ),
            ChildrenListStateLoaded(:final children) =>
              _ChildrenBody(children: children),
          };
        },
      ),
      floatingActionButton:
          BlocBuilder<ChildrenListCubit, ChildrenListState>(
        builder: (context, state) {
          final count = state is ChildrenListStateLoaded
              ? state.children.length
              : 0;
          if (count >= 5) return const SizedBox.shrink();
          return FloatingActionButton.extended(
            key: const Key('home_add_child_fab'),
            onPressed: () => _openAddChild(context),
            backgroundColor: AppColors.primary,
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text(
              AppLocalizations.of(context).addChildButton,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  void _openAddChild(BuildContext context) =>
      context.pushNamed('addChild').then((_) {
        if (context.mounted) {
          // refresh in case navigation returns (fallback)
          context.read<ChildrenListCubit>().load();
        }
      });

  void _showErrorSnackBar(BuildContext context, Failure failure) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_failureMessage(context, failure)),
        backgroundColor: AppColors.gentleRetry,
      ),
    );
  }

  static String _failureMessage(BuildContext context, Failure failure) {
    final l = AppLocalizations.of(context);
    return switch (failure) {
      NetworkFailure() => l.errorNetwork,
      TimeoutFailure() => l.errorTimeout,
      UnauthorizedFailure() => l.errorUnauthorized,
      ServerFailure(:final message) => l.errorServer(message),
      _ => l.errorGeneric,
    };
  }
}

// ── Children body ─────────────────────────────────────────────────────────────

class _ChildrenBody extends StatelessWidget {
  const _ChildrenBody({required this.children});
  final List<Child> children;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    if (children.isEmpty) {
      return EmptyView(
        message: l.homeNoChildren,
        actionLabel: l.addChildButton,
        onAction: () => context.pushNamed('addChild'),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => context.read<ChildrenListCubit>().load(),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: children.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final child = children[index];
          return ChildCard(
            key: ValueKey(child.id),
            child: child,
            onTap: () => context.pushNamed(
              RouteNames.childDashboard,
              pathParameters: {'childId': child.id},
              extra: child,
            ),
            onEdit: () => context.pushNamed(
              'editChild',
              pathParameters: {'childId': child.id},
              extra: child,
            ),
            onDelete: () => _confirmDelete(context, child),
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Child child) async {
    final l = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l.deleteChildTitle),
        content: Text(l.deleteChildConfirm(child.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l.delete,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await context.read<ChildrenListCubit>().deleteChild(child.id);
    }
  }
}
