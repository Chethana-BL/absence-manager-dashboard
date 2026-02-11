import 'package:absence_manager_dashboard/features/absence_management/domain/entities/member.dart';

class MemberModel {
  const MemberModel({
    required this.id,
    required this.name,
    required this.userId,
    required this.crewId,
    this.image,
  });

  final int id;
  final String name;
  final int userId;
  final int crewId;
  final String? image;

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'] as int,
      name: json['name'] as String,
      userId: json['userId'] as int,
      crewId: json['crewId'] as int,
      image: json['image'] as String?,
    );
  }

  Member toEntity() {
    return Member(
      id: id,
      name: name,
      userId: userId,
      crewId: crewId,
      image: image,
    );
  }
}
