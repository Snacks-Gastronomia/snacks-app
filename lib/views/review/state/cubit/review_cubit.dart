import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:snacks_app/services/firebase/database.dart';

part 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final db = FirebaseDataBase();
  final auth = FirebaseAuth.instance;
  ReviewCubit() : super(ReviewState.initial());

  void changeQuestionValue(int id, String value) {
    List<Question> quests = List.from(state.questions);

    quests =
        quests.map((e) => id == e.id ? e.copyWith(rate: value) : e).toList();

    emit(state.copyWith(questions: quests));
  }

  changeObservation(String value) {
    emit(state.copyWith(observations: value));
  }

  get isFeedbackEmpty =>
      state.questions[0].rate.isEmpty ||
      state.questions[1].rate.isEmpty ||
      state.questions[2].rate.isEmpty;

  Future<void> submit() async {
    var questions = state.questions
        .map((e) => {"question": e.title, "rate": e.rate})
        .toList();
    var data = {
      "questions": FieldValue.arrayUnion(questions),
      "observations": state.observations,
      "customer_name": auth.currentUser?.displayName,
      "created_at": FieldValue.serverTimestamp()
    };
    await db.createDocumentToCollection(collection: "feedbacks", data: data);
  }
}
