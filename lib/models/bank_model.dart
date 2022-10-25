import 'dart:convert';

class BankModel {
  final String? id;
  final String owner;
  final String bank;
  final String account;
  final String agency;
  BankModel({
    this.id,
    required this.owner,
    required this.bank,
    required this.account,
    required this.agency,
  });

  factory BankModel.initial() =>
      BankModel(owner: "", bank: "", account: "", agency: "");
  BankModel copyWith({
    String? id,
    String? owner,
    String? bank,
    String? account,
    String? agency,
  }) {
    return BankModel(
      id: id ?? this.id,
      owner: owner ?? this.owner,
      bank: bank ?? this.bank,
      account: account ?? this.account,
      agency: agency ?? this.agency,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'owner': owner,
      'bank': bank,
      'account': account,
      'agency': agency,
    };
  }

  factory BankModel.fromMap(Map<String, dynamic> map) {
    return BankModel(
      id: map['id'],
      owner: map['owner'] ?? '',
      bank: map['bank'] ?? '',
      account: map['account'] ?? '',
      agency: map['agency'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory BankModel.fromJson(String source) =>
      BankModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BankModel(id: $id, owner: $owner, bank: $bank, account: $account, agency: $agency)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BankModel &&
        other.id == id &&
        other.owner == owner &&
        other.bank == bank &&
        other.account == account &&
        other.agency == agency;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        owner.hashCode ^
        bank.hashCode ^
        account.hashCode ^
        agency.hashCode;
  }
}
