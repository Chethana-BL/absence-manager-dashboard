import 'package:absence_manager_dashboard/features/absence_management/domain/enums/absence_status.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/enums/absence_type.dart';

class AbsenceListItemVm {
  const AbsenceListItemVm({
    required this.employeeName,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.memberNote,
    required this.admitterNote,
    required this.status,
    required this.daysCount,
  });

  final String employeeName;
  final AbsenceType type;
  final DateTime startDate;
  final DateTime endDate;
  final String? memberNote;
  final String? admitterNote;
  final AbsenceStatus status;
  final int daysCount;
}
