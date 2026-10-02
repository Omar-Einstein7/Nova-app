import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";

import "core/di/injection.dart";
import "core/router/app_router.dart";
import "core/storage/prefs.dart";
import "core/storage/secure_storage.dart";
import "core/theme/app_theme.dart";

class NovaApp extends StatefulWidget {
  const NovaApp({super.key});

  @override
  State<NovaApp> createState() => _NovaAppState();
}

class _NovaAppState extends State<NovaApp> {
  late final _router = buildRouter(
    secureStorage: getIt<SecureStorage>(),
    prefs: getIt<Prefs>(),
  );

  @override
  Widget build(BuildContext context) {
    final fontScale = getIt<Prefs>().fontScale;

    return MaterialApp.router(
      title: "نوفا",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(fontScale: fontScale),

      // Routing
      routerConfig: _router,

      // Localisation
      locale: const Locale("ar"),
      supportedLocales: const [Locale("ar")],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // RTL
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
