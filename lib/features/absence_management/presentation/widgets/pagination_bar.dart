import 'package:absence_manager_dashboard/app/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class PaginationBar extends StatelessWidget {
  const PaginationBar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onNext,
    required this.onPrevious,
  });

  final int currentPage;
  final int totalPages;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  @override
  Widget build(BuildContext context) {
    final isFirstPage = currentPage == 0;
    final isLastPage = currentPage >= totalPages - 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'Page ${currentPage + 1} of $totalPages',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(width: AppSizes.space),

        IconButton(
          onPressed: isFirstPage ? null : onPrevious,
          icon: const Icon(Icons.arrow_back),
        ),

        IconButton(
          onPressed: isLastPage ? null : onNext,
          icon: const Icon(Icons.arrow_forward),
        ),
      ],
    );
  }
}
