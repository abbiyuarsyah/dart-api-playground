class UserRequest {
  UserRequest(this.fullName, this.email, this.password, this.company);

  factory UserRequest.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw const FormatException('Null JSON in User constructor');
    }
    return UserRequest(
      json['fullName'] as String,
      json['email'] as String,
      json['password'] as String,
      json['company'] as String,
    );
  }

  String fullName;
  String email;
  String password;
  String company;
}
