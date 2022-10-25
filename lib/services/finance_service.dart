import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:snacks_app/models/bank_model.dart';

import 'package:snacks_app/models/item_model.dart';

class FinanceApiServices {
  final http.Client httpClient = http.Client();

  Future<int> getOrdersCount(String restaurant_id) async {
    return Future.delayed(Duration(milliseconds: 600), () {
      return 257;
    });
  }

  Future<int> getEmployeesCount(String restaurant_id) async {
    return Future.delayed(Duration(milliseconds: 600), () {
      return 5;
    });
  }

  Future<double> getMonthlyBudget(String restaurant_id) async {
    return Future.delayed(Duration(milliseconds: 600), () {
      return 25200.55;
    });
  }

  Future<BankModel> getBankInformations(String user_id) async {
    return Future.delayed(Duration(milliseconds: 600), () {
      return BankModel.fromMap({
        "id": "002",
        "owner": "Jose Ricardo Silva",
        "bank": "Banco Inter SA",
        "account": "999999-99",
        "agency": "0001",
      });
    });
  }

  Future<void> addBankInformation(dynamic data) async {
    // return Future.delayed(Duration(milliseconds: 600), () {
    //   return 25200.55;
    // });
  }
}
