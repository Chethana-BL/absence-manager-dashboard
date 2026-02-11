import 'package:absence_manager_dashboard/features/absence_management/domain/entities/absence.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/entities/member.dart';

abstract class AbsenceRepository {
  Future<List<Absence>> getAbsences();
  Future<List<Member>> getMembers();
}
