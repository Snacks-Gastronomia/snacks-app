import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_button/group_button.dart';

import 'package:snacks_app/components/custom_submit_button.dart';
import 'package:snacks_app/core/app.routes.dart';
import 'package:snacks_app/core/app.text.dart';
import 'package:snacks_app/utils/toast.dart';
import 'package:snacks_app/views/review/state/cubit/review_cubit.dart';

import './widgets/review_widget.dart';

class ReviewScreen extends StatelessWidget {
  ReviewScreen({Key? key}) : super(key: key);
  final controller = PageController(initialPage: 0, keepPage: true);
  final toast = AppToast();
  @override
  Widget build(BuildContext context) {
    // final screens = [
    //   FeedbackForm(
    //     onSubmit: () {
    //       controller.nextPage(
    //           duration: const Duration(milliseconds: 600),
    //           curve: Curves.easeInOut);
    //     },
    //   ),
    //   ObservationWidget(controller: controller),
    //   const FinishedForm()
    // ];
    return SafeArea(
      child: Scaffold(body: BlocBuilder<ReviewCubit, ReviewState>(
        builder: (context, state) {
          // return FeedbackForm();
          return Padding(
              padding: const EdgeInsets.all(20.0),
              child: PageView(
                  controller: controller,
                  // itemCount: state.questions.length + 2,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    FeedbackForm(
                      onSubmit: () {
                        controller.nextPage(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeInOut);
                      },
                    ),
                    ObservationWidget(onSubmit: () async {
                      var lowRateQ1 = int.parse(state.questions[0].rate) <= 6;
                      var lowRateQ2 = int.parse(state.questions[1].rate) <= 7;
                      var lowRateQ3 = ["Nada", "Pouco", "Moderadamente"]
                          .contains(state.questions[2].rate);

                      if ((lowRateQ1 || lowRateQ2 || lowRateQ3) &&
                          state.observations.isEmpty) {
                        toast.init(context: context);
                        toast.showToast(
                            context: context,
                            content:
                                "Diga algum coisa para continuarmos a melhorar. : )",
                            type: ToastType.info);
                      } else {
                        await context.read<ReviewCubit>().submit();
                        controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                      }
                    }),
                    const FinishedForm()
                  ]));
        },
      )),
    );
  }
}

class FeedbackForm extends StatelessWidget {
  const FeedbackForm({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);
  final VoidCallback onSubmit;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewCubit, ReviewState>(
      builder: (context, state) {
        return Column(
          children: [
            // Text('Nos ajude a melhorar!'),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Text(
                state.questions[0].title,
                textAlign: TextAlign.left,
                style: AppTextStyles.semiBold(16),
                // style: Theme.of(context).textTheme.headline,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            CustomRadioButton(
              onChange: (value) {
                context
                    .read<ReviewCubit>()
                    .changeQuestionValue(state.questions[0].id, value);
              },
              size: const Size(25, 25),
              circle: true,
              buttons: state.questions[0].values,
            ),
            const Spacer(),
            Center(
              child: Text(
                state.questions[1].title,
                textAlign: TextAlign.left,
                style: AppTextStyles.semiBold(16),
                // style: Theme.of(context).textTheme.headline,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            CustomRadioButton(
              circle: true,
              onChange: (value) {
                context
                    .read<ReviewCubit>()
                    .changeQuestionValue(state.questions[1].id, value);
              },
              size: const Size(30, 30),
              buttons: state.questions[1].values,
            ),
            const Spacer(),
            Center(
              child: Text(
                state.questions[2].title,
                textAlign: TextAlign.left,
                style: AppTextStyles.semiBold(16),
                // style: Theme.of(context).textTheme.headline,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            CustomRadioButton(
              circle: false,
              onChange: (value) {
                context
                    .read<ReviewCubit>()
                    .changeQuestionValue(state.questions[2].id, value);
              },
              size: const Size(100, 25),
              buttons: state.questions[2].values,
            ),
            const Spacer(),
            CustomSubmitButton(
                onPressedAction: context.read<ReviewCubit>().isFeedbackEmpty
                    ? () {}
                    : onSubmit,
                label: "Enviar avaliação",
                loading_label: "",
                loading: false)
          ],
        );
      },
    );
  }
}

class CustomRadioButton extends StatefulWidget {
  CustomRadioButton({
    Key? key,
    required this.onChange,
    required this.buttons,
    required this.size,
    required this.circle,
  }) : super(key: key);
  final Function(String) onChange;
  final List<String> buttons;
  final Size size;
  final bool circle;

  @override
  State<CustomRadioButton> createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  final controller = GroupButtonController(

      // onDisablePressed: (i) => print('Button #$i is disabled'),
      );

  @override
  Widget build(BuildContext context) {
    return GroupButton(
      controller: controller,
      isRadio: true,
      options: const GroupButtonOptions(spacing: 7),
      buttonBuilder: (selected, value, context) {
        return Container(
          width: widget.size.width,
          height: widget.size.height,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(widget.circle ? 50 : 5),
            // shape: circle ? BoxShape.circle : BoxShape.rectangle,

            border: Border.fromBorderSide(BorderSide(
                color: selected ? getColor(value, widget.circle) : Colors.black
                // color: selected ? Colors.black
                )),
          ),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: selected ? getColor(value, widget.circle) : Colors.white,
              // shape: BoxShape.circle
              borderRadius: BorderRadius.circular(widget.circle ? 50 : 3),
            ),
            child: Center(
              child: Text(
                value.toString(),
                style: AppTextStyles.medium(11),
              ),
            ),
          ),
        );
      },
      buttons: widget.buttons,
      maxSelected: 1,
      // onSelected: (val, i, selected) => onChange(val),
      onSelected: (val, i, selected) {
        setState(() {
          controller.selectIndex(i);
        });
        widget.onChange(val);
      },
    );
  }

  Color getColor(String el, bool number) {
    if (number) {
      int value = int.parse(el);
      if (value <= 6) {
        return Colors.red;
      } else if (value <= 8) {
        return Colors.orange;
      } else {
        return Colors.green;
      }
    } else {
      return Colors.blue.shade400;
    }
  }
}

class ObservationWidget extends StatelessWidget {
  const ObservationWidget({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);
  final VoidCallback onSubmit;
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
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            filled: false,
            hintStyle: AppTextStyles.semiBold(16, color: Colors.black38),
            hintText: 'Escreva aqui suas sugestões',
            border: InputBorder.none,
            counterText: "",
            contentPadding: EdgeInsets.zero,
          ),
          maxLength: 1000,
          onChanged: context.read<ReviewCubit>().changeObservation,
          maxLines: 10,
        ),
        const Spacer(),
        CustomSubmitButton(
            onPressedAction: onSubmit,
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
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home,
                  ModalRoute.withName(AppRoutes.start));
            },
            label: "Fechar",
            loading_label: "",
            loading: false)
      ],
    );
  }
}
