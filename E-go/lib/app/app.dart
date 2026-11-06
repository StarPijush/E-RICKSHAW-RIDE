import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_go/app/theme/index.dart';
import 'package:e_go/app/router.dart';
import 'package:e_go/app/app_state.dart';

/// E-GO customer application widget.
class EGoApp extends StatelessWidget {
  const EGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const _EGoMaterialApp(),
    );
  }
}

class _EGoMaterialApp extends StatelessWidget {
  const _EGoMaterialApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-GO',
      debugShowCheckedModeBanner: false,
      theme: EGoTheme.light,
      initialRoute: EGoRouter.splash,
      onGenerateRoute: EGoRouter.generateRoute,
      supportedLocales: const [Locale('en', 'US')],
    );
  }
}
