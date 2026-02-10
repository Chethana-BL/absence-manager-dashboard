import 'package:absence_manager_dashboard/app/constants/app_sizes.dart';
import 'package:absence_manager_dashboard/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class PrimaryGradientHeader extends StatelessWidget {
  const PrimaryGradientHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('primary_gradient_header'),
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
              title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: AppSizes.spaceSM),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
