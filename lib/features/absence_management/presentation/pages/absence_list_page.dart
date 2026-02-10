import 'package:absence_manager_dashboard/app/constants/app_sizes.dart';
import 'package:absence_manager_dashboard/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AbsenceListPage extends StatelessWidget {
  const AbsenceListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(
              AppSizes.paddingLG,
              AppSizes.paddingXL,
              AppSizes.paddingLG,
              AppSizes.paddingLG,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[AppTheme.primary, AppTheme.secondary],
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(AppSizes.radiusLG),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Absence Manager',
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: AppSizes.spaceSM),
                  Text(
                    'View, filter, and manage employee absences including vacations and sick leave',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Expanded(
            child: Center(
              child: Card(
                elevation: AppSizes.elevation,
                child: Padding(
                  padding: EdgeInsets.all(AppSizes.paddingLG),
                  child: Text('Absence list will appear here'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
