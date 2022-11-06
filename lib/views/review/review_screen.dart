import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:snacks_app/components/custom_submit_button.dart';
import 'package:snacks_app/core/app.text.dart';
import 'package:snacks_app/views/review/state/cubit/review_cubit.dart';

import './widgets/review_widget.dart';

class ReviewScreen extends StatelessWidget {
  ReviewScreen({Key? key}) : super(key: key);
  final controller = PageController(initialPage: 0, keepPage: true);

  @override
  Widget build(BuildContext context) {
    final screens = [
      ObservationWidget(controller: controller),
      const FinishedForm()
    ];
    return SafeArea(
      child: Scaffold(body: BlocBuilder<ReviewCubit, ReviewState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: PageView.builder(
              controller: controller,
              itemCount: state.questions.length + 2,
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                if (index <= state.questions.length - 1) {
                  var question = state.questions[index];
                  return ReviewWidget(
                    title: question.title,
                    values: question.values,
                    onSubmit: (value) {
                      context
                          .read<ReviewCubit>()
                          .changeQuestionValue(question.id, value);
                      controller.nextPage(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeInOut);
                    },
                  );
                } else {
                  return screens[index - 3];
                }
              },
            ),
          );
        },
      )),
    );
  }
}

class ObservationWidget extends StatelessWidget {
  const ObservationWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final PageController controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sugestões para melhorias, críticas e elogios.',
          style: AppTextStyles.semiBold(24),
        ),
        const SizedBox(
          height: 5,
        ),
        BlocBuilder<ReviewCubit, ReviewState>(
          builder: (context, state) {
            return Text(
              '${1000 - state.observations.length} caracteres restantes',
              style: AppTextStyles.light(14, color: Colors.black38),
            );
          },
        ),
        const SizedBox(
          height: 15,
        ),
        TextField(
          decoration: InputDecoration(
            filled: false,
            hintStyle: AppTextStyles.semiBold(16, color: Colors.black38),
            hintText: 'Escreva aqui suas sugestões',
            border: InputBorder.none,
            counterText: "",
            contentPadding: EdgeInsets.zero,
          ),
          maxLength: 30,
          onChanged: context.read<ReviewCubit>().changeObservation,
          maxLines: 6,
        ),
        const Spacer(),
        CustomSubmitButton(
            onPressedAction: () async {
              await context.read<ReviewCubit>().submit();
              // Navigator.pop(context);
              controller.nextPage(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
            },
            label: "Feito",
            loading_label: "",
            loading: false)
      ],
    );
  }
}

class FinishedForm extends StatelessWidget {
  const FinishedForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.star_rounded,
          size: 250,
          color: Color(0xffFFCA44),
        ),
        const SizedBox(
          height: 50,
        ),
        Text(
          'Muito obrigado!!!\n'
          'O snacks agradece seu feedback! ; -)',
          style: AppTextStyles.regular(22),
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        CustomSubmitButton(
            onPressedAction: () {
              // context.read<ReviewCubit>().submit();
              Navigator.pop(context);
            },
            label: "Fechar",
            loading_label: "",
            loading: false)
      ],
    );
  }
}
