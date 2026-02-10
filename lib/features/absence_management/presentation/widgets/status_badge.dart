import 'package:absence_manager_dashboard/app/constants/app_sizes.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/enums/absence_status.dart';
import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final AbsenceStatus status;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = _colorsFor(context, status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingSM,
        vertical: AppSizes.paddingXS,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSizes.radius),
      ),
      child: Text(
        status.label,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: fg, fontWeight: FontWeight.w600),
      ),
    );
  }

  (Color, Color) _colorsFor(BuildContext context, AbsenceStatus status) {
    final scheme = Theme.of(context).colorScheme;

    switch (status) {
      case AbsenceStatus.requested:
        return (scheme.primary.withValues(alpha: 0.12), scheme.primary);
      case AbsenceStatus.confirmed:
        return (Colors.green.withValues(alpha: 0.12), Colors.green.shade800);
      case AbsenceStatus.rejected:
        return (Colors.red.withValues(alpha: 0.12), Colors.red.shade800);
    }
  }
}
