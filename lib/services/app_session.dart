import 'package:snacks_app/utils/storage.dart';

class AppSession {
  final storage = AppStorage.initStorage;

  create() async {
    try {
      var dateTime = DateTime.now().toLocal().add(const Duration(hours: 5));
      print(dateTime);
      await storage.write(key: "endAt", value: dateTime.toString());

      return true;
    } catch (e) {
      print(e);
    }

    return false;
  }

  Future<bool> validate() async {
    var session = await storage.read(key: "endAt");

    if (session != null) {
      var dateTime = DateTime.parse(session.toString()).toLocal();
      var dateTimeNow = DateTime.now().toLocal();

      if (dateTimeNow.compareTo(dateTime) > 0) {
        await storage.delete(key: "endAt");
        return false;
      }
    }
    return true;
  }
}
