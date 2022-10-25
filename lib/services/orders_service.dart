import 'package:intl/intl.dart';

class OrdersApiServices {
  List<dynamic> days = [
    {"date": "2022-05-22 08:35:39", "count": 23, "amount": 2.300},
    {"date": "2022-05-24 08:35:39", "count": 23, "amount": 2.300},
    {"date": "2022-05-26 08:35:39", "count": 23, "amount": 2.300},
    {"date": "2022-06-27 08:35:39", "count": 23, "amount": 2.300},
    {"date": "2022-07-28 08:35:39", "count": 23, "amount": 2.300},
  ];
  List<dynamic> orders = [
    {
      "date": "26/05/2022",
      "method": "Cartão de crédito",
      "value": 22.05,
      "items": [
        "1 coca-cola",
        "1 Batata G",
        "1 X-burguer",
      ]
    },
    {
      "date": "26/05/2022",
      "method": "Cartão Snacks",
      "value": 78.30,
      "items": [
        "1 coca-cola",
        "1 Batata G",
        "1 X-burguer",
      ]
    },
    {
      "date": "26/05/2022",
      "method": "Pix",
      "value": 10.05,
      "items": [
        "1 coca-cola",
        "1 Batata G",
        "1 X-burguer",
      ]
    },
    {
      "date": "27/05/2022",
      "method": "Pix",
      "value": 18.05,
      "items": [
        "1 coca-cola",
        "1 Batata G",
        "1 X-burguer",
      ]
    },
    {
      "date": "28/05/2022",
      "method": "Cartão de crédito",
      "value": 22.55,
      "items": [
        "1 coca-cola",
        "1 Batata G",
        "1 X-burguer",
      ]
    },
  ];
  Future<dynamic> getOrdersByDay(int day, String id) async {
    return Future.delayed(Duration(milliseconds: 600), () {
      return orders
          .where((element) => DateFormat.d().format(element["date"]) == day);
    });
  }

  Future<dynamic> getOrdersByMonth(int month, String id) async {
    print(DateFormat.M().format(DateTime.parse("2022-06-27 08:35:39")));
    return Future.delayed(Duration(milliseconds: 600), () {
      return days.where((element) =>
          DateFormat.M().format(DateTime.parse(element["date"])) ==
          month.toString());
    });
  }
}
