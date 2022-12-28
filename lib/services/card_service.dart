import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class CardService {
  final http.Client httpClient = http.Client();
  static const URL = "us-central1-beerpass-1500423500833.cloudfunctions.net";

  Future<dynamic> getCard(String rfid) async {
    try {
      var header = await getReqHeader();

      var response = await httpClient.get(
        Uri.https(URL, "apiv2/comandas", {"rfid": rfid}),
        headers: header,
      );
      var body = [];
      if (response.statusCode == 200) {
        body = List.from(jsonDecode(response.body));
      }

      return body.isNotEmpty ? body[0] : null;
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> payment(String rfid, double value) async {
    try {
      var header = await getReqHeader();

      var card = await getCard(rfid);

      if (card["value"] < value) throw "Saldo insuficiente";
      var total = card["saldo"] - value;

      await rechargeCard(rfid, total);
    } catch (e) {
      print(e);
    }
  }

  Future<void> rechargeCard(rfid, double valor) async {
    var data = {
      "rfid": rfid,
      "tipoPagamento": "money",
      "valor": valor,
    };
    var header = await getReqHeader();
    var response = await httpClient.post(
        Uri.https(URL, "apiv2/comandas/recarregar"),
        body: jsonEncode(data),
        headers: header);

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
    } else {
      print(response.statusCode);
    }
  }

  Future<Map<String, String>> getReqHeader() async {
    return {
      "Authorization": await getToken() ?? "",
      "Content-Type": "application/json",
    };
  }

  Future<String?> getToken() async {
    try {
      await Hive.initFlutter();
      Box box = await Hive.openBox('token');

      var token = box.get('value');

      if (token == null || JwtDecoder.isExpired(token)) {
        var response = await httpClient.get(Uri.https(
            URL,
            "apiv2/autenticacao/obter-token",
            {"usuario": "snacks", "senha": r"sDbw203@#$nd234"}));

        var body = jsonDecode(response.body)["token"];
        box.put('value', body);
      }

      box.close();
      return token;
    } catch (e) {
      print(e);
    }
  }
}
