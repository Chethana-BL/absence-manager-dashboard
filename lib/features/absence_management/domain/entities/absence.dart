import 'package:absence_manager_dashboard/features/absence_management/domain/enums/absence_status.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/enums/absence_type.dart';

class Absence {
  const Absence({
    required this.id,
    required this.crewId,
    required this.userId,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    this.admitterId,
    this.memberNote,
    this.admitterNote,
    this.confirmedAt,
    this.rejectedAt,
  });

  final int id;
  final int crewId;
  final int userId;
  final int? admitterId;

  final AbsenceType type;
  final DateTime startDate;
  final DateTime endDate;

  final String? memberNote;
  final String? admitterNote;

  final DateTime createdAt;
  final DateTime? confirmedAt;
  final DateTime? rejectedAt;

  AbsenceStatus get status {
    if (confirmedAt != null) return AbsenceStatus.confirmed;
    if (rejectedAt != null) return AbsenceStatus.rejected;
    return AbsenceStatus.requested;
  }

  int get daysCount => endDate.difference(startDate).inDays + 1;
}
