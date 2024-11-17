class Ad {
  final String id;
  final String date;
  final String description;
  final String parentId;
  final int salary;
  final String school;
  final String schoolAddress;
  final String status;
  final String time;

  Ad({
    required this.id,
    required this.date,
    required this.description,
    required this.parentId,
    required this.salary,
    required this.school,
    required this.schoolAddress,
    required this.status,
    required this.time,
  });

  factory Ad.fromMap(Map<String, dynamic> map) {
    return Ad(
      id: map['id'] ?? '',
      date: map['date'] ?? '',
      description: map['description'] ?? '',
      parentId: map['parentId'] ?? '',
      salary: map['salary'] ?? 0,
      school: map['school'] ?? '',
      schoolAddress: map['schoolAddress'] ?? '',
      status: map['status'] ?? '',
      time: map['time'] ?? '',
    );
  }
}
