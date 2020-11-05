import 'package:hr_backend_app/controllers/authentication/sign_in_controller.dart';
import 'package:hr_backend_app/controllers/authentication/sign_up_controller.dart';
import 'package:hr_backend_app/hr_backend_app.dart';

class HrBackendAppChannel extends ApplicationChannel {
  ManagedContext context;

  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));

    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final config = HrConfig(options.configurationFilePath);
    final database = PostgreSQLPersistentStore.fromConnectionInfo(
        config.database.username,
        config.database.password,
        config.database.host,
        config.database.port,
        config.database.databaseName);
    context = ManagedContext(dataModel, database);
  }

  @override
  Controller get entryPoint {
    final router = Router();

    router
        .route("/authentication/sign-in")
        .link(() => SignInController(context));
    router
        .route("/authentication/sign-up")
        .link(() => SignUpController(context));

    return router;
  }
}

class HrConfig extends Configuration {
  HrConfig(String path) : super.fromFile(File(path));

  DatabaseConfiguration database;
}
