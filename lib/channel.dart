import 'package:lobevent_backend/controller/EventsController.dart';
import 'package:lobevent_backend/controller/User_EventStatusController.dart';
import 'package:lobevent_backend/controller/UserEventController.dart';

import 'lobevent_backend.dart';


class LobeventBackendChannel extends ApplicationChannel {

  ManagedContext context;


  @override
  Future prepare() async {
    logger.onRecord.listen((rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));

    final config = EventConfig(options.configurationFilePath);
    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final persistentStore = PostgreSQLPersistentStore.fromConnectionInfo(
        config.database.username,
        config.database.password,
        config.database.host,
        config.database.port,
        config.database.databaseName);

    context = ManagedContext(dataModel, persistentStore);
  }


  @override
  Controller get entryPoint {
    final router = Router();

    // Prefer to use `link` instead of `linkFunction`.
    // See: https://aqueduct.io/docs/http/request_controller/
    router
      .route("/events/[:id]")
      .link(() => EventsController(context));
     router
      .route("/users/eventStatus/[:userId]")
        .link(() => User_EventStatusController(context));
     router
      .route("/user/events/[:eventId]")
        .link(() => UserEventController(context));
    return router;
  }
}

class EventConfig extends Configuration {
  EventConfig(String path): super.fromFile(File(path));

  DatabaseConfiguration database;
}