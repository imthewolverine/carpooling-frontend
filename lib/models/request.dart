class Request {
  final String driverFirstName;
  final String driverLastName;
  final String status;

  Request({
    required this.driverFirstName,
    required this.driverLastName,
    required this.status,
  });

  factory Request.fromMap(Map<String, dynamic> map) {
    return Request(
      driverFirstName: map['driverFirstName'] ?? '',
      driverLastName: map['driverLastName'] ?? '',
      status: map['status'] ?? '',
    );
  }
}
