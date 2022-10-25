import 'dart:math';

import 'package:snacks_app/models/employee_model.dart';

class EmployeesApiServices {
  List<EmployeeModel> employees = List.generate(
      10,
      (index) => EmployeeModel(
          id: "id-$index",
          name: "Severino Hugo $index",
          phone_number: "(51) 3732-2936",
          ocupation: "Barmen",
          salary: 1200 + (10.0 * index),
          access: index % 2 == 0 ? true : false));

  Future<List<EmployeeModel>> getEmployees(String restaurant_id) async {
    return Future.delayed(Duration(milliseconds: 600), () {
      return employees;
    });
  }

  Future<void> changeAccess(bool access, String employee_id) async {
    return Future.delayed(Duration(milliseconds: 600), () {
      employees.firstWhere((element) {
        if (element.id == employee_id) {
          element.copyWith(access: access);
          return true;
        }
        return false;
      });
    });
  }

  Future<void> deleteEmployee(String employee_id) async {
    return Future.delayed(Duration(milliseconds: 600),
        () => employees.removeWhere((element) => element.id == employee_id));
  }

  Future<void> updateEmployee(EmployeeModel emp) async {
    return Future.delayed(Duration(milliseconds: 600), () {
      employees.firstWhere((element) {
        if (element.id == emp.id) {
          element = emp;
          return true;
        }
        return false;
      });
    });
  }

  Future<void> postEmployee(EmployeeModel emp) async {
    var rng = Random();
    return Future.delayed(Duration(milliseconds: 600), () {
      emp.copyWith(id: 'id-${(rng.nextInt(100) + 10)}');
      employees.add(emp);
    });
  }
}
