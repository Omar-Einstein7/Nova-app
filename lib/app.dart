import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/di/injection.dart';
import 'core/l10n/app_localizations.dart';
import 'core/router/app_router.dart';
import 'core/storage/prefs.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

class NovaApp extends StatefulWidget {
  const NovaApp({super.key});

  @override
  State<NovaApp> createState() => _NovaAppState();
}

class _NovaAppState extends State<NovaApp> {
  late final AuthCubit _authCubit = getIt<AuthCubit>();
  late final _router = buildRouter(
    authCubit: _authCubit,
    prefs: getIt<Prefs>(),
  );

  @override
  void initState() {
    super.initState();
    // Kick off session restoration immediately after the first frame.
    _authCubit.restoreSession();
  }

  @override
  Widget build(BuildContext context) {
    final fontScale = getIt<Prefs>().fontScale;

    return BlocProvider.value(
      value: _authCubit,
      child: MaterialApp.router(
        title: 'نوفا',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(fontScale: fontScale),

        // Routing
        routerConfig: _router,

        // Localisation
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar')],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        // RTL
        builder: (context, child) => Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    );
  }
}
