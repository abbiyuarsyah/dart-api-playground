import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:hr_backend_app/hr_backend_app.dart';
import 'package:hr_backend_app/model/user/user.dart';

class SignInController extends ResourceController {
  SignInController(this.context);

  ManagedContext context;

  @Operation.get()
  Future<Response> signIn(
      @Bind.header("authorization") String authHeader) async {
    return await _isAuthorized(authHeader);
  }

  Future<Response> _isAuthorized(String authHeader) async {
    final parts = authHeader.split(' ');
    if (parts == null || parts.length != 2 || parts[0] != 'Basic') {
      return Response.forbidden();
    }

    return _isValidUsernameAndPassword(parts[1]);
  }

  Future<Response> _isValidUsernameAndPassword(String credentials) async {
    final String decoded = utf8.decode(base64.decode(credentials));
    final parts = decoded.split(':');
    final query = Query<User>(context)..where((x) => x.email).equalTo(parts[0]);
    final user = await query.fetchOne();

    if (user == null) {
      return Response.badRequest(body: {"message": "User tidak ada"});
    }

    return _passwordHashMatches(user.password, parts[1]);
  }

  Future<Response> _passwordHashMatches(
      String saltHash, String password) async {
    final parts = saltHash.split('.');
    final salt = parts[0];
    final savedHash = parts[1];

    final saltedPassword = salt + password;
    final bytes = utf8.encode(saltedPassword);
    final newHash = sha256.convert(bytes).toString();
    if (savedHash == newHash) {
      return Response.ok("sukses");
    } else {
      return Response.badRequest(body: {"message": "Password anda salah"});
    }
  }
}
