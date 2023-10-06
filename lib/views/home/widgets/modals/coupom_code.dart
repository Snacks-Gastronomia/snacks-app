// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:snacks_app/components/custom_submit_button.dart';
import 'package:snacks_app/core/app.text.dart';
import 'package:snacks_app/services/coupons_service.dart';

import 'package:snacks_app/views/home/state/item_screen/item_screen_cubit.dart';

class CoupomCode extends StatelessWidget {
  CoupomCode({
    Key? key,
    required this.restaurantId,
    required this.context,
  }) : super(key: key);
  final String restaurantId;
  final BuildContext context;

  final service = CouponsService();

  @override
  Widget build(context) {
    TextEditingController controllerCode = TextEditingController();

    final cubit = context.read<ItemScreenCubit>();

    return BlocBuilder<ItemScreenCubit, ItemScreenState>(
        bloc: cubit,
        builder: (context, snapshot) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 30,
                left: 30,
                right: 30),
            child: Column(
              children: [
                Text(
                  "Código do Cupom",
                  style: AppTextStyles.semiBold(22),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  textAlign: TextAlign.center,
                  controller: controllerCode,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: "EX: CUPOM10"),
                  style: const TextStyle(
                      fontSize: 30,
                      color: Colors.green,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 43,
                ),
                CustomSubmitButton(
                    onPressedAction: () async {
                      cubit.addCoupom(
                          controllerCode.text, restaurantId, context);

                      Navigator.pop(context);
                    },
                    label: "Aplicar",
                    loading_label: "Carregando",
                    loading: false),
                const SizedBox(
                  height: 18,
                ),
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Cancelar",
                      style: TextStyle(color: Colors.red),
                    ))
              ],
            ),
          );
        });
  }
}
