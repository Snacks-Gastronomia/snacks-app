class CoupomModel {
  bool active;
  String code;
  int discount;
  CoupomModel({
    required this.active,
    required this.code,
    required this.discount,
  });

  factory CoupomModel.fromMap(Map<String, dynamic> map) {
    return CoupomModel(
      active: map['active'],
      code: map['code'],
      discount: map['discount'],
    );
  }
  factory CoupomModel.newCupom(String code, int discount) {
    return CoupomModel(
      active: true,
      code: code,
      discount: discount,
    );
  }

  static List<CoupomModel> fromData(List data) {
    return data.map((doc) => CoupomModel.fromMap(doc.data())).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      "active": active,
      "code": code,
      "discount": discount,
    };
  }
}
