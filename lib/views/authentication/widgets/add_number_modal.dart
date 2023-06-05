import 'package:flutter/material.dart';
import 'package:snacks_app/core/app.text.dart';

class AddAddressNumber extends StatelessWidget {
  AddAddressNumber({
    Key? key,
    required this.action,
  }) : super(key: key);
  final Function(String) action;
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        children: [
          Text(
            "Adicione um número ao endereço",
            textAlign: TextAlign.center,
            style: AppTextStyles.regular(16),
          ),
          const SizedBox(height: 20),
          Center(
            child: TextField(
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              controller: controller,
              textAlign: TextAlign.center,
              style: AppTextStyles.semiBold(26, color: Colors.black),
              decoration: InputDecoration(
                filled: false,
                hintStyle: AppTextStyles.semiBold(26, color: Colors.black38),
                hintText: 'Ex: 80',
                border: InputBorder.none,
                counterText: "",
                contentPadding: EdgeInsets.zero,
              ),
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => action(controller.text),
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                backgroundColor: Colors.black,
                fixedSize: const Size(double.maxFinite, 59)),
            child: Text(
              'Adicionar',
              style: AppTextStyles.regular(16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
