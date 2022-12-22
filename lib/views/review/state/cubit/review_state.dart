part of 'review_cubit.dart';

class Question {
  final int id;
  final String title;
  final String rate;
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
    String? rate,
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
  // final String rate1;
  // final String rate2;
  // final String rate3;
  ReviewState({
    required this.questions,
    required this.observations,
    // required this.rate1,
    // required this.rate2,
    // required this.rate3,
  });

  ReviewState copyWith({
    List<Question>? questions,
    String? observations,
    // String? rate1,
    // String? rate2,
    // String? rate3,
  }) {
    return ReviewState(
      questions: questions ?? this.questions,
      observations: observations ?? this.observations,
      // rate1: rate1 ?? this.rate1,
      // rate2: rate2 ?? this.rate2,
      // rate3: rate3 ?? this.rate3,
    );
  }

  factory ReviewState.initial() => ReviewState(
        questions: [
          Question(
            id: 1,
            title:
                ' Em uma escala de 0 a 10, você indicaria o Snacks para um amigo?',
            rate: "",
            values: List.generate(11, (i) => i.toString()),
          ),
          Question(
              id: 2,
              title:
                  'Em uma escala de 5 a 10, o que você achou da usabilidade do nosso aplicativo,'
                  ' sendo 10 para muito bom e 5 para muito ruim.',
              rate: "",
              values: const ["5", "6", "7", "8", "9", "10"]),
          Question(
              id: 3,
              title:
                  "O quanto você está satisfeito, em termos gerais, com a nossa empresa? ",
              rate: "",
              values: const [
                "Extremamente",
                "Muito",
                "Moderadamente",
                "Pouco",
                "Nada"
              ]),
        ],
        observations: "",

        //  rate1: '', rate2: '', rate3: ''
      );

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
    // other.rate1 == rate1 &&
    // other.rate2 == rate2 &&
    // other.rate3 == rate3;
  }
}
