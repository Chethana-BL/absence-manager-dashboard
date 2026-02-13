import 'package:absence_manager_dashboard/core/routes/app_router.dart';
import 'package:absence_manager_dashboard/core/theme/app_theme.dart';
import 'package:absence_manager_dashboard/features/absence_management/data/absence_repository_provider.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/enums/data_source_type.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/repositories/absence_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AbsenceManagerApp extends StatelessWidget {
  const AbsenceManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AbsenceRepository>(
      create: (_) => AbsenceRepositoryProvider.create(DataSourceType.remote),

      child: MaterialApp.router(
        title: 'Absence Manager',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
