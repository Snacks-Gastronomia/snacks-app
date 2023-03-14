import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'package:snacks_app/models/item_model.dart';
import 'package:snacks_app/services/firebase/database.dart';
import 'package:snacks_app/services/firebase/phone_auth.dart';

class GeocodingResponse {
  final String text;
  final String place_name;

  GeocodingResponse({
    required this.text,
    required this.place_name,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'place_name': place_name,
    };
  }

  factory GeocodingResponse.fromMap(Map<String, dynamic> map) {
    return GeocodingResponse(
      text: map['text'] ?? '',
      place_name: map['place_name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory GeocodingResponse.fromJson(String source) =>
      GeocodingResponse.fromMap(json.decode(source));
}

class AuthApiServices {
  final db = FirebaseDataBase();
  final fbauth = FirebasePhoneAuthentication();
  final ff = FirebaseFirestore.instance;
  final http.Client httpClient = http.Client();

  Future<void> postUser(
      {required String name,
      required String phone,
      required String address}) async {
    print({name, phone, address});
  }

  Future<void> creatUser({required String address, required String uid}) async {
    Map<String, String> data = {
      "uid": uid,
      "address": address,
    };
    try {
      await db.createDocumentToCollection(collection: "users", data: data);
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateAuthUser({required String name}) async {
    await FirebaseAuth.instance.currentUser?.updateDisplayName(name);
  }

  Future<User?> otpValidation(String verificationID, String pin) async {
    try {
      final user = await fbauth.verifyCode(verificationID, pin);
      print(user);
      return user;
    } catch (e) {
      print(e);
    }
  }

  Future<List> fetchAddresses(String query) async {
    List<GeocodingResponse> list = [];
    const mapbox_token =
        "pk.eyJ1IjoiamFja3Nvbi1hZ3VpYXIyMiIsImEiOiJja3lsa3Y3c2kweXE1MzFwMHE0ZGFrbWFkIn0.joULi-b9eXkZiUSLg-54mA";
    var path = '/geocoding/v5/mapbox.places/$query' 'Brazil.json';
    var params = {
      "country": "br",
      "autocomplete": "true",
      "access_token": mapbox_token
    };
    final url = Uri.https("api.mapbox.com", path, params);

    final http.Response response = await httpClient.get(url);
    if (response.statusCode != 200) {
      print(response.body);
    }
    final responseBody = jsonDecode(response.body);

    List<dynamic> items = responseBody["features"];
    for (var item in items) {
      list.add(GeocodingResponse.fromMap(item));
    }

    return list;
  }

  Future<String?> sendOtpCode(String number) async {
    try {
      return await fbauth.sendCode(number);
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> getAddressFromCoordinates(lat, long) async {
    try {
      var path = '/reverse';
      var params = {"format": "json", "lat": '$lat', "lon": '$long'};
      final url = Uri.https("nominatim.openstreetmap.org", path, params);
      print(url);
      final http.Response response = await httpClient.get(url);
      if (response.statusCode != 200) {
        print(response.body);
      }
      final responseBody = json.decode(response.body);
      return responseBody;
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>?> userAlreadyRegistred(String uid) async {
    final doc =
        await db.readDocumentToCollectionByUid(collection: "users", uid: uid);
    var docs = doc.docs;
    return docs.isEmpty ? null : docs[0].data();
  }

  Future<void> deleteAddress(String uid) async {
    final doc =
        await db.readDocumentToCollectionByUid(collection: "users", uid: uid);
    var docs = doc.docs;
    if (docs.isNotEmpty) {
      return await ff.collection("users").doc(docs[0].id).delete();
    }
  }

  Future<void> updateAddress(String address, String uid) async {
    final doc =
        await db.readDocumentToCollectionByUid(collection: "users", uid: uid);
    var docs = doc.docs;
    var data = docs.isEmpty ? null : docs[0];

    return await db.updateDocumentToCollectionById(
        collection: "users", id: data?.id ?? "", data: {"address": address});
  }
}
