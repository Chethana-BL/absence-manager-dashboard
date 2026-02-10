enum AbsenceStatus {
  requested('Requested'),
  confirmed('Confirmed'),
  rejected('Rejected');

  const AbsenceStatus(this.label);

  final String label;
}
