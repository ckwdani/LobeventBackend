import 'package:lobevent_backend/lobevent_backend.dart';
import 'package:aqueduct/aqueduct.dart';
import 'package:lobevent_backend/model/event.dart';

class EventsController extends ResourceController {
  EventsController(this.context);

  final ManagedContext context;

  @Operation.get()
  Future<Response> getAllEvents({@Bind.query('name') String name}) async {
    final eventQuery = Query<Event>(context);

    if (name != null) {
      eventQuery.where((h) => h.name).contains(name, caseSensitive: false);
    }

    final events = await eventQuery.fetch();

    return Response.ok(events);

  }
}