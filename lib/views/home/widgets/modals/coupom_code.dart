import 'package:flutter/material.dart';
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
            controller: controllerCode,
            style: const TextStyle(
              fontSize: 30,
            ),
          )
        ],
      ),
    );
  }
}
