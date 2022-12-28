import 'package:snacks_app/services/card_service.dart';

class CardRepository {
  final services = CardService();

  Future doPayment(String rfid, double value) async {
    return await services.payment(rfid, value);
  }

  Future<dynamic> fetchCard(String rfid) async {
    return await services.getCard(rfid);
  }
}
