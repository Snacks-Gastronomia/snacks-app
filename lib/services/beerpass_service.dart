import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

class BeerPassService {
  final http.Client httpClient = http.Client();
  static const URL = "us-central1-beerpass-1500423500833.cloudfunctions.net";

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
            {"usuario": "beersnack", "senha": r"$@BeeSnckhsa2023"}));

        var body = jsonDecode(response.body)["token"];
        box.put('value', body);
      }

      box.close();
      return token;
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> getCard(String rfid) async {
    try {
      var header = await getReqHeader();
      var data = {"rfid": rfid};
      var response = await httpClient
          .get(Uri.https(URL, "apiv2/comandas", data), headers: header);
      if (response.statusCode == 200) {
        List body = jsonDecode(response.body);
        return body.isNotEmpty ? body[0] : null;
      }
      return null;
    } catch (e) {
      print(e);
    }
  }

  Future<void> payWithSnacksCard(String rfid, double value) async {
    try {
      var header = await getReqHeader();
      var data = {"rfid": rfid, "value": value, "type": "pre"};
      var response = await httpClient.post(Uri.https(URL, "apiv2/consumos"),
          body: jsonEncode(data), headers: header);

      if (response.statusCode != 200) {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }
}
