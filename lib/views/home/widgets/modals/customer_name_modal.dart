// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:snacks_app/core/app.text.dart';
import 'package:snacks_app/utils/enums.dart';
import 'package:snacks_app/views/home/state/cart_state/cart_cubit.dart';
import 'package:snacks_app/views/home/state/home_state/home_cubit.dart';

import '../../../../components/custom_submit_button.dart';

class CustomerNameModal extends StatefulWidget {
  CustomerNameModal({
    Key? key,
    required this.onNameEntered,
  }) : super(key: key);

  final Function(String?) onNameEntered;

  @override
  State<CustomerNameModal> createState() => _CustomerNameModalState();
}

class _CustomerNameModalState extends State<CustomerNameModal> {
  final controller = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
            top: 25,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Como gostaria de ser chamado?',
              style: AppTextStyles.medium(18),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              style: AppTextStyles.medium(16, color: const Color(0xff8391A1)),
              controller: controller,
              maxLines: 1,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                fillColor: const Color(0xffF7F8F9),
                filled: true,
                hintStyle: AppTextStyles.medium(16,
                    color: const Color(0xff8391A1).withOpacity(0.5)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Color(0xffE8ECF4), width: 1)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Color(0xffE8ECF4), width: 1)),
                hintText: 'Ex.: João Ricardo',
              ),
            ),
            const SizedBox(height: 30),
            CustomSubmitButton(
              onPressedAction: () async {
                final nav = Navigator.of(context);

                if (controller.text.isNotEmpty) {
                  setState(() {
                    _isLoading = true;
                  });
                  widget.onNameEntered(controller.text);
                  await context
                      .read<HomeCubit>()
                      .setCustomerName(controller.text);
                  nav.pop();
                }
              },
              label: "Enviar pedido",
              loading_label: "Enviando",
              loading: _isLoading,
            ),
          ],
        ),
      );
    });
  }
}
