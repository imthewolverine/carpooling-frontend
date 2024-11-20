class Driver {
  final String id;
  final String driverName;
  final String email;
  final String firstName;
  final String lastName;
  final String password;
  final String phoneNumber;

  Driver({
    required this.id,
    required this.driverName,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.phoneNumber,
  });

  factory Driver.fromMap(String id, Map<String, dynamic> map) {
    return Driver(
      id: id,
      driverName: map['driverName'] ?? '',
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      password: map['password'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
    );
  }
}
