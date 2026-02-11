import 'package:absence_manager_dashboard/features/absence_management/data/datasources/absence_local_data_source.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/entities/absence.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/entities/member.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/repositories/absence_repository.dart';

class AbsenceRepositoryImpl implements AbsenceRepository {
  const AbsenceRepositoryImpl({required this.localDataSource});

  final AbsenceLocalDataSource localDataSource;

  @override
  Future<List<Absence>> getAbsences() async {
    final models = await localDataSource.getAbsences();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Member>> getMembers() async {
    final models = await localDataSource.getMembers();
    return models.map((m) => m.toEntity()).toList();
  }
}
