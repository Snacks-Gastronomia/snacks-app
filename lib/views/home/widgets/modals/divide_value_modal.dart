import 'package:flutter/material.dart';
import 'package:snacks_app/core/app.routes.dart';
import 'package:snacks_app/core/app.text.dart';

class DivideValueModal extends StatelessWidget {
  const DivideValueModal({super.key});

  @override
  Widget build(BuildContext context) {
    var navigator = Navigator.of(context);

    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(children: [
        const SizedBox(
          height: 15,
        ),
        Text(
          'Pretende pagar entre os amigos?',
          style: AppTextStyles.bold(20),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
            'Cada um pode pagar valores diferentes, o pedido só irá para a cozinha quando for quitado o valor.'),
        const SizedBox(
          height: 25,
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                backgroundColor: Colors.black,
                fixedSize: const Size(double.maxFinite, 59)),
            onPressed: () {
              navigator.pushNamed(
                AppRoutes.payment,
              );
            },
            child: const Text('Sim')),
        const SizedBox(
          height: 10,
        ),
        TextButton(
            onPressed: () {
              navigator.pop();
            },
            child: Text(
              'Não',
              style: AppTextStyles.bold(14),
            ))
      ]),
    );
  }
}
