class AccountInfo {
  final int userId;
  final String userUuid;
  final String lastName;
  final String firstName;
  final String fullName;
  final String email;
  final String role;
  final bool isAdmin;
  final List<String> consoleRoles;

  AccountInfo({
    required this.userId,
    required this.userUuid,
    required this.lastName,
    required this.firstName,
    required this.fullName,
    required this.email,
    required this.role,
    required this.isAdmin,
    required this.consoleRoles,
  });

  factory AccountInfo.fromJson(Map<String, dynamic> json) {
    return AccountInfo(
      userId: json['userId'] as int,
      userUuid: json['userUuid'] as String,
      lastName: json['lastName'] as String,
      firstName: json['firstName'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      isAdmin: json['isAdmin'] as bool,
      consoleRoles: (json['consoleRoles'] as List<dynamic>).cast<String>(),
    );
  }
}
