class UserRequest {
  final String userFirstName;
  final String userLastName;
  final String status;
  final String userId;
  UserRequest({
    required this.userFirstName,
    required this.userLastName,
    required this.status,
    this.userId = '',
  });

  factory UserRequest.fromMap(Map<String, dynamic> map) {
    return UserRequest(
      userFirstName: map['driverFirstName'] ?? '',
      userLastName: map['driverLastName'] ?? '',
      status: map['status'] ?? '',
      userId: map['userId'] ?? '',
    );
  }
}
