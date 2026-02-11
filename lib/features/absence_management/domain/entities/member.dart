class Member {
  const Member({
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
}
