class DriverRequest {
  final String driverFirstName;
  final String driverLastName;
  final String status;
  final String driverId;
  DriverRequest({
    required this.driverFirstName,
    required this.driverLastName,
    required this.status,
    this.driverId = '',
  });

  factory DriverRequest.fromMap(Map<String, dynamic> map) {
    return DriverRequest(
      driverFirstName: map['driverFirstName'] ?? '',
      driverLastName: map['driverLastName'] ?? '',
      status: map['status'] ?? '',
    );
  }
}
