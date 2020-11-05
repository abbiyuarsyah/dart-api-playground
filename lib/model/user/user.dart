import '../../hr_backend_app.dart';

class User extends ManagedObject<_User> implements _User {}

class _User {
  @primaryKey
  int employeeId;

  String fullName;

  String email;

  String password;

  String company;
}
