import 'package:snacks_app/services/beerpass_service.dart';

class CardRepository {
  final services = BeerPassService();

  Future doPayment(String rfid, double value) async {
    return await services.payWithSnacksCard(rfid, value);
  }

  Future<dynamic> fetchCard(String rfid) async {
    return await services.getCard(rfid);
  }
}
