import 'dart:convert';
import 'dart:math';

import 'package:hr_backend_app/model/user/user.dart';
import 'package:crypto/crypto.dart';
import 'package:hr_backend_app/model/user/user_request.dart';
import 'package:string_validator/string_validator.dart';
import '../../hr_backend_app.dart';

class SignUpController extends ResourceController {
  SignUpController(this.context);

  ManagedContext context;

  @Operation.post()
  Future<Response> signup() async {
    final map = await request.body.decode<Map<String, dynamic>>();
    final UserRequest userRequest = UserRequest.fromJson(map);
    userRequest.password = _hashPassword(userRequest.password);

    if (!_isValid(userRequest)) {
      return Response.forbidden();
    }

    final query = Query<User>(context)
      ..values.employeeId = _createId()
      ..values.fullName = userRequest.fullName
      ..values.password = userRequest.password
      ..values.email = userRequest.email
      ..values.company = userRequest.company;
    final event = await query.insert();

    return Response.ok(event);
  }

  bool _isValid(UserRequest userRequest) {
    if (userRequest == null ||
        userRequest.email == null ||
        userRequest.password == null) {
      return false;
    }
    if (!isEmail(userRequest.email)) {
      return false;
    }
    if (!isLength(userRequest.password, 8)) {
      return false;
    }
    return true;
  }

  String _hashPassword(String password) {
    final salt = AuthUtility.generateRandomSalt();
    final saltedPassword = salt + password;
    final bytes = utf8.encode(saltedPassword);
    final hash = sha256.convert(bytes);
    return '$salt.$hash';
  }

  int _createId() {
    final random = Random();
    return random.nextInt(900000) + 100000;
  }
}
