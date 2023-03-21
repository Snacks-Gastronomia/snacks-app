import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

import 'package:snacks_app/components/custom_submit_button.dart';
import 'package:snacks_app/core/app.text.dart';

class MoneyChangeValue extends StatelessWidget {
  MoneyChangeValue({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);
  final Function(String) onSubmit;

  final controller = MoneyMaskedTextController(leftSymbol: r'R$ ');
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        children: [
          Text(
            'Quanto de troco você precisa?',
            style: AppTextStyles.medium(16),
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 100,
            child: TextField(
              textInputAction: TextInputAction.done,
              style: AppTextStyles.semiBold(50, color: Colors.black),
              decoration: InputDecoration(
                filled: false,
                hintStyle: AppTextStyles.semiBold(50, color: Colors.black26),
                hintText: r'R$ 0,00',
                border: InputBorder.none,
                counterText: "",
                contentPadding: EdgeInsets.zero,
              ),
              textAlign: TextAlign.center,
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              maxLength: 30,
              controller: controller,
              maxLines: 6,
            ),
          ),
          const SizedBox(height: 15),
          CustomSubmitButton(
            onPressedAction: () {
              onSubmit(controller.text);
              Navigator.pop(context);
            },
            label: "Enviar",
            loading_label: "",
            loading: false,
          ),
        ],
      ),
    );
  }
}
