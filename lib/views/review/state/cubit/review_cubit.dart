import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:snacks_app/services/firebase/database.dart';

part 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final db = FirebaseDataBase();
  ReviewCubit() : super(ReviewState.initial());

  changeQuestionValue(int id, int value) {
    List<Question> quests = List.from(state.questions);

    quests =
        quests.map((e) => id == e.id ? e.copyWith(rate: value) : e).toList();
    emit(state.copyWith(quetions: quests));
  }

  changeObservation(String value) {
    emit(state.copyWith(observations: value));
  }

  Future<void> submit() async {
    var questions = state.questions
        .map((e) => {"question": e.title, "rate": e.rate})
        .toList();
    var data = {
      "questions": FieldValue.arrayUnion(questions),
      "observations": state.observations
    };

    debugPrint(questions.toString());
    await db.createDocumentToCollection(collection: "feedbacks", data: data);

    debugPrint(data.toString());
  }
}
