import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:snacks_app/services/firebase/database.dart';

part 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final db = FirebaseDataBase();
  ReviewCubit() : super(ReviewState.initial());

  changeQuestionValue(int id, int value) {
    List<Question> quets = List.from(state.questions);

    for (var element in quets) {
      if (id == element.id) element.copyWith(evaluation: value);
    }

    emit(state.copyWith(quetions: quets));
  }

  changeObservation(String value) {
    emit(state.copyWith(observations: value));
  }

  Future<void> submit() async {
    var questions = state.questions
        .map((e) => {"question": e.title, "rate": e.evaluation})
        .toList();

    var data = {
      "questions": FieldValue.arrayUnion(questions),
      "observations": state.observations
    };

    await db.createDocumentToCollection(collection: "feedbacks", data: data);

    debugPrint(data.toString());
  }
}
