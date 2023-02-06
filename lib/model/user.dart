class UserAccount {
  final String firstName, lastName, email, password;
  final String? imageProfile, token;
  final bool isDisable;

  UserAccount(
      {required this.token,
      required this.email,
      required this.password,
      required this.firstName,
      required this.lastName,
      required this.imageProfile,
      required this.isDisable});

  UserAccount.fromJson(Map<String, dynamic>? json)
      : this(
            email: json!['email'] as String,
            token: json['token'] as String?,
            password: json['password'] as String,
            firstName: json['firstName'] as String,
            lastName: json['lastName'] as String,
            isDisable: json['isDisable'] as bool,
            imageProfile: json['imageProfile'] as String?);

  Map<String, Object?> toJson() {
    return {
      'token': token,
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'isDisable': isDisable,
      'imageProfile': imageProfile
    };
  }
}
