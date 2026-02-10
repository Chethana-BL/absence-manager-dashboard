import 'package:absence_manager_dashboard/core/routes/route_names.dart';
import 'package:absence_manager_dashboard/features/absence_management/presentation/pages/absence_list_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.home,
    routes: <RouteBase>[
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const AbsenceListPage(),
      ),
      GoRoute(
        path: RouteNames.absenceList,
        builder: (context, state) => const AbsenceListPage(),
      ),
    ],
  );
}
