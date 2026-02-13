import 'package:absence_manager_dashboard/features/absence_management/data/datasources/absence_data_source.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/entities/absence.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/entities/member.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/repositories/absence_repository.dart';

class AbsenceRepositoryImpl implements AbsenceRepository {
  AbsenceRepositoryImpl({required this.dataSource});

  final AbsenceDataSource dataSource;

  @override
  Future<List<Absence>> getAbsences() async {
    final models = await dataSource.getAbsences();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Member>> getMembers() async {
    final models = await dataSource.getMembers();
    return models.map((m) => m.toEntity()).toList();
  }
}
