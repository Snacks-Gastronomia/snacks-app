import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:snacks_app/core/app.text.dart';

class TopayModal extends StatelessWidget {
  TopayModal({super.key, required this.maxValue});
  final double maxValue;

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var navigator = Navigator.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 30,
            left: 30,
            right: 30),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              "Qual o valor?",
              style: AppTextStyles.bold(24),
            ),
            SizedBox(
              width: 190,
              height: 100,
              child: TextFormField(
                autofocus: true,
                textAlign: TextAlign.center,
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "R\$ 7,00",
                  hintStyle: AppTextStyles.bold(50, color: Colors.black26),
                ),
                style: AppTextStyles.bold(50, color: Colors.black),
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    backgroundColor: Colors.black,
                    fixedSize: const Size(double.maxFinite, 59)),
                onPressed: () => controller.text.isNotEmpty &&
                        double.parse(controller.text.replaceAll(",", '.')) <=
                            maxValue
                    ? navigator.pop(controller.text.replaceAll(",", '.'))
                    : null,
                child: const Text('Pagar')),
            const SizedBox(
              height: 10,
            ),
            TextButton(
                onPressed: () {
                  navigator.pop();
                },
                child: Text(
                  'Cancelar',
                  style: AppTextStyles.bold(14),
                ))
          ],
        ),
      ),
    );
  }
}