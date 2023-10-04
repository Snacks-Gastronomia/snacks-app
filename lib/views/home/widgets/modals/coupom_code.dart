import 'package:flutter/material.dart';
import 'package:snacks_app/components/custom_submit_button.dart';
import 'package:snacks_app/core/app.text.dart';

class CoupomCode extends StatelessWidget {
  CoupomCode({super.key});

  TextEditingController controllerCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                fontSize: 30, color: Colors.green, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 43,
          ),
          CustomSubmitButton(
              onPressedAction: () {},
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
  }
}
