import 'package:flutter/material.dart';
import 'package:snacks_app/components/custom_submit_button.dart';
import 'package:snacks_app/core/app.text.dart';

class MoneyChangeOptionModal extends StatelessWidget {
  const MoneyChangeOptionModal({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Text(
            'Você precisará de troco?',
            style: AppTextStyles.regular(20),
          ),
          const SizedBox(
            height: 30,
          ),
          CustomSubmitButton(
            onPressedAction: () => Navigator.pop(context, true),
            label: "Sim",
            loading_label: "",
            loading: false,
          ),
          const SizedBox(
            height: 15,
          ),
          CustomSubmitButton(
            onPressedAction: () => Navigator.pop(context, false),
            label: "Não",
            dark_theme: false,
            loading_label: "",
            loading: false,
          ),
          // Row(
          //   children: [
          //   ],
          // )
        ],
      ),
    );
  }
}
