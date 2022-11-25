part of 'review_cubit.dart';

class Question {
  final int id;
  final String title;
  final int rate;
  final List<String> values;
  Question({
    required this.id,
    required this.title,
    required this.rate,
    required this.values,
  });

  Question copyWith({
    int? id,
    String? title,
    int? rate,
    List<String>? values,
  }) {
    return Question(
      id: id ?? this.id,
      title: title ?? this.title,
      rate: rate ?? this.rate,
      values: values ?? this.values,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Question &&
        other.id == id &&
        other.title == title &&
        other.rate == rate;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ rate.hashCode ^ values.hashCode;
  }
}

class ReviewState {
  final List<Question> questions;
  final String observations;
  ReviewState({
    required this.questions,
    required this.observations,
  });

  ReviewState copyWith({
    List<Question>? quetions,
    String? observations,
  }) {
    return ReviewState(
      questions: quetions ?? this.questions,
      observations: observations ?? this.observations,
    );
  }

  factory ReviewState.initial() => ReviewState(questions: [
        Question(
            id: 1,
            title: "Você indicaria o Snacks para um amigo?",
            rate: 0,
            values: [
              "Não",
              "Talvez",
              "Sim",
              "Super indicaria!",
            ]),
        Question(
            id: 2,
            title: "O que você achou da usabilidade do nosso aplicativo?",
            rate: 0,
            values: ["Ruim", "Podia ser melhor", "Boa", "Muito boa!"]),
        Question(
            id: 3,
            title:
                "O quanto você está satisfeito, em termos gerais, com a nossa empresa?",
            rate: 0,
            values: ["Nem um pouco", "Não", "Sim", "Muito satisfeito!"]),
      ], observations: "");

  @override
  String toString() =>
      'ReviewState(quetions: $questions, observations: $observations)';

  @override
  int get hashCode => questions.hashCode ^ observations.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReviewState &&
        listEquals(other.questions, questions) &&
        other.observations == observations;
  }
}
