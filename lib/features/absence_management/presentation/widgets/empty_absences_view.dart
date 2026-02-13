import 'package:absence_manager_dashboard/app/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class EmptyAbsencesView extends StatelessWidget {
  const EmptyAbsencesView({super.key, required this.onClearFilters});

  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = theme.colorScheme.onSurface;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 520, minHeight: 500),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLG),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.description_outlined,
                size: AppSizes.iconXXL,
                color: baseColor.withAlpha(90),
              ),

              const SizedBox(height: AppSizes.spaceLG),

              Text(
                'No Absences Found',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSizes.spaceSM),

              Text(
                'There are no absences matching your current filters.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: baseColor.withAlpha(150),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSizes.spaceLG),

              OutlinedButton(
                onPressed: onClearFilters,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, AppSizes.buttonHeight),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingXL,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Text('Clear Filters'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
