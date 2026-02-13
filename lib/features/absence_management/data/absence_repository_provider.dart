import 'package:absence_manager_dashboard/features/absence_management/data/datasources/absence_local_data_source.dart';
import 'package:absence_manager_dashboard/features/absence_management/data/datasources/absence_remote_data_source.dart';
import 'package:absence_manager_dashboard/features/absence_management/data/repositories/absence_repository_impl.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/enums/data_source_type.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/repositories/absence_repository.dart';

class AbsenceRepositoryProvider {
  const AbsenceRepositoryProvider._();

  static AbsenceRepository create(DataSourceType type) {
    switch (type) {
      case DataSourceType.local:
        return AbsenceRepositoryImpl(
          dataSource: const AbsenceLocalDataSourceImpl(),
        );

      case DataSourceType.remote:
        return AbsenceRepositoryImpl(dataSource: AbsenceRemoteDataSourceImpl());
    }
  }
}
