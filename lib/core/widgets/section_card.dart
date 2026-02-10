import 'package:absence_manager_dashboard/app/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSizes.paddingLG),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppSizes.elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLG),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
