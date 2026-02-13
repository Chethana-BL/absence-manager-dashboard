import 'package:absence_manager_dashboard/features/absence_management/data/models/absence_model.dart';
import 'package:absence_manager_dashboard/features/absence_management/data/models/member_model.dart';

abstract class AbsenceDataSource {
  Future<List<AbsenceModel>> getAbsences();
  Future<List<MemberModel>> getMembers();
}
