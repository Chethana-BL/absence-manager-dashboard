import 'package:absence_manager_dashboard/features/absence_management/domain/entities/absence.dart';
import 'package:absence_manager_dashboard/features/absence_management/domain/enums/absence_type.dart';

class AbsenceModel {
  const AbsenceModel({
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

  factory AbsenceModel.fromJson(Map<String, dynamic> json) {
    final typeString = (json['type'] as String).toLowerCase();
    final type = typeString == 'vacation'
        ? AbsenceType.vacation
        : AbsenceType.sickness;

    DateTime? parseNullableDateTime(String? value) {
      if (value == null || value.isEmpty) return null;
      return DateTime.parse(value);
    }

    String? normalizeNote(dynamic v) {
      final s = v as String?;
      if (s == null || s.trim().isEmpty) return null;
      return s;
    }

    return AbsenceModel(
      id: json['id'] as int,
      crewId: json['crewId'] as int,
      userId: json['userId'] as int,
      admitterId: json['admitterId'] as int?,
      type: type,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      memberNote: normalizeNote(json['memberNote']),
      admitterNote: normalizeNote(json['admitterNote']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      confirmedAt: parseNullableDateTime(json['confirmedAt'] as String?),
      rejectedAt: parseNullableDateTime(json['rejectedAt'] as String?),
    );
  }

  Absence toEntity() {
    return Absence(
      id: id,
      crewId: crewId,
      userId: userId,
      admitterId: admitterId,
      type: type,
      startDate: startDate,
      endDate: endDate,
      memberNote: memberNote,
      admitterNote: admitterNote,
      createdAt: createdAt,
      confirmedAt: confirmedAt,
      rejectedAt: rejectedAt,
    );
  }
}
