import 'package:flutter/material.dart';
import 'package:snacks_app/core/app.routes.dart';
import 'package:snacks_app/core/app.text.dart';
import 'package:snacks_app/views/home/payment_screen.dart';

class DivideValueModal extends StatelessWidget {
  const DivideValueModal({super.key});

  @override
  Widget build(BuildContext context) {
    var navigator = Navigator.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
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
              navigator.push(MaterialPageRoute(
                  builder: (context) => const PaymentScreen(
                        dividevalue: true,
                      )));
            },
            child: const Text(
              'Sim',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )),
        const SizedBox(
          height: 10,
        ),
        TextButton(
            onPressed: () {
              navigator.pushNamed(
                AppRoutes.payment,
              );
            },
            child: Text(
              'Não',
              style: AppTextStyles.bold(16),
            ))
      ]),
    );
  }
}