part of 'card_cubit.dart';

class CardState {
  final String nome;
  final double value;
  final bool hasData;
  final AppStatus status;
  CardState({
    required this.nome,
    required this.value,
    required this.hasData,
    required this.status,
  });

  factory CardState.initial() =>
      CardState(nome: "", value: 0, hasData: false, status: AppStatus.initial);

  CardState copyWith({
    String? nome,
    double? value,
    bool? hasData,
    AppStatus? status,
  }) {
    return CardState(
      nome: nome ?? this.nome,
      value: value ?? this.value,
      hasData: hasData ?? this.hasData,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'CardState(nome: $nome, value: $value, hasData: $hasData, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CardState &&
        other.nome == nome &&
        other.value == value &&
        other.hasData == hasData &&
        other.status == status;
  }

  @override
  int get hashCode {
    return nome.hashCode ^ value.hashCode ^ hasData.hashCode ^ status.hashCode;
  }
}
