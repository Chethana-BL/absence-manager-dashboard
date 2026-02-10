import 'package:absence_manager_dashboard/core/routes/app_router.dart';
import 'package:absence_manager_dashboard/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AbsenceManagerApp extends StatelessWidget {
  const AbsenceManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Absence Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: AppRouter.router,
    );
  }
}
