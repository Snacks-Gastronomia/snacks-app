import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

import 'package:snacks_app/core/app.routes.dart';
import 'package:snacks_app/core/app.text.dart';
import 'package:snacks_app/utils/enums.dart';
import 'package:snacks_app/utils/toast.dart';
import 'package:snacks_app/views/authentication/state/auth_cubit.dart';
import 'package:snacks_app/views/authentication/state/auth_state.dart';

class FilledRoundedPinPut extends StatelessWidget {
  const FilledRoundedPinPut({
    Key? key,
    required this.onCompleted,
    required this.controller,
    required this.focusNode,
  }) : super(key: key);

  final Future Function(String) onCompleted;
  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    // const borderColor = Color.fromRGBO(114, 178, 238, 1);
    const length = 6;
    const borderColor = Color(0xff35C2C1);
    const errorColor = Color.fromRGBO(255, 234, 238, 1);
    const fillColor = Color.fromRGBO(222, 231, 240, .57);
    final defaultPinTheme = PinTheme(
      width: 75,
      height: 70,
      textStyle: AppTextStyles.semiBold(22),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return SizedBox(
          height: 120,
          child: Pinput(
            length: length,
            separator: const SizedBox(
              width: 8,
            ),
            controller: controller,
            focusNode: focusNode,
            // autofocus: true,
            defaultPinTheme: defaultPinTheme,
            onCompleted: onCompleted,
            onTap: () => state.status == AppStatus.error
                ? context.read<AuthCubit>().changeStatus(AppStatus.initial)
                : null,
            forceErrorState: state.status == AppStatus.error,
            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
            focusedPinTheme: defaultPinTheme.copyWith(
              width: 83,
              height: 78,
              decoration: defaultPinTheme.decoration!.copyWith(
                border: Border.all(color: borderColor),
              ),
            ),
            // errorText: "Código ionválido",
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[0-9]")),
            ], // Only numbers can be entered
            errorPinTheme: defaultPinTheme.copyWith(
              decoration: BoxDecoration(
                color: errorColor,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        );
      },
    );
  }
}
